FF := flex
FFLAGS :=
CC := gcc
CFLAGS := -Wall -Wextra -pedantic

all: zad1v1 zad1v2 zad2 zad3 zad4

zad1v1:
	${FF} $(FFLAGS) -ozad1v1.c zad1v1.lex
	$(CC) $(CFLAGS) zad1v1.c -o zad1v1

zad1v2:
	${FF} $(FFLAGS) -ozad1v2.c zad1v2.lex
	$(CC) $(CFLAGS) zad1v2.c -o zad1v2

zad2:
	${FF} $(FFLAGS) -ozad2.c zad2.lex
	$(CC) $(CFLAGS) zad2.c -o zad2

zad3:
	${FF} $(FFLAGS) -ozad3.c zad3.lex
	$(CC) $(CFLAGS) zad3.c -o zad3

zad4:
	${FF} $(FFLAGS) -ozad4.c zad4.lex
	$(CC) $(CFLAGS) -lm zad4.c -o zad4

clean:
	rm -f zad1v1.c zad1v1 zad1v2.c zad1v2 zad2.c zad2 zad3.c zad3 zad4.c zad4