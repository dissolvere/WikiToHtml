%{
#include <cstdio>
#include <iostream>
using namespace std;

extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;
 
void yyerror(const char *s);
void log(const char *s);
%}

%locations

%union {
	char *sval;
}

%token OPENAGHLEMMASTART
%token OPENAGHDEFINITIONSTART
%token OPENAGHEXAMPLESTART
%token OPENAGHLAWSTART
%token OPENAGHRULESTART
%token OPENAGHCONCLUSIONSTART
%token OPENAGHDERIVATIONSTART
%token OPENAGHSUMMARYSTART
%token OPENAGHINFORMATIONSTART
%token OPENAGHANNOTATIONSTART
%token OPENAGHPROPERTYSTART
%token OPENAGHLEMMAEND
%token OPENAGHDEFINITIONEND
%token OPENAGHEXAMPLEEND
%token OPENAGHLAWEND
%token OPENAGHRULEEND
%token OPENAGHCONCLUSIONEND
%token OPENAGHDERIVATIONEND
%token OPENAGHSUMMARYEND
%token OPENAGHINFORMATIONEND
%token OPENAGHANNOTATIONEND
%token OPENAGHPROPERTYEND

%token OPENAGHMATHJAXSTART
%token OPENAGHMATHJAXEND

%token OPENAGHQUOTATION
%token OPENAGHQUOTATIONS
%token OPENAGHNOTES
%token OPENAGHSIMULATION

%token OPENAGHNOTESTART
%token OPENAGHTHEOREMSTART
%token OPENAGHEXERCISESTART
%token XNAME
%token XANCHOR
%token XASSUMPTIONS
%token XTHESIS
%token XPROOF
%token XCONTENT
%token XSOLUTION
%token XNOTE

%token IMG
%token VIMEO
%token YOUTUBE
%token MEDIAPLAYER
%token SUB

%token ERRMATH
%token ERRWRSURR
%token ERRDOUBLEBR
%token ERRINVSURR
%token ERRDOUBLEDOLLAR

%token QU
%token BR
%token BL
%token NR
%token NL

%token <sval> TEXT

%%

module:
	modulesimple
	| module modulesimple
	| tiki
	| module tiki
	| openagh
	| module openagh
	| errmath
	| module errmath
	;

modulesimple:
	text
	| openaghmathjax
	| modulesimple text
	| modulesimple openaghmathjax
	;

tiki:
	img
	| vimeo
	| youtube
	| mediaplayer
	| sub
	;

openagh:
	openaghlemma
	| openaghdefinition
	| openaghexample
	| openaghlaw
	| openaghrule
	| openaghconclusion
	| openaghderivation
	| openaghsummary
	| openaghinformation
	| openaghannotation
	| openaghproperty
	| openaghquotation
	| openaghquotations
	| openaghnote
	| openaghnotes
	| openaghtheorem
	| openaghexercise
	| openaghsimulation
	;

text:
	TEXT
	{ log(" -> found plain text: "); }
	| QU text QU
	;

math:
	text
	| NL
	| NR
	| BL math BR
	| math math
	|
	;

img:
	IMG
	{ log(" -> found img"); }
	;

vimeo:
	VIMEO
	{ log(" -> found vimeo"); }
	;

youtube:
	YOUTUBE
	{ log(" -> found youtube"); }
	;

mediaplayer:
	MEDIAPLAYER
	{ log(" -> found mediaplayer"); }
	;

sub:
	SUB
	{ log(" -> found sub"); }
	;

openaghlemma:
	openaghlemma2
	{ log(" -> found openaghlemma"); }
	;

openaghlemma2:
	OPENAGHLEMMASTART xname xanchor NR BR module OPENAGHLEMMAEND
	| OPENAGHLEMMASTART xanchor xname NR BR module OPENAGHLEMMAEND
	;

openaghdefinition:
	openaghdefinition2
	{ log(" -> found openaghdefinition"); }
	;

openaghdefinition2:
	OPENAGHDEFINITIONSTART xname xanchor NR BR module OPENAGHDEFINITIONEND
	| OPENAGHDEFINITIONSTART xanchor xname NR BR module OPENAGHDEFINITIONEND
	;

openaghexample:
	openaghexample2
	{ log(" -> found openaghexample"); }
	;

openaghexample2:
	OPENAGHEXAMPLESTART xname xanchor NR BR module OPENAGHEXAMPLEEND
	| OPENAGHEXAMPLESTART xanchor xname NR BR module OPENAGHEXAMPLEEND
	;

openaghlaw:
	openaghlaw2
	{ log(" -> found openaghlaw"); }
	;

openaghlaw2:
	OPENAGHLAWSTART xname xanchor NR BR module OPENAGHLAWEND
	| OPENAGHLAWSTART xanchor xname NR BR module OPENAGHLAWEND
	;

openaghrule:
	openaghrule2
	{ log(" -> found openaghrule"); }
	;

openaghrule2:
	OPENAGHRULESTART xname xanchor NR BR module OPENAGHRULEEND
	| OPENAGHRULESTART xanchor xname NR BR module OPENAGHRULEEND
	;

openaghconclusion:
	openaghconclusion2
	{ log(" -> found openaghconclusion"); }
	;

openaghconclusion2:
	OPENAGHCONCLUSIONSTART xname xanchor NR BR module OPENAGHCONCLUSIONEND
	| OPENAGHCONCLUSIONSTART xanchor xname NR BR module OPENAGHCONCLUSIONEND
	;

openaghderivation:
	openaghderivation2
	{ log(" -> found openaghderivation"); }
	;

openaghderivation2:
	OPENAGHDERIVATIONSTART xname xanchor NR BR module OPENAGHDERIVATIONEND
	| OPENAGHDERIVATIONSTART xanchor xname NR BR module OPENAGHDERIVATIONEND
	;

openaghsummary:
	openaghsummary2
	{ log(" -> found openaghsummary"); }
	;

openaghsummary2:
	OPENAGHSUMMARYSTART xname xanchor NR BR module OPENAGHSUMMARYEND
	| OPENAGHSUMMARYSTART xanchor xname NR BR module OPENAGHSUMMARYEND
	;

openaghinformation:
	openaghinformation2
	{ log(" -> found openaghinformation"); }
	;

openaghinformation2:
	OPENAGHINFORMATIONSTART xname xanchor NR BR module OPENAGHINFORMATIONEND
	| OPENAGHINFORMATIONSTART xanchor xname NR BR module OPENAGHINFORMATIONEND
	;

openaghannotation:
	openaghannotation2
	{ log(" -> found openaghannotation"); }
	;

openaghannotation2:
	OPENAGHANNOTATIONSTART xname xanchor NR BR module OPENAGHANNOTATIONEND
	| OPENAGHANNOTATIONSTART xanchor xname NR BR module OPENAGHANNOTATIONEND
	;

openaghproperty:
	openaghproperty2
	{ log(" -> found openaghproperty"); }
	;

openaghproperty2:
	OPENAGHPROPERTYSTART xname xanchor NR BR module OPENAGHPROPERTYEND
	| OPENAGHPROPERTYSTART xanchor xname NR BR module OPENAGHPROPERTYEND
	;

openaghmathjax:
	OPENAGHMATHJAXSTART math OPENAGHMATHJAXEND
	{ log(" -> found openaghmathjax"); }
	;

openaghquotation:
	OPENAGHQUOTATION
	{ log(" -> found openaghquotation"); }
	;

openaghquotations:
	OPENAGHQUOTATIONS
	{ log(" -> found openaghquotations"); }
	;

openaghnote:
	openaghnote2
	{ log(" -> found openaghnote"); }
	;

openaghnote2:
	OPENAGHNOTESTART xnote BR
	;

openaghnotes:
	OPENAGHNOTES
	{ log(" -> found openaghnotes"); }
	;

openaghsimulation:
	OPENAGHSIMULATION
	{ log(" -> found openaghsimulation"); }
	;

openaghtheorem:
	openaghtheorem2
	{ log(" -> found openaghtheorem"); }
	;

openaghtheorem2:
	OPENAGHTHEOREMSTART xname xanchor xassumptions xthesis xproof BR
	| OPENAGHTHEOREMSTART xname xanchor xassumptions xproof xthesis BR
	| OPENAGHTHEOREMSTART xname xanchor xthesis xassumptions xproof BR
	| OPENAGHTHEOREMSTART xname xanchor xthesis xproof xassumptions BR
	| OPENAGHTHEOREMSTART xname xanchor xproof xassumptions xthesis BR
	| OPENAGHTHEOREMSTART xname xanchor xproof xthesis xassumptions BR
	| OPENAGHTHEOREMSTART xname xassumptions xanchor xproof xthesis BR
	| OPENAGHTHEOREMSTART xname xassumptions xanchor xthesis xproof BR
	| OPENAGHTHEOREMSTART xname xassumptions xthesis xproof xanchor BR
	| OPENAGHTHEOREMSTART xname xassumptions xthesis xanchor xproof BR
	| OPENAGHTHEOREMSTART xname xassumptions xproof xthesis xanchor BR
	| OPENAGHTHEOREMSTART xname xassumptions xproof xanchor xthesis BR
	| OPENAGHTHEOREMSTART xname xthesis xanchor xassumptions xproof BR
	| OPENAGHTHEOREMSTART xname xthesis xanchor xproof xassumptions BR
	| OPENAGHTHEOREMSTART xname xthesis xassumptions xanchor xproof BR
	| OPENAGHTHEOREMSTART xname xthesis xassumptions xproof xanchor BR
	| OPENAGHTHEOREMSTART xname xthesis xproof xanchor xassumptions BR
	| OPENAGHTHEOREMSTART xname xthesis xproof xassumptions xanchor BR
	| OPENAGHTHEOREMSTART xname xproof xanchor xthesis xassumptions BR
	| OPENAGHTHEOREMSTART xname xproof xanchor xassumptions xthesis BR
	| OPENAGHTHEOREMSTART xname xproof xassumptions xthesis xanchor BR
	| OPENAGHTHEOREMSTART xname xproof xassumptions xanchor xthesis BR
	| OPENAGHTHEOREMSTART xname xproof xthesis xassumptions xanchor BR
	| OPENAGHTHEOREMSTART xname xproof xthesis xanchor xassumptions BR
	| OPENAGHTHEOREMSTART xanchor xname xproof xassumptions xthesis BR
	| OPENAGHTHEOREMSTART xanchor xname xproof xthesis xassumptions BR
	| OPENAGHTHEOREMSTART xanchor xname xassumptions xproof xthesis BR
	| OPENAGHTHEOREMSTART xanchor xname xassumptions xthesis xproof BR
	| OPENAGHTHEOREMSTART xanchor xname xthesis xproof xassumptions BR
	| OPENAGHTHEOREMSTART xanchor xname xthesis xassumptions xproof BR
	| OPENAGHTHEOREMSTART xanchor xassumptions xproof xthesis xname BR
	| OPENAGHTHEOREMSTART xanchor xassumptions xproof xname xthesis BR
	| OPENAGHTHEOREMSTART xanchor xassumptions xname xthesis xproof BR
	| OPENAGHTHEOREMSTART xanchor xassumptions xname xproof xthesis BR
	| OPENAGHTHEOREMSTART xanchor xassumptions xthesis xname xproof BR
	| OPENAGHTHEOREMSTART xanchor xassumptions xthesis xproof xname BR
	| OPENAGHTHEOREMSTART xanchor xthesis xproof xname xassumptions BR
	| OPENAGHTHEOREMSTART xanchor xthesis xproof xassumptions xname BR
	| OPENAGHTHEOREMSTART xanchor xthesis xname xproof xassumptions BR
	| OPENAGHTHEOREMSTART xanchor xthesis xname xassumptions xproof BR
	| OPENAGHTHEOREMSTART xanchor xthesis xassumptions xproof xname BR
	| OPENAGHTHEOREMSTART xanchor xthesis xassumptions xname xproof BR
	| OPENAGHTHEOREMSTART xanchor xproof xthesis xassumptions xname BR
	| OPENAGHTHEOREMSTART xanchor xproof xthesis xname xassumptions BR
	| OPENAGHTHEOREMSTART xanchor xproof xname xassumptions xthesis BR
	| OPENAGHTHEOREMSTART xanchor xproof xname xthesis xassumptions BR
	| OPENAGHTHEOREMSTART xanchor xproof xassumptions xname xthesis BR
	| OPENAGHTHEOREMSTART xanchor xproof xassumptions xthesis xname BR
	| OPENAGHTHEOREMSTART xassumptions xname xthesis xproof xanchor BR
	| OPENAGHTHEOREMSTART xassumptions xname xthesis xanchor xproof BR
	| OPENAGHTHEOREMSTART xassumptions xname xproof xthesis xanchor BR
	| OPENAGHTHEOREMSTART xassumptions xname xproof xanchor xthesis BR
	| OPENAGHTHEOREMSTART xassumptions xname xanchor xthesis xproof BR
	| OPENAGHTHEOREMSTART xassumptions xname xanchor xproof xthesis BR
	| OPENAGHTHEOREMSTART xassumptions xanchor xthesis xname xproof BR
	| OPENAGHTHEOREMSTART xassumptions xanchor xthesis xproof xname BR
	| OPENAGHTHEOREMSTART xassumptions xanchor xproof xname xthesis BR
	| OPENAGHTHEOREMSTART xassumptions xanchor xproof xthesis xname BR
	| OPENAGHTHEOREMSTART xassumptions xanchor xname xproof xthesis BR
	| OPENAGHTHEOREMSTART xassumptions xanchor xname xthesis xproof BR
	| OPENAGHTHEOREMSTART xassumptions xthesis xanchor xproof xname BR
	| OPENAGHTHEOREMSTART xassumptions xthesis xanchor xname xproof BR
	| OPENAGHTHEOREMSTART xassumptions xthesis xproof xanchor xname BR
	| OPENAGHTHEOREMSTART xassumptions xthesis xproof xname xanchor BR
	| OPENAGHTHEOREMSTART xassumptions xthesis xname xanchor xproof BR
	| OPENAGHTHEOREMSTART xassumptions xthesis xname xproof xanchor BR
	| OPENAGHTHEOREMSTART xassumptions xproof xanchor xname xthesis BR
	| OPENAGHTHEOREMSTART xassumptions xproof xanchor xthesis xname BR
	| OPENAGHTHEOREMSTART xassumptions xproof xthesis xname xanchor BR
	| OPENAGHTHEOREMSTART xassumptions xproof xthesis xanchor xname BR
	| OPENAGHTHEOREMSTART xassumptions xproof xname xthesis xanchor BR
	| OPENAGHTHEOREMSTART xassumptions xproof xname xanchor xthesis BR
	| OPENAGHTHEOREMSTART xthesis xname xanchor xassumptions xproof BR
	| OPENAGHTHEOREMSTART xthesis xname xanchor xproof xassumptions BR
	| OPENAGHTHEOREMSTART xthesis xname xassumptions xanchor xproof BR
	| OPENAGHTHEOREMSTART xthesis xname xassumptions xproof xanchor BR
	| OPENAGHTHEOREMSTART xthesis xname xproof xanchor xassumptions BR
	| OPENAGHTHEOREMSTART xthesis xname xproof xassumptions xanchor BR
	| OPENAGHTHEOREMSTART xthesis xanchor xname xproof xassumptions BR
	| OPENAGHTHEOREMSTART xthesis xanchor xname xassumptions xproof BR
	| OPENAGHTHEOREMSTART xthesis xanchor xassumptions xproof xname BR
	| OPENAGHTHEOREMSTART xthesis xanchor xassumptions xname xproof BR
	| OPENAGHTHEOREMSTART xthesis xanchor xproof xassumptions xname BR
	| OPENAGHTHEOREMSTART xthesis xanchor xproof xname xassumptions BR
	| OPENAGHTHEOREMSTART xthesis xassumptions xname xanchor xproof BR
	| OPENAGHTHEOREMSTART xthesis xassumptions xname xproof xanchor BR
	| OPENAGHTHEOREMSTART xthesis xassumptions xanchor xname xproof BR
	| OPENAGHTHEOREMSTART xthesis xassumptions xanchor xproof xname BR
	| OPENAGHTHEOREMSTART xthesis xassumptions xproof xname xanchor BR
	| OPENAGHTHEOREMSTART xthesis xassumptions xproof xanchor xname BR
	| OPENAGHTHEOREMSTART xthesis xproof xname xassumptions xanchor BR
	| OPENAGHTHEOREMSTART xthesis xproof xname xanchor xassumptions BR
	| OPENAGHTHEOREMSTART xthesis xproof xanchor xassumptions xname BR
	| OPENAGHTHEOREMSTART xthesis xproof xanchor xname xassumptions BR
	| OPENAGHTHEOREMSTART xthesis xproof xassumptions xanchor xname BR
	| OPENAGHTHEOREMSTART xthesis xproof xassumptions xname xanchor BR
	| OPENAGHTHEOREMSTART xproof xname xthesis xanchor xassumptions BR
	| OPENAGHTHEOREMSTART xproof xname xthesis xassumptions xanchor BR
	| OPENAGHTHEOREMSTART xproof xname xanchor xthesis xassumptions BR
	| OPENAGHTHEOREMSTART xproof xname xanchor xassumptions xthesis BR
	| OPENAGHTHEOREMSTART xproof xname xassumptions xthesis xanchor BR
	| OPENAGHTHEOREMSTART xproof xname xassumptions xanchor xthesis BR
	| OPENAGHTHEOREMSTART xproof xanchor xthesis xassumptions xname BR
	| OPENAGHTHEOREMSTART xproof xanchor xthesis xname xassumptions BR
	| OPENAGHTHEOREMSTART xproof xanchor xname xassumptions xthesis BR
	| OPENAGHTHEOREMSTART xproof xanchor xname xthesis xassumptions BR
	| OPENAGHTHEOREMSTART xproof xanchor xassumptions xname xthesis BR
	| OPENAGHTHEOREMSTART xproof xanchor xassumptions xthesis xname BR
	| OPENAGHTHEOREMSTART xproof xassumptions xthesis xname xanchor BR
	| OPENAGHTHEOREMSTART xproof xassumptions xthesis xanchor xname BR
	| OPENAGHTHEOREMSTART xproof xassumptions xname xthesis xanchor BR
	| OPENAGHTHEOREMSTART xproof xassumptions xname xanchor xthesis BR
	| OPENAGHTHEOREMSTART xproof xassumptions xanchor xthesis xname BR
	| OPENAGHTHEOREMSTART xproof xassumptions xanchor xname xthesis BR
	| OPENAGHTHEOREMSTART xproof xthesis xassumptions xanchor xname BR
	| OPENAGHTHEOREMSTART xproof xthesis xassumptions xname xanchor BR
	| OPENAGHTHEOREMSTART xproof xthesis xname xanchor xassumptions BR
	| OPENAGHTHEOREMSTART xproof xthesis xname xassumptions xanchor BR
	| OPENAGHTHEOREMSTART xproof xthesis xanchor xname xassumptions BR
	| OPENAGHTHEOREMSTART xproof xthesis xanchor xassumptions xname BR
	;

openaghexercise:
	openaghexercise2
	{ log(" -> found openaghexercise"); }
	;

openaghexercise2:
	| OPENAGHEXERCISESTART xname xanchor xcontent xsolution BR
	| OPENAGHEXERCISESTART xname xanchor xsolution xcontent BR
	| OPENAGHEXERCISESTART xname xcontent xanchor xsolution BR
	| OPENAGHEXERCISESTART xname xcontent xsolution xanchor BR
	| OPENAGHEXERCISESTART xname xsolution xanchor xcontent BR
	| OPENAGHEXERCISESTART xname xsolution xcontent xanchor BR
	| OPENAGHEXERCISESTART xanchor xname xsolution xcontent BR
	| OPENAGHEXERCISESTART xanchor xname xcontent xsolution BR
	| OPENAGHEXERCISESTART xanchor xcontent xsolution xname BR
	| OPENAGHEXERCISESTART xanchor xcontent xname xsolution BR
	| OPENAGHEXERCISESTART xanchor xsolution xcontent xname BR
	| OPENAGHEXERCISESTART xanchor xsolution xname xcontent BR
	| OPENAGHEXERCISESTART xcontent xname xanchor xsolution BR
	| OPENAGHEXERCISESTART xcontent xname xsolution xanchor BR
	| OPENAGHEXERCISESTART xcontent xanchor xname xsolution BR
	| OPENAGHEXERCISESTART xcontent xanchor xsolution xname BR
	| OPENAGHEXERCISESTART xcontent xsolution xname xanchor BR
	| OPENAGHEXERCISESTART xcontent xsolution xanchor xname BR
	| OPENAGHEXERCISESTART xsolution xname xcontent xanchor BR
	| OPENAGHEXERCISESTART xsolution xname xanchor xcontent BR
	| OPENAGHEXERCISESTART xsolution xanchor xcontent xname BR
	| OPENAGHEXERCISESTART xsolution xanchor xname xcontent BR
	| OPENAGHEXERCISESTART xsolution xcontent xanchor xname BR
	| OPENAGHEXERCISESTART xsolution xcontent xname xanchor BR
	;

xname:
	XNAME modulesimple QU
	| XNAME QU
	|
	;

xanchor:
	XANCHOR modulesimple QU
	| XANCHOR QU
	|
	;

xassumptions:
	XASSUMPTIONS modulesimple QU
	| XASSUMPTIONS QU
	|
	;

xthesis:
	XTHESIS modulesimple QU
	| XTHESIS QU
	|
	;

xproof:
	XPROOF modulesimple QU
	| XPROOF QU
	|
	;

xcontent:
	XCONTENT modulesimple QU
	| XCONTENT QU
	|
	;

xsolution:
	XSOLUTION modulesimple QU
	| XSOLUTION QU
	|
	;

xnote:
	XNOTE modulesimple QU
	| XNOTE QU
	|
	;

errmath:
	ERRMATH
	{ yyerror("mathjax opener found error"); }
	| ERRWRSURR
	{ yyerror("wrong surrounding error"); }
	| ERRDOUBLEBR
	{ yyerror("double braces error"); }
	| ERRINVSURR
	{ yyerror("invalid surrounding error"); }
	| ERRDOUBLEDOLLAR
	{ yyerror("double dollar sign error"); }
	;

%%

int main(int argc, char** argv) {

	//load file (if cannot return 2)

	FILE *myfile = fopen(argv[1], "r");
	if (!myfile) {
		log("Can not open file. Usage: ./openagh filename");
		return 2;
	}
	yyin = myfile;

	//parse (if error return 1)

	do {
		yyparse();
	} while (!feof(yyin));

	//return 0 if OK

	exit(0);
}

void yyerror(const char *s) {
	extern int yylineno;
	extern char *yytext;
  
	cerr << "ERROR: " << s << " at symbol \"" << yytext;
	cerr << "\" on line " << yylineno << endl;
	exit(1);
}

void log(const char *s){
	//extern char *yytext;
	//cout << s << yytext << endl;
}
