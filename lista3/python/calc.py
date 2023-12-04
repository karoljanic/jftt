from ply import lex, yacc

import calc_lexer
import calc_parser


def main():
    lexer = lex.lex(module=calc_lexer)
    parser = yacc.yacc(module=calc_parser)
    while True:
        user_input = ""
        while True:
            try:
                user_input += input()
            except EOFError:
                return
            user_input += '\n'
            if not user_input.endswith('\\\n'):
                break
        parser.parse(user_input, lexer=lexer)

        
main()