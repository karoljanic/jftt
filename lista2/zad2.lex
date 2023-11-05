%{
#include <stdio.h>

int yywrap();
int yylex(); 
%}

%s START
%s NEUTRAL
%s SINGLE_PARENTHESIS
%s DOUBLE_PARENTHESIS
%s CDATA

%%
    BEGIN(START);

<START>\'           					{ ECHO; BEGIN(SINGLE_PARENTHESIS); }
<START>\"           					{ ECHO; BEGIN(DOUBLE_PARENTHESIS); }
<START>\<!\[CDATA\[						{ ECHO; BEGIN(CDATA); }

<NEUTRAL>\'           					{ ECHO; BEGIN(SINGLE_PARENTHESIS); }
<NEUTRAL>\"           					{ ECHO; BEGIN(DOUBLE_PARENTHESIS); }
<NEUTRAL>\<!\[CDATA\[					{ ECHO; BEGIN(CDATA); }

<SINGLE_PARENTHESIS>\'					{ ECHO; BEGIN(NEUTRAL); }
<DOUBLE_PARENTHESIS>\"					{ ECHO; BEGIN(NEUTRAL); }
<CDATA>\]\]\>							{ ECHO; BEGIN(NEUTRAL); }

<NEUTRAL>\.								{ ECHO; }
<NEUTRAL><!--((-?[^-])*-?)-->			{ }
%%

int yywrap() {
	return 1;
}

int main() {
	yylex();

	return 0;
}