package Example;

/** section 1- usercode / imports */

import java_cup.runtime.SymbolFactory;
%%

/** section 2- define the regular expressions and macros*/

%cup
%class Scanner
%{
	public Scanner(java.io.InputStream r, SymbolFactory sf){
		this(r);
		this.sf=sf;
	}
	private SymbolFactory sf;
%}
%eofval{
    return sf.newSymbol("EOF",sym.EOF);
%eofval}


whitespace = [ \t\r\n\f]  
digit = [0-9]
non_zero_digit = [1-9]
integer = -?(0|{non_zero_digit}{digit}*)
dot = ["."]
exp = (e|E)("+"|"-"|"")
frac = {dot}{digit}+
scientific_notation = {exp}{digit}+
number = {integer}{frac}?{scientific_notation}?
boolean = (true|false)
string = \"{char}*\"    
/** A string always starts with " and ends with " */
char = [^\n\r\"]
/** any character except for some control charachters ) */


%%
/** section 3:  this is where the lexer rules are defined-keywords, literals, or opertors are defined  */

"," { return sf.newSymbol("Comma",sym.COMMA); }
":" { return sf.newSymbol("Colon", sym.COLON);}

/** array start and end symbols  */

"[" { return sf.newSymbol("Left Square Bracket",sym.LSQBRACKET); }
"]" { return sf.newSymbol("Right Square Bracket",sym.RSQBRACKET); }

/** object start and end symbols  */

"{" { return sf.newSymbol("Left Brace", sym.LBRACE);}
"}" { return sf.newSymbol("Right Brace", sym.RBRACE);}


/** catches null pointers */
"null" { return sf.newSymbol("Null",sym.NULL); } 

/** Scan for boolean strings */ 
"true"|"false" { return sf.newSymbol("Boolean", sym.BOOLEAN, new Boolean(yytext()));}

/* string and number literals */
{number} { return sf.newSymbol("Number",sym.NUMBER); }
{string} { return sf.newSymbol("String",sym.STRING); }

{whitespace} { /* ignore spaces. */ }
. { System.err.println("Illegal character: "+yytext()); } /** catches anything that hasn't been */



