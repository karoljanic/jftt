%{
#include<stdio.h>

int saveDocumentation = 0;

int yywrap();
int yylex(); 
%}

%s STRING
%s DOCUMENTATION
%s MULTILINE_COMMENT

%%
<INITIAL>\"                                                             { ECHO; BEGIN(STRING); /* enter to string */ }
<STRING>[^\\](\\\\)*\"                                                  { ECHO; BEGIN(INITIAL); /* exit string */ }

<INITIAL>(\/\*\*)|(\/\*!)				                                { if(saveDocumentation) { ECHO; } BEGIN(DOCUMENTATION); /* enter to multiline doc */ };
<DOCUMENTATION>.*\*\/						                            { if(saveDocumentation) { ECHO; } BEGIN(INITIAL); /* exit multiline doc */ };
<DOCUMENTATION>.							                            { if(saveDocumentation) { ECHO; } /* remove or save multiline documentation */ };

<INITIAL>\/\*							                                { BEGIN(MULTILINE_COMMENT); /* enter to multiline comment */};
<MULTILINE_COMMENT>.*\*\/				                                { BEGIN(INITIAL); /* exit multiline comment */ };
<MULTILINE_COMMENT>.                                                    { /* remove multiline comment */ }

<INITIAL>((\/\/\/)|(\/\/!)).*(\\\n.*)*                                  { if(saveDocumentation) { ECHO; } /* remove or save single doc comments */ }
<INITIAL>\/\/.*(\\\n.*)*				                                { /* remove single comments */ };
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