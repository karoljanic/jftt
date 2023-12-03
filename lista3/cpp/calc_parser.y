%{
#include <iostream>
#include <string>
#include <vector>
#include <sstream>

#include "GaloisField.hpp"

#define YYSTYPE int64_t

GaloisField<int64_t, 1234577> GF;
GaloisField<int64_t, 1234576> EXP_GF;

int yylex();
void yyerror(const char* s);

std::vector<std::string> onp;
bool errorFlag;
std::string errorStr;
%}

%token NUM
%token ADD
%token SUB
%token MUL
%token DIV
%token POW
%token L_BRA
%token R_BRA
%token EOL
%token ERROR


%left ADD SUB
%left MUL DIV
%precedence NEG
%right POW

%%
input:
    %empty 
|   input line
;

line:
    EOL
|   expression EOL   
    {
        if(!errorFlag) {
            for(const auto& token: onp) {
                std::cout << token;
            }
            std::cout << std::endl << "Result: " << $1 << std::endl;
            onp.clear();
        } else {
            std::cout << errorStr << std::endl;
            errorFlag = false;
            onp.clear();
        }
    }
|   error EOL
    {
        std::cout << "ERROR: Invalid syntax" << std::endl;
        errorFlag = false;
        onp.clear();
    }
;

expression:
    NUM                         
    { 
        auto result = GF.convertToFieldElement($1);
        $$ = result; 
        onp.push_back(std::to_string(result));
        onp.push_back(" ");
    }
|   expression ADD expression            
    {   
        auto result = GF.add($1, $3);
        $$ = result; 
        onp.push_back("+ ");
    }
|   expression SUB expression           
    { 
        auto result = GF.subtract($1, $3);
        $$ = result;
        onp.push_back("- ");
    }
|   expression MUL expression            
    {   
        auto result = GF.multiply($1, $3);
        $$ = result; 
        onp.push_back("* ");
    }
|   expression DIV expression             
    { 
        auto result = GF.divide($1, $3);
        if(result) {
            $$ = *result;
        }
        else {
            std::ostringstream message;
            message << "ERROR: " << $3 << " is not invertible in GF(1234577)";
            yyerror(message.str().c_str());
        }

        onp.push_back("/ ");
    }
|   SUB expression %prec NEG   
    {
        auto result = GF.opposite($2);
        $$ = result; 
        onp.pop_back();
        onp.pop_back();
        onp.push_back(std::to_string(result));
        onp.push_back(" ");
    }
|   expression POW exponent
    {   
        auto result = GF.power($1, $3);
        $$ = result;
        onp.push_back("^ ");
    }
|   L_BRA expression R_BRA
    { 
        $$ = $2; 
    }
;

exponent:
    NUM                         
    { 
        auto result = EXP_GF.convertToFieldElement($1);
        $$ = result; 
        onp.push_back(std::to_string(result));
        onp.push_back(" ");
    }
|   exponent ADD exponent            
    {   
        auto result = EXP_GF.add($1, $3);
        $$ = result; 
        onp.push_back("+ ");
    }
|   exponent SUB exponent           
    { 
        auto result = EXP_GF.subtract($1, $3);
        $$ = result;
        onp.push_back("- ");
    }
|   exponent MUL exponent            
    {   
        auto result = EXP_GF.multiply($1, $3);
        $$ = result; 
        onp.push_back("* ");
    }
|   exponent DIV exponent             
    { 
        auto result = EXP_GF.divide($1, $3);
        if(result) {
            $$ = *result;
        }
        else {
            std::ostringstream message;
            message << "ERROR: " << $3 << " is not invertible in GF(1234576)";
            yyerror(message.str().c_str());
        }

        onp.push_back("/ ");
    }
|   SUB exponent %prec NEG      
    {   
        auto result = EXP_GF.opposite($2);
        $$ = result; 
        onp.pop_back();
        onp.pop_back();
        onp.push_back(std::to_string(result));
        onp.push_back(" ");
    }
|   L_BRA exponent R_BRA
    { 
        $$ = $2; 
    }
%%

void yyerror(const char* s) {
    errorFlag = true;
    errorStr = s;
    onp.clear();
}

int main() {
    onp.clear();
    return yyparse();
}
