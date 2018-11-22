%skeleton "lalr1.cc"
%defines
%define api.value.type variant
%define api.token.constructor
%code requires{
	#include<map>
}
%code{ 
	#include <string>
	#include <stdio.h>
	#define YY_DECL yy::parser::symbol_type yylex()
	unsigned int mathjax_total = 0;
	YY_DECL;
	void process_module(std::string module);
	std::string div_openaghmathjax(std::map<std::string, std::string> attrs, std::string body);
	std::string div();
	std::string div(std::string cl);
	std::string div(std::string openaghname, std::map<std::string, std::string> attrs, std::string body);
	std::string div(std::string openaghname, std::map<std::string, std::string> attrs);
}

%token <std::string> OPENAGHLEMMASTART
%token <std::string> OPENAGHDEFINITIONSTART
%token <std::string> OPENAGHEXAMPLESTART
%token <std::string> OPENAGHLAWSTART
%token <std::string> OPENAGHRULESTART
%token <std::string> OPENAGHCONCLUSIONSTART
%token <std::string> OPENAGHDERIVATIONSTART
%token <std::string> OPENAGHSUMMARYSTART
%token <std::string> OPENAGHINFORMATIONSTART
%token <std::string> OPENAGHANNOTATIONSTART
%token <std::string> OPENAGHPROPERTYSTART
%token <std::string> OPENAGHMATHJAXSTART

%token <std::string> OPENAGHLEMMAEND
%token <std::string> OPENAGHDEFINITIONEND
%token <std::string> OPENAGHEXAMPLEEND
%token <std::string> OPENAGHLAWEND
%token <std::string> OPENAGHRULEEND
%token <std::string> OPENAGHCONCLUSIONEND
%token <std::string> OPENAGHDERIVATIONEND
%token <std::string> OPENAGHSUMMARYEND
%token <std::string> OPENAGHINFORMATIONEND
%token <std::string> OPENAGHANNOTATIONEND
%token <std::string> OPENAGHPROPERTYEND
%token <std::string> OPENAGHMATHJAXEND

%token <std::string> OPENAGHNOTESTART
%token <std::string> OPENAGHTHEOREMSTART
%token <std::string> OPENAGHEXERCISESTART
%token <std::string> OPENAGHQUOTATIONSSTART
%token <std::string> OPENAGHNOTESSTART
%token <std::string> OPENAGHSIMULATIONSTART
%token <std::string> OPENAGHIMGFORMULASTART
%token <std::string> OPENAGHCHEMEVISUALIZATIONSTART

%token <std::string> XNAME
%token <std::string> XANCHOR
%token <std::string> XASSUMPTIONS
%token <std::string> XTHESIS
%token <std::string> XPROOF
%token <std::string> XCONTENT
%token <std::string> XSOLUTION
%token <std::string> XNOTE
%token <std::string> XTYPE
%token <std::string> XISNUMERATION
%token <std::string> XHEADLINE
%token <std::string> XFILEID
%token <std::string> XCAPTION
%token <std::string> XFORMULATYPE

%token <std::string> IMG
%token <std::string> VIMEO
%token <std::string> YOUTUBE
%token <std::string> MEDIAPLAYER
%token <std::string> SUB
%token <std::string> OPENAGHQUOTATION

%token <std::string> TABLEHEADSTART
%token <std::string> TABLEHEADEND

%token <std::string> ERRMATH
%token <std::string> ERRWRSURR
%token <std::string> ERRDOUBLEBR
%token <std::string> ERRINVSURR
%token <std::string> ERRDOUBLEDOLLAR

%token <std::string> QU
%token <std::string> BR
%token <std::string> BL
%token <std::string> NR
%token <std::string> NL

%token <std::string> TEXT

%token END 0 "end of file"

%type <std::string> root module modulesimple openagh text math tiki

%type <std::string> img vimeo youtube mediaplayer sub table

%type <std::string> openaghmathjax
%type <std::map<std::string, std::string>> xopenaghmathjaxattrs

%type <std::string> openaghtheorem
%type <std::map<std::string, std::string>> xopenaghtheoremattrs

%type <std::string> openaghexercise
%type <std::map<std::string, std::string>> xopenaghexerciseattrs

%type <std::string> openaghimgformula
%type <std::map<std::string, std::string>> xopenaghimgformulaattrs

%type <std::string> openaghquotations openaghnote openaghnotes openaghsimulation openaghchemevisualization

%type <std::string> openaghdefinition openaghlemma openaghexample openaghlaw openaghrule openaghconclusion openaghderivation openaghsummary openaghinformation openaghannotation openaghproperty
%type <std::map<std::string, std::string>> x_name_anchor

%type <std::pair<std::string, std::string>> xname xanchor xisnumeration xtype xassumptions xthesis xproof xcontent xsolution xnote xheadline xfileid xformulatype

%%

root:
	module { $$ = $1; process_module($$); }
	;

module:
	NL                     { $$ = $1; }
        | module NL            { $$ = $1 + $2; }
        | NR                   { $$ = $1; }
        | module NR            { $$ = $1 + $2; }
	| module text          { $$ = $1 + $2; }
	| modulesimple         { $$ = $1; }
	| module modulesimple  { $$ = $1 + $2; }
	| tiki
	| module tiki
	| openagh              { $$ = $1; }
	| module openagh       { $$ = $1 + $2; }
	| errmath
	| module errmath
	;

modulesimple:
	text                           { $$ = $1; }
	| modulesimple text            { $$ = $1 + $2; }
	| openaghmathjax               { $$ = $1; }
	| modulesimple openaghmathjax  { $$ = $1 + $2; }
	| QU modulesimple QU           { $$ = $1 + $2 + $3; }
	;

tiki:
	img            
	| vimeo        
	| youtube      
	| mediaplayer  
	| sub       
	;

openagh:
	openaghlemma          { $$ = $1; }
	| openaghdefinition   { $$ = $1; }
	| openaghexample      { $$ = $1; }
	| openaghlaw          { $$ = $1; }
	| openaghrule         { $$ = $1; }
	| openaghconclusion   { $$ = $1; }
	| openaghderivation   { $$ = $1; }
	| openaghsummary      { $$ = $1; }
	| openaghinformation  { $$ = $1; }
	| openaghannotation   { $$ = $1; }
	| openaghproperty     { $$ = $1; }
	| openaghquotation    
	| openaghquotations   { $$ = $1; }
	| openaghnote         { $$ = $1; }
	| openaghnotes        { $$ = $1; }
	| openaghtheorem      { $$ = $1; }
	| openaghexercise     { $$ = $1; }
	| openaghsimulation   { $$ = $1; }
	| openaghimgformula   { $$ = $1; }
	| openaghchemevisualization   { $$ = $1; }
	;

text:
	TEXT          { $$ = $1; }
	;

math:
	text          { $$ = $1; }
	| NL          { $$ = $1; }
	| NR          { $$ = $1; }
	| BL math BR  { $$ = $1 + $2 + $3; }
	| math math   { $$ = $1 + $2; }
	|             { $$ = ""; }
	;

/*
 *   TODO: img,vimeo,youtube,mediaplayer,sub,table
 */

img:
	IMG  { $$ = ""; }
	;

vimeo:
	VIMEO  { $$ = ""; }
	;

youtube:
	YOUTUBE  { $$ = ""; }
	;

mediaplayer:
	MEDIAPLAYER  { $$ = ""; }
	;

sub:
	SUB  { $$ = ""; }
	;

table:
	TABLEHEADSTART text TABLEHEADEND  { $$ = ""; }

openaghmathjax:
	OPENAGHMATHJAXSTART xopenaghmathjaxattrs NR BR math OPENAGHMATHJAXEND { $$ = div_openaghmathjax($2, $5); };

openaghlemma:
	OPENAGHLEMMASTART x_name_anchor NR BR module OPENAGHLEMMAEND  { $$ = div("openaghlemma", $2, $5); };

openaghdefinition:
	OPENAGHDEFINITIONSTART x_name_anchor NR BR module OPENAGHDEFINITIONEND  { $$ = div("openaghdefinition", $2, $5); };

openaghexample:
	OPENAGHEXAMPLESTART x_name_anchor NR BR module OPENAGHEXAMPLEEND  { $$ = div("openaghexample", $2, $5); };

openaghlaw:
	OPENAGHLAWSTART x_name_anchor NR BR module OPENAGHLAWEND  { $$ = div("openaghlaw", $2, $5); };

openaghrule:
	OPENAGHRULESTART x_name_anchor NR BR module OPENAGHRULEEND  { $$ = div("openaghrule", $2, $5); };

openaghconclusion:
	OPENAGHCONCLUSIONSTART x_name_anchor NR BR module OPENAGHCONCLUSIONEND  { $$ = div("openaghconclusion", $2, $5); };

openaghderivation:
	OPENAGHDERIVATIONSTART x_name_anchor NR BR module OPENAGHDERIVATIONEND  { $$ = div("openaghderivation", $2, $5); };

openaghsummary:
	OPENAGHSUMMARYSTART x_name_anchor NR BR module OPENAGHSUMMARYEND  { $$ = div("openaghsummary", $2, $5); };

openaghinformation:
	OPENAGHINFORMATIONSTART x_name_anchor NR BR module OPENAGHINFORMATIONEND  { $$ = div("openaghinformation", $2, $5); };

openaghannotation:
	OPENAGHANNOTATIONSTART x_name_anchor NR BR module OPENAGHANNOTATIONEND  { $$ = div("openaghannotation", $2, $5); };

openaghproperty:
	OPENAGHPROPERTYSTART x_name_anchor NR BR module OPENAGHPROPERTYEND  { $$ = div("openaghproperty", $2, $5); };

/*
 *   TODO: openaghquotation
 */

openaghquotation:
	OPENAGHQUOTATION
	;

openaghquotations:
	OPENAGHQUOTATIONSSTART xheadline BR  { $$ = div("openaghquotations", { $2 }); };
	;

openaghnote:
	OPENAGHNOTESTART xnote BR  { $$ = div("openaghnote", { $2 }); };
	;

openaghnotes:
	OPENAGHNOTESSTART xheadline BR  { $$ = div("openaghnotes", { $2 }); };
	;

openaghsimulation:
	OPENAGHSIMULATIONSTART xfileid BR  { $$ = div("openaghsimulation", { $2 }); };
	;

openaghtheorem:
	OPENAGHTHEOREMSTART xopenaghtheoremattrs BR  { $$ = div("openaghtheorem", { $2 }); };
	;

openaghexercise:
	OPENAGHEXERCISESTART xopenaghexerciseattrs BR  { $$ = div("openaghexercise", { $2 }); };
	;

openaghimgformula:
	OPENAGHIMGFORMULASTART xopenaghimgformulaattrs BR  { $$ = div("openaghimgformula", { $2 }); };
	;

openaghchemevisualization:
	OPENAGHCHEMEVISUALIZATIONSTART xfileid BR  { $$ = div("openaghchemevisualization", { $2 }); };
	;

/*
 *   openaghmathjax attrs
 *    - isNumeration (yes or no)
 *    - type (inline, block or default)
 *    - anchor (text)
 */

xopenaghmathjaxattrs:
	xisnumeration xtype xanchor    { $$ = {$1, $2, $3}; }
	| xisnumeration xanchor xtype  { $$ = {$1, $2, $3}; }
	| xtype xanchor xisnumeration  { $$ = {$1, $2, $3}; }
	| xanchor xtype xisnumeration  { $$ = {$1, $2, $3}; }
	| xtype xisnumeration xanchor  { $$ = {$1, $2, $3}; }
	| xanchor xisnumeration xtype  { $$ = {$1, $2, $3}; }
	;

/*
 *   openaghtheorem attrs
 *    - name (text or math)
 *    - anchor (text)
 *    - assumptions (text or math)
 *    - thesis (text or math)
 *    - proof (text or math)
 */

xopenaghtheoremattrs:
	xname xanchor xassumptions xthesis xproof  { $$ = {$1, $2, $3, $4, $5}; }
	| xname xanchor xassumptions xproof xthesis  { $$ = {$1, $2, $3, $4, $5}; }
	| xname xanchor xthesis xassumptions xproof  { $$ = {$1, $2, $3, $4, $5}; }
	| xname xanchor xthesis xproof xassumptions  { $$ = {$1, $2, $3, $4, $5}; }
	| xname xanchor xproof xassumptions xthesis  { $$ = {$1, $2, $3, $4, $5}; }
	| xname xanchor xproof xthesis xassumptions  { $$ = {$1, $2, $3, $4, $5}; }
	| xname xassumptions xanchor xproof xthesis  { $$ = {$1, $2, $3, $4, $5}; }
	| xname xassumptions xanchor xthesis xproof  { $$ = {$1, $2, $3, $4, $5}; }
	| xname xassumptions xthesis xproof xanchor  { $$ = {$1, $2, $3, $4, $5}; }
	| xname xassumptions xthesis xanchor xproof  { $$ = {$1, $2, $3, $4, $5}; }
	| xname xassumptions xproof xthesis xanchor  { $$ = {$1, $2, $3, $4, $5}; }
	| xname xassumptions xproof xanchor xthesis  { $$ = {$1, $2, $3, $4, $5}; }
	| xname xthesis xanchor xassumptions xproof  { $$ = {$1, $2, $3, $4, $5}; }
	| xname xthesis xanchor xproof xassumptions  { $$ = {$1, $2, $3, $4, $5}; }
	| xname xthesis xassumptions xanchor xproof  { $$ = {$1, $2, $3, $4, $5}; }
	| xname xthesis xassumptions xproof xanchor  { $$ = {$1, $2, $3, $4, $5}; }
	| xname xthesis xproof xanchor xassumptions  { $$ = {$1, $2, $3, $4, $5}; }
	| xname xthesis xproof xassumptions xanchor  { $$ = {$1, $2, $3, $4, $5}; }
	| xname xproof xanchor xthesis xassumptions  { $$ = {$1, $2, $3, $4, $5}; }
	| xname xproof xanchor xassumptions xthesis  { $$ = {$1, $2, $3, $4, $5}; }
	| xname xproof xassumptions xthesis xanchor  { $$ = {$1, $2, $3, $4, $5}; }
	| xname xproof xassumptions xanchor xthesis  { $$ = {$1, $2, $3, $4, $5}; }
	| xname xproof xthesis xassumptions xanchor  { $$ = {$1, $2, $3, $4, $5}; }
	| xname xproof xthesis xanchor xassumptions  { $$ = {$1, $2, $3, $4, $5}; }
	| xanchor xname xproof xassumptions xthesis  { $$ = {$1, $2, $3, $4, $5}; }
	| xanchor xname xproof xthesis xassumptions  { $$ = {$1, $2, $3, $4, $5}; }
	| xanchor xname xassumptions xproof xthesis  { $$ = {$1, $2, $3, $4, $5}; }
	| xanchor xname xassumptions xthesis xproof  { $$ = {$1, $2, $3, $4, $5}; }
	| xanchor xname xthesis xproof xassumptions  { $$ = {$1, $2, $3, $4, $5}; }
	| xanchor xname xthesis xassumptions xproof  { $$ = {$1, $2, $3, $4, $5}; }
	| xanchor xassumptions xproof xthesis xname  { $$ = {$1, $2, $3, $4, $5}; }
	| xanchor xassumptions xproof xname xthesis  { $$ = {$1, $2, $3, $4, $5}; }
	| xanchor xassumptions xname xthesis xproof  { $$ = {$1, $2, $3, $4, $5}; }
	| xanchor xassumptions xname xproof xthesis  { $$ = {$1, $2, $3, $4, $5}; }
	| xanchor xassumptions xthesis xname xproof  { $$ = {$1, $2, $3, $4, $5}; }
	| xanchor xassumptions xthesis xproof xname  { $$ = {$1, $2, $3, $4, $5}; }
	| xanchor xthesis xproof xname xassumptions  { $$ = {$1, $2, $3, $4, $5}; }
	| xanchor xthesis xproof xassumptions xname  { $$ = {$1, $2, $3, $4, $5}; }
	| xanchor xthesis xname xproof xassumptions  { $$ = {$1, $2, $3, $4, $5}; }
	| xanchor xthesis xname xassumptions xproof  { $$ = {$1, $2, $3, $4, $5}; }
	| xanchor xthesis xassumptions xproof xname  { $$ = {$1, $2, $3, $4, $5}; }
	| xanchor xthesis xassumptions xname xproof  { $$ = {$1, $2, $3, $4, $5}; }
	| xanchor xproof xthesis xassumptions xname  { $$ = {$1, $2, $3, $4, $5}; }
	| xanchor xproof xthesis xname xassumptions  { $$ = {$1, $2, $3, $4, $5}; }
	| xanchor xproof xname xassumptions xthesis  { $$ = {$1, $2, $3, $4, $5}; }
	| xanchor xproof xname xthesis xassumptions  { $$ = {$1, $2, $3, $4, $5}; }
	| xanchor xproof xassumptions xname xthesis  { $$ = {$1, $2, $3, $4, $5}; }
	| xanchor xproof xassumptions xthesis xname  { $$ = {$1, $2, $3, $4, $5}; }
	| xassumptions xname xthesis xproof xanchor  { $$ = {$1, $2, $3, $4, $5}; }
	| xassumptions xname xthesis xanchor xproof  { $$ = {$1, $2, $3, $4, $5}; }
	| xassumptions xname xproof xthesis xanchor  { $$ = {$1, $2, $3, $4, $5}; }
	| xassumptions xname xproof xanchor xthesis  { $$ = {$1, $2, $3, $4, $5}; }
	| xassumptions xname xanchor xthesis xproof  { $$ = {$1, $2, $3, $4, $5}; }
	| xassumptions xname xanchor xproof xthesis  { $$ = {$1, $2, $3, $4, $5}; }
	| xassumptions xanchor xthesis xname xproof  { $$ = {$1, $2, $3, $4, $5}; }
	| xassumptions xanchor xthesis xproof xname  { $$ = {$1, $2, $3, $4, $5}; }
	| xassumptions xanchor xproof xname xthesis  { $$ = {$1, $2, $3, $4, $5}; }
	| xassumptions xanchor xproof xthesis xname  { $$ = {$1, $2, $3, $4, $5}; }
	| xassumptions xanchor xname xproof xthesis  { $$ = {$1, $2, $3, $4, $5}; }
	| xassumptions xanchor xname xthesis xproof  { $$ = {$1, $2, $3, $4, $5}; }
	| xassumptions xthesis xanchor xproof xname  { $$ = {$1, $2, $3, $4, $5}; }
	| xassumptions xthesis xanchor xname xproof  { $$ = {$1, $2, $3, $4, $5}; }
	| xassumptions xthesis xproof xanchor xname  { $$ = {$1, $2, $3, $4, $5}; }
	| xassumptions xthesis xproof xname xanchor  { $$ = {$1, $2, $3, $4, $5}; }
	| xassumptions xthesis xname xanchor xproof  { $$ = {$1, $2, $3, $4, $5}; }
	| xassumptions xthesis xname xproof xanchor  { $$ = {$1, $2, $3, $4, $5}; }
	| xassumptions xproof xanchor xname xthesis  { $$ = {$1, $2, $3, $4, $5}; }
	| xassumptions xproof xanchor xthesis xname  { $$ = {$1, $2, $3, $4, $5}; }
	| xassumptions xproof xthesis xname xanchor  { $$ = {$1, $2, $3, $4, $5}; }
	| xassumptions xproof xthesis xanchor xname  { $$ = {$1, $2, $3, $4, $5}; }
	| xassumptions xproof xname xthesis xanchor  { $$ = {$1, $2, $3, $4, $5}; }
	| xassumptions xproof xname xanchor xthesis  { $$ = {$1, $2, $3, $4, $5}; }
	| xthesis xname xanchor xassumptions xproof  { $$ = {$1, $2, $3, $4, $5}; }
	| xthesis xname xanchor xproof xassumptions  { $$ = {$1, $2, $3, $4, $5}; }
	| xthesis xname xassumptions xanchor xproof  { $$ = {$1, $2, $3, $4, $5}; }
	| xthesis xname xassumptions xproof xanchor  { $$ = {$1, $2, $3, $4, $5}; }
	| xthesis xname xproof xanchor xassumptions  { $$ = {$1, $2, $3, $4, $5}; }
	| xthesis xname xproof xassumptions xanchor  { $$ = {$1, $2, $3, $4, $5}; }
	| xthesis xanchor xname xproof xassumptions  { $$ = {$1, $2, $3, $4, $5}; }
	| xthesis xanchor xname xassumptions xproof  { $$ = {$1, $2, $3, $4, $5}; }
	| xthesis xanchor xassumptions xproof xname  { $$ = {$1, $2, $3, $4, $5}; }
	| xthesis xanchor xassumptions xname xproof  { $$ = {$1, $2, $3, $4, $5}; }
	| xthesis xanchor xproof xassumptions xname  { $$ = {$1, $2, $3, $4, $5}; }
	| xthesis xanchor xproof xname xassumptions  { $$ = {$1, $2, $3, $4, $5}; }
	| xthesis xassumptions xname xanchor xproof  { $$ = {$1, $2, $3, $4, $5}; }
	| xthesis xassumptions xname xproof xanchor  { $$ = {$1, $2, $3, $4, $5}; }
	| xthesis xassumptions xanchor xname xproof  { $$ = {$1, $2, $3, $4, $5}; }
	| xthesis xassumptions xanchor xproof xname  { $$ = {$1, $2, $3, $4, $5}; }
	| xthesis xassumptions xproof xname xanchor  { $$ = {$1, $2, $3, $4, $5}; }
	| xthesis xassumptions xproof xanchor xname  { $$ = {$1, $2, $3, $4, $5}; }
	| xthesis xproof xname xassumptions xanchor  { $$ = {$1, $2, $3, $4, $5}; }
	| xthesis xproof xname xanchor xassumptions  { $$ = {$1, $2, $3, $4, $5}; }
	| xthesis xproof xanchor xassumptions xname  { $$ = {$1, $2, $3, $4, $5}; }
	| xthesis xproof xanchor xname xassumptions  { $$ = {$1, $2, $3, $4, $5}; }
	| xthesis xproof xassumptions xanchor xname  { $$ = {$1, $2, $3, $4, $5}; }
	| xthesis xproof xassumptions xname xanchor  { $$ = {$1, $2, $3, $4, $5}; }
	| xproof xname xthesis xanchor xassumptions  { $$ = {$1, $2, $3, $4, $5}; }
	| xproof xname xthesis xassumptions xanchor  { $$ = {$1, $2, $3, $4, $5}; }
	| xproof xname xanchor xthesis xassumptions  { $$ = {$1, $2, $3, $4, $5}; }
	| xproof xname xanchor xassumptions xthesis  { $$ = {$1, $2, $3, $4, $5}; }
	| xproof xname xassumptions xthesis xanchor  { $$ = {$1, $2, $3, $4, $5}; }
	| xproof xname xassumptions xanchor xthesis  { $$ = {$1, $2, $3, $4, $5}; }
	| xproof xanchor xthesis xassumptions xname  { $$ = {$1, $2, $3, $4, $5}; }
	| xproof xanchor xthesis xname xassumptions  { $$ = {$1, $2, $3, $4, $5}; }
	| xproof xanchor xname xassumptions xthesis  { $$ = {$1, $2, $3, $4, $5}; }
	| xproof xanchor xname xthesis xassumptions  { $$ = {$1, $2, $3, $4, $5}; }
	| xproof xanchor xassumptions xname xthesis  { $$ = {$1, $2, $3, $4, $5}; }
	| xproof xanchor xassumptions xthesis xname  { $$ = {$1, $2, $3, $4, $5}; }
	| xproof xassumptions xthesis xname xanchor  { $$ = {$1, $2, $3, $4, $5}; }
	| xproof xassumptions xthesis xanchor xname  { $$ = {$1, $2, $3, $4, $5}; }
	| xproof xassumptions xname xthesis xanchor  { $$ = {$1, $2, $3, $4, $5}; }
	| xproof xassumptions xname xanchor xthesis  { $$ = {$1, $2, $3, $4, $5}; }
	| xproof xassumptions xanchor xthesis xname  { $$ = {$1, $2, $3, $4, $5}; }
	| xproof xassumptions xanchor xname xthesis  { $$ = {$1, $2, $3, $4, $5}; }
	| xproof xthesis xassumptions xanchor xname  { $$ = {$1, $2, $3, $4, $5}; }
	| xproof xthesis xassumptions xname xanchor  { $$ = {$1, $2, $3, $4, $5}; }
	| xproof xthesis xname xanchor xassumptions  { $$ = {$1, $2, $3, $4, $5}; }
	| xproof xthesis xname xassumptions xanchor  { $$ = {$1, $2, $3, $4, $5}; }
	| xproof xthesis xanchor xname xassumptions  { $$ = {$1, $2, $3, $4, $5}; }
	| xproof xthesis xanchor xassumptions xname  { $$ = {$1, $2, $3, $4, $5}; }
	;

/*
 *   openaghexercise attrs
 *    - name (text or math)
 *    - anchor (text)
 *    - content (text or math)
 *    - solution (text or math)
 */

xopenaghexerciseattrs:
	xname xanchor xcontent xsolution  { $$ = {$1, $2, $3, $4}; }
	| xname xanchor xsolution xcontent  { $$ = {$1, $2, $3, $4}; }
	| xname xcontent xanchor xsolution  { $$ = {$1, $2, $3, $4}; }
	| xname xcontent xsolution xanchor  { $$ = {$1, $2, $3, $4}; }
	| xname xsolution xanchor xcontent  { $$ = {$1, $2, $3, $4}; }
	| xname xsolution xcontent xanchor  { $$ = {$1, $2, $3, $4}; }
	| xanchor xname xsolution xcontent  { $$ = {$1, $2, $3, $4}; }
	| xanchor xname xcontent xsolution  { $$ = {$1, $2, $3, $4}; }
	| xanchor xcontent xsolution xname  { $$ = {$1, $2, $3, $4}; }
	| xanchor xcontent xname xsolution  { $$ = {$1, $2, $3, $4}; }
	| xanchor xsolution xcontent xname  { $$ = {$1, $2, $3, $4}; }
	| xanchor xsolution xname xcontent  { $$ = {$1, $2, $3, $4}; }
	| xcontent xname xanchor xsolution  { $$ = {$1, $2, $3, $4}; }
	| xcontent xname xsolution xanchor  { $$ = {$1, $2, $3, $4}; }
	| xcontent xanchor xname xsolution  { $$ = {$1, $2, $3, $4}; }
	| xcontent xanchor xsolution xname  { $$ = {$1, $2, $3, $4}; }
	| xcontent xsolution xname xanchor  { $$ = {$1, $2, $3, $4}; }
	| xcontent xsolution xanchor xname  { $$ = {$1, $2, $3, $4}; }
	| xsolution xname xcontent xanchor  { $$ = {$1, $2, $3, $4}; }
	| xsolution xname xanchor xcontent  { $$ = {$1, $2, $3, $4}; }
	| xsolution xanchor xcontent xname  { $$ = {$1, $2, $3, $4}; }
	| xsolution xanchor xname xcontent  { $$ = {$1, $2, $3, $4}; }
	| xsolution xcontent xanchor xname  { $$ = {$1, $2, $3, $4}; }
	| xsolution xcontent xname xanchor  { $$ = {$1, $2, $3, $4}; }
	;

xopenaghimgformulaattrs:
	xtype xfileid xformulatype xanchor    { $$ = {$1, $2, $3, $4}; }
	| xtype xfileid xanchor xformulatype  { $$ = {$1, $2, $3, $4}; }
	| xtype xformulatype xfileid xanchor  { $$ = {$1, $2, $3, $4}; }
	| xtype xformulatype xanchor xfileid  { $$ = {$1, $2, $3, $4}; }
	| xtype xanchor xfileid xformulatype  { $$ = {$1, $2, $3, $4}; }
	| xtype xanchor xformulatype xfileid  { $$ = {$1, $2, $3, $4}; }
	| xfileid xtype xanchor xformulatype  { $$ = {$1, $2, $3, $4}; }
	| xfileid xtype xformulatype xanchor  { $$ = {$1, $2, $3, $4}; }
	| xfileid xformulatype xanchor xtype  { $$ = {$1, $2, $3, $4}; }
	| xfileid xformulatype xtype xanchor  { $$ = {$1, $2, $3, $4}; }
	| xfileid xanchor xformulatype xtype  { $$ = {$1, $2, $3, $4}; }
	| xfileid xanchor xtype xformulatype  { $$ = {$1, $2, $3, $4}; }
	| xformulatype xtype xfileid xanchor  { $$ = {$1, $2, $3, $4}; }
	| xformulatype xtype xanchor xfileid  { $$ = {$1, $2, $3, $4}; }
	| xformulatype xfileid xtype xanchor  { $$ = {$1, $2, $3, $4}; }
	| xformulatype xfileid xanchor xtype  { $$ = {$1, $2, $3, $4}; }
	| xformulatype xanchor xtype xfileid  { $$ = {$1, $2, $3, $4}; }
	| xformulatype xanchor xfileid xtype  { $$ = {$1, $2, $3, $4}; }
	| xanchor xtype xformulatype xfileid  { $$ = {$1, $2, $3, $4}; }
	| xanchor xtype xfileid xformulatype  { $$ = {$1, $2, $3, $4}; }
	| xanchor xfileid xformulatype xtype  { $$ = {$1, $2, $3, $4}; }
	| xanchor xfileid xtype xformulatype  { $$ = {$1, $2, $3, $4}; }
	| xanchor xformulatype xfileid xtype  { $$ = {$1, $2, $3, $4}; }
	| xanchor xformulatype xtype xfileid  { $$ = {$1, $2, $3, $4}; }
	;

/*
 *   simple attrs (definition lemma example law rule conclusion derivation summary information annotation property)
 *    -> name (text or math)
 *    -> anchor (text)
 */

x_name_anchor:
	xname xanchor    { $$ = {$1, $2}; }
	| xanchor xname  { $$ = {$1, $2}; }
	;

/*
 *   attrs definitions
 */

xname:
	XNAME modulesimple QU  { $$ = {"name", $2}; }
	| XNAME QU             { $$ = {"name", ""}; }
	|                      { $$ = {"name", ""}; }
	;

xanchor:
	XANCHOR modulesimple QU  { $$ = {"anchor", $2}; }
	| XANCHOR QU             { $$ = {"anchor", ""}; }
	|                        { $$ = {"anchor", ""}; }
	;

xisnumeration:
	XISNUMERATION text QU  { $$ = {"isnumeration", $2}; }
	| XISNUMERATION QU     { $$ = {"isnumeration", ""}; }
	|                      { $$ = {"isnumeration", ""}; }
	;

xtype:
	XTYPE text QU  { $$ = {"type", $2}; }
	| XTYPE QU     { $$ = {"type", ""}; }
	|              { $$ = {"type", ""}; }
	;

xassumptions:
	XASSUMPTIONS module QU        { $$ = {"assumptions", $2}; }
	| XASSUMPTIONS QU             { $$ = {"assumptions", ""}; }
	|                             { $$ = {"assumptions", ""}; }
	;

xthesis:
	XTHESIS module QU        { $$ = {"thesis", $2}; }
	| XTHESIS QU             { $$ = {"thesis", ""}; }
	|                        { $$ = {"thesis", ""}; }
	;

xproof:
	XPROOF module QU        { $$ = {"proof", $2}; }
	| XPROOF QU             { $$ = {"proof", ""}; }
	|                       { $$ = {"proof", ""}; }
	;

xcontent:
	XCONTENT module QU        { $$ = {"content", $2}; }
	| XCONTENT QU             { $$ = {"content", ""}; }
	|                         { $$ = {"content", ""}; }
	;

xsolution:
	XSOLUTION module QU        { $$ = {"solution", $2}; }
	| XSOLUTION QU             { $$ = {"solution", ""}; }
	|                          { $$ = {"solution", ""}; }
	;

xnote:
	XNOTE modulesimple QU  { $$ = {"note", $2}; }
	| XNOTE QU             { $$ = {"note", ""}; }
	|                      { $$ = {"note", ""}; }
	;

xheadline:
	XHEADLINE modulesimple QU  { $$ = {"headline", $2}; }
	| XHEADLINE QU             { $$ = {"headline", ""}; }
	|                          { $$ = {"headline", ""}; }
	;

xfileid:
	XFILEID modulesimple QU  { $$ = {"fileId", $2}; }
	| XFILEID QU             { $$ = {"fileId", ""}; }
	|                       { $$ = {"fileId", ""}; }
	;

xformulatype:
	XFORMULATYPE text QU  { $$ = {"formulaType", $2}; }
	| XFORMULATYPE QU     { $$ = {"formulaType", ""}; }
	|                     { $$ = {"formulaType", ""}; }
	;

/*
 *   errors definitions
 */

errmath:
	ERRMATH
	| ERRWRSURR
	| ERRDOUBLEBR
	| ERRINVSURR
	| ERRDOUBLEDOLLAR
	;

%%

