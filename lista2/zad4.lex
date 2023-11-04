%{
#include<stdio.h>
#include <math.h>

#define MAX_STACK_SIZE 256
#define ERROR_MAX_SIZE 256

int stack[MAX_STACK_SIZE];
int stackTop;

char errorInfo[ERROR_MAX_SIZE] = "";

void init();

void stackPush(int value);
int stackPop();
int satckIsEmpty();
int stakSize();

void add();
void subtract();
void multiply();
void divide();
void mod();
void power();
void print();

int yywrap();
int yylex(); 
%}

%%
\-?[[:digit:]]+             { stackPush(atoi(yytext)); }
\+							{ add(); }
\-							{ subtract(); }
\*							{ multiply(); }
\/							{ divide(); }
%							{ mod(); }
\^							{ power(); }
\n							{ print(); }
[[:blank:]]*                { }
.                           { sprintf(errorInfo, "ERROR: Invalid character: '%s'", yytext); }
%%

void init() {
    stackTop = -1;
    strcpy(errorInfo, "");
}

void stackPush(int value) {
    stack[++stackTop] = value;
}

int stackPop() {
    return stack[stackTop--];
}

int stackIsEmpty() {
    return stackTop == -1;
}

int stackSize() {
    return stackTop + 1;
}

void add() {
    if(stackSize() < 2) {
        strcpy(errorInfo, "ERROR: Not enough arguments");
    }
    else {
        int a = stackPop();
        int b = stackPop();
        int res = a + b;
        stackPush(res);
    }
}

void subtract() {
    if(stackSize() < 2) {
        strcpy(errorInfo, "ERROR: Not enough arguments");
    }
    else {
        int a = stackPop();
        int b = stackPop();
        int res = b - a;
        stackPush(res);
    }
}

void multiply() {
    if(stackSize() < 2) {
        strcpy(errorInfo, "ERROR: Not enough arguments");
    }
    else {
        int a = stackPop();
        int b = stackPop();
        int res = a * b;
        stackPush(res);
    }
}

void divide() {
    if(stackSize() < 2) {
        strcpy(errorInfo, "ERROR: Not enough arguments");
    }
    else {
        int a = stackPop();
        int b = stackPop();

        if(a == 0) {
            strcpy(errorInfo, "ERROR: Division by zero");
        }
        else {
            int res = b / a;
            stackPush(res);
        }
    }
}

void mod() {
    if(stackSize() < 2) {
        strcpy(errorInfo, "ERROR: Not enough arguments");
    }
    else {
        int a = stackPop();
        int b = stackPop();

        if(a == 0) {
            strcpy(errorInfo, "ERROR: Division by zero");
        }
        else {
            int res = b % a;
            stackPush(res);
        }
    }
}

void power() {
    if(stackSize() < 2) {
        strcpy(errorInfo, "ERROR: Not enough arguments");
    }
    else {
        int a = stackPop();
        int b = stackPop();
        int res = pow(b, a);
        stackPush(res);
    }
}

void print() {
    if(strcmp(errorInfo, "") != 0) {
        printf("%s\n", errorInfo);
    } 
    else if(stackSize() > 1) {
        printf("%s\n", "ERROR: Not enough operators");
    }
    else {
        printf("%d\n", stackPop());
    }

    init();
}

int yywrap() {
	return 1;
}

int main() {
    init();

	yylex();

	return 0;
}