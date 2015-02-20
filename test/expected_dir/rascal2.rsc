rascal	code	module demo::common::StringTemplate
rascal	blank	
rascal	code	import String;
rascal	code	import IO;
rascal	code	import Set;
rascal	code	import List;
rascal	blank	
rascal	code	public str capitalize(str s) {  
rascal	code	  return toUpperCase(substring(s, 0, 1)) + substring(s, 1);
rascal	code	}
rascal	blank	
rascal	code	private str genSetter(map[str,str] fields, str x) {
rascal	code	  return "public void set<capitalize(x)>(<fields[x]> <x>) {
rascal	code	         '  this.<x> = <x>;
rascal	code	         '}";
rascal	code	}
rascal	blank	
rascal	code	private str genGetter(map[str,str] fields, str x) {
rascal	code	  return "public <fields[x]> get<capitalize(x)>() {
rascal	code	         '  return <x>;
rascal	code	         '}";
rascal	code	}
rascal	blank	
rascal	code	public str genClass(str name, map[str,str] fields) { 
rascal	code	  return 
rascal	code	    "public class <name> {
rascal	blank	
rascal	code	    '  <for (x <- sort([f | f <- fields])) {>
rascal	code	    '  private <fields[x]> <x>;
rascal	code	    '  <genSetter(fields, x)>
rascal	code	    '  <genGetter(fields, x)><}>
rascal	code	    '}";
rascal	code	}
