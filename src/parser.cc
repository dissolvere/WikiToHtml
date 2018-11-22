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
	std::cout << "error: \"" << err << "\"\nat symbol: \"" << yytext << "\"\non line: " << yylineno << std::endl; 
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

std::string div_openaghmathjax(std::map<std::string, std::string> attrs, std::string body)
{
	bool is_block = !attrs["type"].compare("block");
	bool is_numeration = !attrs["isnumeration"].compare("yes");
	std::string to_return = "";
	if (!is_block)
	{
		to_return += "\\( " + body + " \\)";
	}
	else
	{
		to_return += "<div class=\"openaghmathjax-block\" style=\"text-align: center;\">";
		if (!attrs["anchor"].compare(""))
		{
			to_return += "<a name=\"" + attrs["anchor"] + "></a>";
		}
		if (is_numeration)
		{
			to_return += "<div class=\"openaghmathjax-numer\">";
			to_return += std::to_string(++mathjax_total);
			to_return += "</div>";
		}
		to_return += "<div class=\"openaghmathjax-wzor\">\\( " + body + " \\)</div>";
		to_return += "</div>";
	}
	return to_return;
}

void process_module(std::string module)
{
	std::cout << "\n\n" << module << "\n\n" ;
}

std::string div()
{
	return "</div>";
}

std::string div(std::string cl)
{
	return "<div class=\"" + cl + "\">";
}

std::string div(std::string openaghname, std::map<std::string, std::string> attrs, std::string body)
{
	std::string to_return = "";
	to_return += div(openaghname);
	for(auto attr : attrs)
	{
		to_return += div(openaghname + "-" + attr.first) + attr.second + div();
	}
	to_return += div(openaghname + "-data") + body + div();
	to_return += div();
	return to_return;
}

std::string div(std::string openaghname, std::map<std::string, std::string> attrs)
{
	std::string to_return = "";
	to_return += div(openaghname);
	for(auto attr : attrs)
	{
		to_return += div(openaghname + "-" + attr.first) + attr.second + div();
	}
	to_return += div();
	return to_return;
}
