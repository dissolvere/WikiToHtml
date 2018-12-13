#include <iostream>
#include <stdio.h>
#include <fstream>
#include "../gen/parser.tab.hh"
#include <mongoc.h>
#include <bson.h>

extern unsigned int mathjax_total;
extern int yylex(void);
extern int yy_scan_string(const char *);
extern char* yytext;
extern int yylineno;
std::string data_string;

void yy::parser::error(std::string const&err) 
{
	std::cout << "error: \"" << err << "\"\nat symbol: \"" << yytext << "\"\non line: " << yylineno << std::endl; 
}

int main(int argc, char **argv)
{
	std::fstream input_file;
	mongoc_uri_t *uri;
	mongoc_client_t *client;
	mongoc_database_t *database;
   	mongoc_collection_t *collection;
	bson_t *command, reply, *insert;
	bson_error_t error;
	const char * input_file_name;
	const char * uri_string;
	const char * db_name;
	const char * collection_name;
	std::string path;
	char *str;
	bool retval;

	mongoc_init ();

	//Get program arguments
	if(argc != 5)
	{
		std::cout<<"Wrong number of program arguments!"<<std::endl;
        return 1;
	}
	else
	{
		input_file_name = argv[1];
		uri_string = argv[2];
		db_name = argv[3];
		collection_name = argv[4];

		std::string program_path = argv[0]; 		//Full path with .exe file
		std::string part_path;
		path; 										//Path without .exe file
		for(int i =0; i< program_path.size(); i++)
		{
			part_path+=program_path[i];

			if(program_path[i] == '/' || program_path[i] == '\\')
			{
				path+=part_path;
				part_path.clear();
			}
		}
	}

	//Connect to the database
	uri = mongoc_uri_new_with_error (uri_string, &error);
	if (!uri) 
	{
      fprintf (stderr,
               "failed to parse URI: %s\n"
               "error message:       %s\n",
               uri_string,
               error.message);
      return EXIT_FAILURE;
	}
	else
	{
	   std::cout<<"Successfully connected!"<<std::endl;
	}

	//Parse input file
	input_file.open(path+input_file_name, std::ios::in);
    if(input_file.good())
    {
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

			yy_scan_string(mini_module.c_str());
			parser.parse();
			mini_module = "";

		}while(!input_file.eof());

		input_file.close();
    }
    else
    {
        std::cout<<"Cannot open input file!"<<std::endl;
        return 1;
    }

	//Add data to the database
	client = mongoc_client_new_from_uri (uri);
	if (!client) 
	{
		return EXIT_FAILURE;
	}

	database = mongoc_client_get_database (client, db_name);
   	collection = mongoc_client_get_collection (client, db_name, collection_name);
	command = BCON_NEW ("ping", BCON_INT32 (1));

	retval = mongoc_client_command_simple (client, "admin", command, NULL, &reply, &error);
	if (!retval) 
	{
      fprintf (stderr, "%s\n", error.message);
      return EXIT_FAILURE;
   	}

	str = bson_as_json (&reply, NULL);
   	printf ("%s\n", str);

   	insert = BCON_NEW ("parser", BCON_UTF8 (data_string.c_str()));

   	if (!mongoc_collection_insert_one (collection, insert, NULL, NULL, &error)) {
      fprintf (stderr, "%s\n", error.message);
   	}
	   
	bson_destroy (insert);
   	bson_destroy (&reply);
   	bson_destroy (command);
   	bson_free (str);

	mongoc_collection_destroy (collection);
   	mongoc_database_destroy (database);
   	mongoc_uri_destroy (uri);
   	mongoc_client_destroy (client);
   	mongoc_cleanup ();

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
    data_string+=module+'\n';
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
