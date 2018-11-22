#include <iostream>
#include <stdio.h>
#include "../gen/parser.tab.hh"

extern unsigned int mathjax_total;
extern int yylex(void);
extern FILE* yyin;
extern char* yytext;
extern int yylineno;

void yy::parser::error(std::string const&err) 
{
	std::cerr << "error: \"" << err << "\"\nat symbol: \"" << yytext << "\"\non line: " << yylineno << std::endl; 
	exit(1);
}

int main(int argc, char **argv)
{
	FILE *myfile = fopen(argv[1], "r");
	if (!myfile) {
		std::cout << "Can not open file. Usage: ./openagh filename" << std::endl;
		return 2;
	}
	yyin = myfile;

	yy::parser parser;
	do {
		parser.parse();
	} while (!feof(yyin));

	return 0;
}
void process_module(std::string module) { }
std::string div_openaghmathjax(std::map<std::string, std::string> attrs, std::string body) { return ""; }
std::string div() { return ""; }
std::string div(std::string cl) { return ""; }
std::string div(std::string openaghname, std::map<std::string, std::string> attrs, std::string body) { return ""; }
std::string div(std::string openaghname, std::map<std::string, std::string> attrs) { return ""; }

