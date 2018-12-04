#include <iostream>
#include <stdio.h>
#include <fstream>
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
	std::fstream file;
    file.open("../tests/html/file.html", std::ios::in);
    if(file.good())
    {
        std::cout<<"File file.html exists!"<<std::endl;
        file.close();
        return;
    }
    else
    {
        std::cout<<"This file doesn't exist"<<std::endl;
        file.close();
    }

    file.open("../tests/html/file.html", std::ios::out);
    if(file.good())
    {
        std::cout<<"File created"<<std::endl;
        file<<"<html>"<<std::endl;
        file<<"<head>"<<std::endl;
        file<<"<meta charset=\"utf-8\">"<<std::endl;
        file<<"<script src='https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-MML-AM_CHTML' async></script>"<<std::endl;
        file<<"</head>"<<std::endl;
        file<<"<body>"<<std::endl;

        for (int i=0; i<module.length(); i++)
        {
            if(module[i] == '\n')
            {
                file<<"<br>"<<std::endl;
            }
            else
            {
                file<<module[i];
            }
        } 

        file<<"</body>"<<std::endl;
        file<<"</html>"<<std::endl;
        file.close();
    }
    else
    {
        std::cout<<"Cannot create file!"<<std::endl;
    }
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
