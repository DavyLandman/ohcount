// rascal.rl written by Davy Landman. davy.landman<att>gmail<dott>com.
// inspired by java.rl and rust.rl

/************************* Required for every parser *************************/
#ifndef OHCOUNT_RASCAL_PARSER_H
#define OHCOUNT_RASCAL_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *RASCAL_LANG = LANG_RASCAL;

// the languages entities
const char *rascal_entities[] = {
  "space", "comment", "string", "number",
  "keyword", "identifier", "operator", "any"
};

// constants associated with the entities
enum {
  RASCAL_SPACE = 0, RASCAL_COMMENT, RASCAL_STRING, RASCAL_NUMBER,
  RASCAL_KEYWORD, RASCAL_IDENTIFIER, RASCAL_OPERATOR, RASCAL_ANY
};

/*****************************************************************************/

%%{
  machine rascal;
  write data;
  include common "common.rl";

  # Line counting machine

  action rascal_ccallback {
    switch(entity) {
    case RASCAL_SPACE:
      ls
      break;
    case RASCAL_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(RASCAL_LANG)
      break;
    case NEWLINE:
      std_newline(RASCAL_LANG)
    }
  }

  rascal_line_comment = '//' @comment nonnewline*;
  rascal_block_comment =
    '/*' @comment (
      newline %{ entity = INTERNAL_NL; } %rascal_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '*/';

  rascal_tag = 
    '@' ws* ('doc'|'license'|'contributor') ws* '{' @comment (
      newline %{ entity = INTERNAL_NL; } %rascal_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '}' @comment;
  rascal_comment = rascal_line_comment | rascal_block_comment | rascal_tag;
  
  rascal_string_normal = '"' @code ([^\r\n\f<>"'\\] | '\\' nonnewline)* '"';
  rascal_string_template_line = spaces '\''? ([^\r\n\f<>"'\\] | '\\' nonnewline)* @code newline ;
  rascal_string_template = '"' @code rascal_string_template_line+ @code :>> '"';
  rascal_string = rascal_string_normal | rascal_string_template;

  rascal_line := |*
    spaces        ${ entity = RASCAL_SPACE; } => rascal_ccallback;
    rascal_comment;
    rascal_string;
    newline       ${ entity = NEWLINE;    } => rascal_ccallback;
    ^space        ${ entity = RASCAL_ANY;   } => rascal_ccallback;
  *|;

  action rascal_ecallback {
    callback(RASCAL_LANG, rascal_entities[entity], cint(ts), cint(te), userdata);
  }

  rascal_line_comment_entity = '//' nonnewline*;
  rascal_block_comment_entity = '/*' any* :>> '*/';
  rascal_doc_tag_entity = '@' ws* ('doc' | 'license'|'contributor') (ws | newline)* '{' any* :>> '}';
  rascal_comment_entity = rascal_line_comment_entity | rascal_block_comment_entity | rascal_doc_tag_entity;

  rascal_entity := |*
    space+              ${ entity = RASCAL_SPACE;   } => rascal_ecallback;
    rascal_comment_entity ${ entity = RASCAL_COMMENT; } => rascal_ecallback;
    # TODO:
    ^space;
  *|;
}%%
/************************* Required for every parser *************************/

/* Parses a string buffer with Rascal code.
 *
 * @param *buffer The string to parse.
 * @param length The length of the string to parse.
 * @param count Integer flag specifying whether or not to count lines. If yes,
 *   uses the Ragel machine optimized for counting. Otherwise uses the Ragel
 *   machine optimized for returning entity positions.
 * @param *callback Callback function. If count is set, callback is called for
 *   every line of code, comment, or blank with 'lcode', 'lcomment', and
 *   'lblank' respectively. Otherwise callback is called for each entity found.
 */
void parse_rascal(char *buffer, int length, int count,
                void (*callback) (const char *lang, const char *entity, int s,
                                  int e, void *udata),
                void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? rascal_en_rascal_line : rascal_en_rascal_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(RASCAL_LANG) }
}

#endif

/*****************************************************************************/
