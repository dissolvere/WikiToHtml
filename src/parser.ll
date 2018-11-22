%top{
#include "../gen/parser.tab.hh"
#define YY_DECL yy::parser::symbol_type yylex()
}
%option noyywrap nounput batch noinput yylineno

WS         [\t\n\r ]*

%%

\{OPENAGHLEMMA{WS}\({WS}        { return yy::parser::make_OPENAGHLEMMASTART(yytext); }
\{OPENAGHDEFINITION{WS}\({WS}   { return yy::parser::make_OPENAGHDEFINITIONSTART(yytext); }
\{OPENAGHEXAMPLE{WS}\({WS}      { return yy::parser::make_OPENAGHEXAMPLESTART(yytext); }
\{OPENAGHLAW{WS}\({WS}          { return yy::parser::make_OPENAGHLAWSTART(yytext); }
\{OPENAGHRULE{WS}\({WS}         { return yy::parser::make_OPENAGHRULESTART(yytext); }
\{OPENAGHCONCLUSION{WS}\(       { return yy::parser::make_OPENAGHCONCLUSIONSTART(yytext); }
\{OPENAGHDERIVATION\({WS}       { return yy::parser::make_OPENAGHDERIVATIONSTART(yytext); }
\{OPENAGHSUMMARY{WS}\({WS}      { return yy::parser::make_OPENAGHSUMMARYSTART(yytext); }
\{OPENAGHINFORMATION{WS}\({WS}  { return yy::parser::make_OPENAGHINFORMATIONSTART(yytext); }
\{OPENAGHANNOTATION{WS}\({WS}   { return yy::parser::make_OPENAGHANNOTATIONSTART(yytext); }
\{OPENAGHPROPERTY{WS}\({WS}     { return yy::parser::make_OPENAGHPROPERTYSTART(yytext); }
\{OPENAGHMATHJAX{WS}\({WS}      { return yy::parser::make_OPENAGHMATHJAXSTART(yytext); }

\{OPENAGHLEMMA\}        { return yy::parser::make_OPENAGHLEMMAEND(yytext); }
\{OPENAGHDEFINITION\}   { return yy::parser::make_OPENAGHDEFINITIONEND(yytext); }
\{OPENAGHEXAMPLE\}      { return yy::parser::make_OPENAGHEXAMPLEEND(yytext); }
\{OPENAGHLAW\}          { return yy::parser::make_OPENAGHLAWEND(yytext); }
\{OPENAGHRULE\}         { return yy::parser::make_OPENAGHRULEEND(yytext); }
\{OPENAGHCONCLUSION\}   { return yy::parser::make_OPENAGHCONCLUSIONEND(yytext); }
\{OPENAGHDERIVATION\}   { return yy::parser::make_OPENAGHDERIVATIONEND(yytext); }
\{OPENAGHSUMMARY\}      { return yy::parser::make_OPENAGHSUMMARYEND(yytext); }
\{OPENAGHINFORMATION\}  { return yy::parser::make_OPENAGHINFORMATIONEND(yytext); }
\{OPENAGHANNOTATION\}   { return yy::parser::make_OPENAGHANNOTATIONEND(yytext); }
\{OPENAGHPROPERTY\}     { return yy::parser::make_OPENAGHPROPERTYEND(yytext); }
\{OPENAGHMATHJAX\}      { return yy::parser::make_OPENAGHMATHJAXEND(yytext); }

\{openaghnote\ {WS}        { return yy::parser::make_OPENAGHNOTESTART(yytext); }
\{openaghtheorem\ {WS}     { return yy::parser::make_OPENAGHTHEOREMSTART(yytext); }
\{openaghexercise\ {WS}    { return yy::parser::make_OPENAGHEXERCISESTART(yytext); }
\{openaghnotes\ {WS}       { return yy::parser::make_OPENAGHNOTESSTART(yytext); }
\{openaghquotations\ {WS}  { return yy::parser::make_OPENAGHQUOTATIONSSTART(yytext); }
\{openaghsimulation\ {WS}  { return yy::parser::make_OPENAGHSIMULATIONSTART(yytext); }
\{openaghimgformula\ {WS}  { return yy::parser::make_OPENAGHIMGFORMULASTART(yytext); }
\{openaghchemevisualization\ {WS}  { return yy::parser::make_OPENAGHCHEMEVISUALIZATIONSTART(yytext); }

name{WS}={WS}\"          { return yy::parser::make_XNAME(yytext); }
anchor{WS}={WS}\"        { return yy::parser::make_XANCHOR(yytext); }
assumptions{WS}={WS}\"   { return yy::parser::make_XASSUMPTIONS(yytext); }
thesis{WS}={WS}\"        { return yy::parser::make_XTHESIS(yytext); }
proof{WS}={WS}\"         { return yy::parser::make_XPROOF(yytext); }
body{WS}={WS}\"          { return yy::parser::make_XCONTENT(yytext); }
solution{WS}={WS}\"      { return yy::parser::make_XSOLUTION(yytext); }
note{WS}={WS}\"          { return yy::parser::make_XNOTE(yytext); }
type{WS}={WS}\"          { return yy::parser::make_XTYPE(yytext); }
isNumeration{WS}={WS}\"  { return yy::parser::make_XISNUMERATION(yytext); }
headline{WS}={WS}\"      { return yy::parser::make_XHEADLINE(yytext); }
fileId{WS}={WS}\"        { return yy::parser::make_XFILEID(yytext); }
caption{WS}={WS}\"       { return yy::parser::make_XCAPTION(yytext); }
formulaType{WS}={WS}\"   { return yy::parser::make_XFORMULATYPE(yytext); }

\{img\ [^}{]*\}               { return yy::parser::make_IMG(yytext); }
\{vimeo\ [^}{]*\}             { return yy::parser::make_VIMEO(yytext); }
\{youtube\ [^}{]*\}           { return yy::parser::make_YOUTUBE(yytext); }
\{mediaplayer\ [^}{]*\}       { return yy::parser::make_MEDIAPLAYER(yytext); }
\{SUB\(\)\}[^}{]*\{SUB\}      { return yy::parser::make_SUB(yytext); }
\{openaghquotation\ [^}{]*\}  { return yy::parser::make_OPENAGHQUOTATION(yytext); }

$$$openaghTableAttributeS$$${WS}  { return yy::parser::make_TABLEHEADSTART(yytext); }
$$$openaghTableAttributeE$$${WS}  { return yy::parser::make_TABLEHEADEND(yytext); }

\\\\  { return yy::parser::make_TEXT(yytext); }

\\\(|\\\)|\\\]|\\\[                                                       { return yy::parser::make_ERRMATH(yytext); }
\{BOX|\{maketoc|\{ANAME|\{CODE|\{DIV|\{ALINK                              { return yy::parser::make_ERRWRSURR(yytext); }
\{\{OPENAGH|\{\{openagh                                                   { return yy::parser::make_ERRDOUBLEBR(yytext); }
\{OPENAGHTHEOREM|\{OPENAGHEXERCISE                                        { return yy::parser::make_ERRINVSURR(yytext); }
(([^\"\}\{\\]*)|(\{[^\"\}\{\\]*\}))$$(([^\"\}\{\\]*)|(\{[^\"\}\{\\]*\}))  { return yy::parser::make_ERRDOUBLEDOLLAR(yytext); }

(\\)|(\\\{)|(\\\})  { return yy::parser::make_TEXT(yytext); }

\"{WS}  { return yy::parser::make_QU(yytext); }
\}{WS}  { return yy::parser::make_BR(yytext); }
\{{WS}  { return yy::parser::make_BL(yytext); }
\){WS}  { return yy::parser::make_NR(yytext); }
\({WS}  { return yy::parser::make_NL(yytext); }

([^\"\}\{\\]*)  { return yy::parser::make_TEXT(yytext); }

<<EOF>> return yy::parser::make_END();

%%
