%{
#include<stdio.h>

int saveDocumentation = 0;

int yywrap();
int yylex(); 
%} 

BREAK_LINE      (\\\n.*)*

%s STRING
%s DOCUMENTATION
%s MULTILINE_COMMENT

%%
<INITIAL>\"                                                                                                     { ECHO; BEGIN(STRING); /* enter to string */ }
<STRING>[^\\](\\\\)*\"                                                                                          { ECHO; BEGIN(INITIAL); /* exit string */ }

<INITIAL>(\/{BREAK_LINE}\*{BREAK_LINE}\*)|(\/{BREAK_LINE}\*{BREAK_LINE}!)				                        { if(saveDocumentation) { ECHO; } BEGIN(DOCUMENTATION); /* enter to multiline doc */ };
<DOCUMENTATION>{BREAK_LINE}\*{BREAK_LINE}\/						                                                { if(saveDocumentation) { ECHO; } BEGIN(INITIAL); /* exit multiline doc */ };
<DOCUMENTATION>.							                                                                    { if(saveDocumentation) { ECHO; } /* remove or save multiline documentation */ };

<INITIAL>\/{BREAK_LINE}\*							                                                            { BEGIN(MULTILINE_COMMENT); /* enter to multiline comment */};
<MULTILINE_COMMENT>{BREAK_LINE}\*{BREAK_LINE}\/				                                                    { BEGIN(INITIAL); /* exit multiline comment */ };
<MULTILINE_COMMENT>.                                                                                            { /* remove multiline comment */ }

<INITIAL>((\/{BREAK_LINE}\/{BREAK_LINE}\/)|(\/{BREAK_LINE}\/{BREAK_LINE}!)).*{BREAK_LINE}.*$                    { if(saveDocumentation) { ECHO; } /* remove or save single doc comments */ }
<INITIAL>\/{BREAK_LINE}\/.*{BREAK_LINE}.*$				                                                        { /* remove single comments */ };
%%

int yywrap() {
	return 1;
}

int main(int argc, char** argv) {
    if (argc > 1 && strcmp(argv[1], "-savedoc") == 0) {
        saveDocumentation = 1;
    }
    
	yylex();

	return 0;
}