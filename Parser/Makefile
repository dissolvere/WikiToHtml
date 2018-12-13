INC = -I./mongo-c-driver/include/libbson-1.0 -I./mongo-c-driver/include/libmongoc-1.0
LIB = -L./mongo-c-driver/lib -lbson-1.0 -lmongoc-1.0
G++ = g++

all: gen bin bin/parser


bin/parser: gen/parser.yy.c gen/parser.tab.o src/parser.cc
	$(G++) -m32 -static-libgcc -static-libstdc++ -std=c++11 -g gen/parser.tab.o gen/parser.yy.c src/parser.cc -o bin/parser $(INC) $(LIB)

gen/parser.yy.c: src/parser.ll gen/parser.tab.cc
	flex -o gen/parser.yy.c src/parser.ll

gen/parser.tab.o: gen/parser.tab.cc
	$(G++) -m32 -std=c++11 -g -c -o gen/parser.tab.o gen/parser.tab.cc

gen/parser.tab.cc: src/parser.yy gen
	bison -d src/parser.yy -o gen/parser.tab.cc

gen:
	mkdir gen

bin:
	mkdir bin
