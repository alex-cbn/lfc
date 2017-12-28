yacc -d tema2.y
lex tema2.l
g++ lex.yy.c y.tab.c -lfl -o tema2.out

