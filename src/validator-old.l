%{
#include <iostream>
#include "../gen/validator-old.h"
using namespace std;
#define YY_DECL extern "C" int yylex()
%}

%option yylineno

WS         [\t\n\r ]*

QANY       [\(\)a-zA-Z0-9,_'` \-ZĄĆĘŁŃÓŚŹŻąćęłńóśźż”„:\.\[\]\/#]*
QMATHTYPE  (block|inline)
QLOGICAL   (yes|no)
QNUMERIC   [0-9]*

VNAME      (name{WS}={WS}\"{WS}{QANY}{WS}\"{WS})?
VANCHOR    (anchor{WS}={WS}\"{WS}{QANY}{WS}\"{WS})?
VM1        (anchor{WS}={WS}\"{WS}{QANY}{WS}\"{WS})?
VM2        (type{WS}={WS}\"{WS}{QMATHTYPE}{WS}\"{WS})?
VM3        (isNumeration{WS}={WS}\"{WS}{QLOGICAL}{WS}\"{WS})?
VHEADLINE  (headline{WS}={WS}\"{WS}{QANY}{WS}\"{WS})?
VNOTE      (note{WS}={WS}\"{WS}{QANY}{WS}\"{WS})?
VFILEID    (fileId{WS}={WS}\"{WS}{QNUMERIC}{WS}\"{WS})?

%%

\{OPENAGHLEMMA{WS}\({WS}        { return OPENAGHLEMMASTART; }
\{OPENAGHDEFINITION{WS}\({WS}   { return OPENAGHDEFINITIONSTART; }
\{OPENAGHEXAMPLE{WS}\({WS}      { return OPENAGHEXAMPLESTART; }
\{OPENAGHLAW{WS}\({WS}          { return OPENAGHLAWSTART; }
\{OPENAGHRULE{WS}\({WS}         { return OPENAGHRULESTART; }
\{OPENAGHCONCLUSION{WS}\(       { return OPENAGHCONCLUSIONSTART; }
\{OPENAGHDERIVATION\({WS}       { return OPENAGHDERIVATIONSTART; }
\{OPENAGHSUMMARY{WS}\({WS}      { return OPENAGHSUMMARYSTART; }
\{OPENAGHINFORMATION{WS}\({WS}  { return OPENAGHINFORMATIONSTART; }
\{OPENAGHANNOTATION{WS}\({WS}   { return OPENAGHANNOTATIONSTART; }
\{OPENAGHPROPERTY{WS}\({WS}     { return OPENAGHPROPERTYSTART; }

\{OPENAGHLEMMA\}        { return OPENAGHLEMMAEND; }
\{OPENAGHDEFINITION\}   { return OPENAGHDEFINITIONEND; }
\{OPENAGHEXAMPLE\}      { return OPENAGHEXAMPLEEND; }
\{OPENAGHLAW\}          { return OPENAGHLAWEND; }
\{OPENAGHRULE\}         { return OPENAGHRULEEND; }
\{OPENAGHCONCLUSION\}   { return OPENAGHCONCLUSIONEND; }
\{OPENAGHDERIVATION\}   { return OPENAGHDERIVATIONEND; }
\{OPENAGHSUMMARY\}      { return OPENAGHSUMMARYEND; }
\{OPENAGHINFORMATION\}  { return OPENAGHINFORMATIONEND; }
\{OPENAGHANNOTATION\}   { return OPENAGHANNOTATIONEND; }
\{OPENAGHPROPERTY\}     { return OPENAGHPROPERTYEND; }

\{openaghnote\ {WS}      { return OPENAGHNOTESTART; }
\{openaghtheorem\ {WS}   { return OPENAGHTHEOREMSTART; }
\{openaghexercise\ {WS}  { return OPENAGHEXERCISESTART; }

name{WS}={WS}\"         { return XNAME; }
anchor{WS}={WS}\"       { return XANCHOR; }
assumptions{WS}={WS}\"  { return XASSUMPTIONS; }
thesis{WS}={WS}\"       { return XTHESIS; }
proof{WS}={WS}\"        { return XPROOF; }
body{WS}={WS}\"         { return XCONTENT; }
solution{WS}={WS}\"     { return XSOLUTION; }
note{WS}={WS}\"         { return XNOTE; }

\{OPENAGHMATHJAX{WS}\({WS}({VM1}{VM2}{VM3}|{VM1}{VM3}{VM2}|{VM2}{VM1}{VM3}|{VM2}{VM3}{VM1}|{VM3}{VM2}{VM1}|{VM3}{VM1}{VM2}){WS}\){WS}\} { return OPENAGHMATHJAXSTART; }
\{OPENAGHMATHJAX\} { return OPENAGHMATHJAXEND; }

\{openaghnotes\ {WS}{VHEADLINE}{WS}\}       { return OPENAGHNOTES; }
\{openaghquotations\ {WS}{VHEADLINE}{WS}\}  { return OPENAGHQUOTATIONS; }
\{openaghquotation\ [^}{]*\}                { return OPENAGHQUOTATION; }
\{openaghsimulation\ {WS}{VFILEID}{WS}\}    { return OPENAGHSIMULATION; }

\{img\ [^}{]*\}           { return IMG; }
\{vimeo\ [^}{]*\}         { return VIMEO; }
\{youtube\ [^}{]*\}       { return YOUTUBE; }
\{mediaplayer\ [^}{]*\}   { return MEDIAPLAYER; }
\{SUB\(\)\}[^}{]*\{SUB\}  { return SUB; }

\\\(|\\\)|\\\]|\\\[                                                       { return ERRMATH; }
\{BOX|\{maketoc|\{ANAME|\{CODE|\{DIV|\{ALINK                              { return ERRWRSURR; }
\{\{OPENAGH|\{\{openagh                                                   { return ERRDOUBLEBR; }
\{OPENAGHTHEOREM|\{OPENAGHEXERCISE                                        { return ERRINVSURR; }
(([^\"\}\{\\]*)|(\{[^\"\}\{\\]*\}))$$(([^\"\}\{\\]*)|(\{[^\"\}\{\\]*\}))  { return ERRDOUBLEDOLLAR; }

(\\)|(\\\{)|(\\\})  {yylval.sval = strdup(yytext); return TEXT;}

\"{WS}  { return QU; }
\}{WS}  { return BR; }
\{{WS}  { return BL; }
\){WS}  { return NR; }
\({WS}  { return NL; }

([^\"\}\{\\]*) { yylval.sval = strdup(yytext); return TEXT; }

%%
