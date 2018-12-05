#include <iostream>
#include <stdio.h>
#include <fstream>
#include "../gen/parser.tab.hh"

extern unsigned int mathjax_total;
/*
It is called to invoke the lexer, 
each time yylex() is called, the scanner 
continues processing the input from where it last left off.
*/
extern int yylex(void);
extern int yy_scan_string(const char *);
//Buffer that holds the input characters that actually match the pattern
extern char* yytext;
extern int yylineno;
std::fstream input_file;
std::fstream output_file;

void yy::parser::error(std::string const&err) 
{
	std::cout << "error: \"" << err << "\"\nat symbol: \"" << yytext << "\"\non line: " << yylineno << std::endl; 
	//exit(1);
}

int main(int argc, char **argv)
{
    input_file.open(argv[1], std::ios::in);
    if(output_file.good())
    {
		//File exists so we can read from this file
    }
    else
    {
		//There is no input file
        std::cout<<"Input file doesn't exist!"<<std::endl;
        return 1;
    }

	output_file.open("../tests/html/file.html", std::ios::in);
    if(output_file.good())
    {
		//This file exists, we don't want overwrite data
        std::cout<<"Output file - file.html exists!"<<std::endl;
        output_file.close();
        return 1;
    }
    else
    {
        //File doesn't exist so we can create this file
        output_file.close();
    }
	



	output_file.open("../tests/html/file.html", std::ios::out);
	if(output_file.good())
    {
        std::cout<<"File.html created"<<std::endl;
        output_file<<"<html>"<<std::endl;
        output_file<<"<head>"<<std::endl;
        output_file<<"<meta charset=\"utf-8\">"<<std::endl;
        output_file<<"<script src='https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-MML-AM_CHTML' async></script>"<<std::endl;
        output_file<<"</head>"<<std::endl;
        output_file<<"<body>"<<std::endl;


		yy::parser parser;
		std::string line;
		std::string mini_module;

		do
		{	
			do
			{
				getline(input_file, line);
				if(line == "")
					mini_module += '\n';
				else
					mini_module += line;
			}while(line != "" && !input_file.eof());

			//std::cout<<mini_module<<std::endl;
			yy_scan_string(mini_module.c_str());
			parser.parse();
			mini_module = "";

		}while(!input_file.eof());

		input_file.close();

		output_file<<"</body>"<<std::endl;
		output_file<<"</html>"<<std::endl;
		output_file.close();
	}
    else
    {
		//File has not been loaded
        std::cout<<"Cannot create output_file!"<<std::endl;
		return 1;
    }

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
    for (int i=0; i<module.length(); i++)
    {
        if(module[i] == '\n')
        {
           output_file<<"<br>"<<std::endl;
        }
        else
        {
            output_file<<module[i];
        }
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
