%{
#include<stdio.h>

size_t linesCounter = 0;
size_t wordsCounter = 0; 

int yywrap();
int yylex(); 
%}

%s START
%s NEWLINE
%s WORD
%s SPACE

%%
    BEGIN(START);

<START,NEWLINE>[[:blank:]]|\\\n|\n      { }
<NEWLINE>.                              { printf("\n"); REJECT; }
<START,NEWLINE>.                        { ECHO; BEGIN(WORD); wordsCounter++; linesCounter++; }

<WORD>[[:blank:]]                       { BEGIN(SPACE); }
<WORD>\\\n                              { }
<WORD>\n                                { BEGIN(NEWLINE); }           

<SPACE>[[:blank:]]|\\\n                 { }
<SPACE>\n                               { BEGIN(NEWLINE); }
<SPACE>.                                { printf(" "); ECHO; BEGIN(WORD); wordsCounter++; }
%%

int yywrap() {
	return 1;
}

int main() {
	yylex();

	printf("\nlines: %zu words: %zu\n", linesCounter, wordsCounter);
	return 0;
}