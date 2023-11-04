%{
#include<stdio.h>

size_t linesCounter = 0;
size_t wordsCounter = 0; 

int yywrap();
int yylex(); 
%}

%%
^[[:blank:]]*\n	                { /* remove blank lines */ };
[[:blank:]]+$                   { /* remove whitespace at end of lines */ };
^[[:blank:]]+		            { /* remove whitespace at begin of lines */ };
[[:blank:]]{1,}		            { printf(" "); wordsCounter++; /* remove extra whitespace between words and count words */ }
\n                              { printf("\n"); linesCounter++; wordsCounter++; /* count line */ }
%%

int yywrap() {
	return 1;
}

int main() {
	yylex();

	printf("lines: %zu words: %zu\n", linesCounter, wordsCounter);
	return 0;
}