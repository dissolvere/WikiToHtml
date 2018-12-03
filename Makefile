all: build distrib

test: bin/validator-new bin/parser
	sh tests/validator/validator-new-test.sh

build: bin/validator-new bin/parser

validator: bin/validator-new

validator-tables: gen/parser.yy.c gen/parser.tab.cc


bin/validator-new: gen/parser.yy.c gen/parser.tab.o src/validator-new.cc
	g++ -std=c++11 -g -o bin/validator-new gen/parser.tab.o gen/parser.yy.c src/validator-new.cc

bin/parser: gen/parser.yy.c gen/parser.tab.o src/parser.cc
	g++ -std=c++11 -g -o bin/parser gen/parser.tab.o gen/parser.yy.c src/parser.cc

gen/parser.yy.c: src/parser.ll gen/parser.tab.cc
	flex -o gen/parser.yy.c src/parser.ll

gen/parser.tab.o: gen/parser.tab.cc
	g++ -std=c++11 -g -c -o gen/parser.tab.o gen/parser.tab.cc

gen/parser.tab.cc: src/parser.yy gen
	bison -d src/parser.yy -o gen/parser.tab.cc


gen:
	mkdir gen

bin:
	mkdir bin
