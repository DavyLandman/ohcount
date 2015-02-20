@license{
	example license header
}
@contributor{Paul Klint - Paul.Klint@cwi.nl - CWI}
// Comments
module demo::lang::Exp

import String;
import ParseTree;                                                   

/*
	Grammars first!
*/
layout Whitespace = [\t-\n\r\ ]*;
lexical IntegerLiteral = [0-9]+;           

start syntax Exp 
  = IntegerLiteral          
  | bracket "(" Exp ")"     
  > left Exp "*" Exp        
  > left Exp "+" Exp        
  ;

/*
	Code follows grammar
*/
public int eval(str txt) = eval(parse(#start[Exp], txt).top);              

public int eval((Exp)`<IntegerLiteral l>`) = toInt("<l>");       
public int eval((Exp)`<Exp e1> * <Exp e2>`) = eval(e1) * eval(e2);  
public int eval((Exp)`<Exp e1> + <Exp e2>`) = eval(e1) + eval(e2); 
public int eval((Exp)`( <Exp e> )`) = eval(e);                    

// run me!
public value main(list[value] args) {
  return eval(" 2+3");
}

@memo
test bool tstEval1() = eval(" 7") == 7;
test bool tstEval2() = eval("7 * 3") == 21;
test bool tstEval3() = eval("7 + 3") == 10;
test bool tstEval3() = eval(" 3 + 4*5 ") == 23;
// comments here to
