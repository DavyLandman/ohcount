rascal	code	@license{
rascal	code		example license header
rascal	code	}
rascal	code	@contributor{Paul Klint - Paul.Klint@cwi.nl - CWI}
rascal	comment	// Comments
rascal	code	module demo::lang::Exp
rascal	blank	
rascal	code	import String;
rascal	code	import ParseTree;                                                   
rascal	blank	
rascal	comment	/*
rascal	comment		Grammars first!
rascal	comment	*/
rascal	code	layout Whitespace = [\t-\n\r\ ]*;
rascal	code	lexical IntegerLiteral = [0-9]+;           
rascal	blank	
rascal	code	start syntax Exp 
rascal	code	  = IntegerLiteral          
rascal	code	  | bracket "(" Exp ")"     
rascal	code	  > left Exp "*" Exp        
rascal	code	  > left Exp "+" Exp        
rascal	code	  ;
rascal	blank	
rascal	comment	/*
rascal	comment		Code follows grammar
rascal	comment	*/
rascal	code	public int eval(str txt) = eval(parse(#start[Exp], txt).top);              
rascal	blank	
rascal	code	public int eval((Exp)`<IntegerLiteral l>`) = toInt("<l>");       
rascal	code	public int eval((Exp)`<Exp e1> * <Exp e2>`) = eval(e1) * eval(e2);  
rascal	code	public int eval((Exp)`<Exp e1> + <Exp e2>`) = eval(e1) + eval(e2); 
rascal	code	public int eval((Exp)`( <Exp e> )`) = eval(e);                    
rascal	blank	
rascal	comment	// run me!
rascal	code	public value main(list[value] args) {
rascal	code	  return eval(" 2+3");
rascal	code	}
rascal	blank	
rascal	code	@memo
rascal	code	test bool tstEval1() = eval(" 7") == 7;
rascal	code	test bool tstEval2() = eval("7 * 3") == 21;
rascal	code	test bool tstEval3() = eval("7 + 3") == 10;
rascal	code	test bool tstEval3() = eval(" 3 + 4*5 ") == 23;
rascal	comment	// comments here to
