import sys
from typing import List, Dict

def is_sufix(string: str, sufix: str) -> bool:
    if len(string) < len(sufix):
        return False

    for index in range(1, len(sufix) + 1):
        if string[-index] != sufix[-index]:
            return False

    return True

def build_automata(pattern: str) -> List[Dict]:
    patter_len = len(pattern)
    alphabet = set(pattern)
    automata = [dict() for _ in range(patter_len + 1)]

    for state in range(patter_len + 1):
        for letter in alphabet:
            next_state = min(patter_len, state + 1)
            while next_state > 0 and not is_sufix(pattern[:state] + letter, pattern[:next_state]):
                next_state -= 1

            automata[state][letter] = next_state


    return automata

def match(automata: List[Dict], text: str, pattern: str) -> List[int]:
    match_indexes = []
    pattern_len = len(pattern)

    state = 0
    for index in range(len(text)):
        if text[index] not in automata[state].keys():
            state = 0
        else:
            state = automata[state][text[index]]

        if state == pattern_len:
            match_indexes.append(index - state + 1)

    return match_indexes


if len(sys.argv) != 3:
    print("Bad input!. Correct input is: FA <pattern> <filename>")
    exit(-1)

pattern = sys.argv[1]
filename = sys.argv[2]

automata = build_automata(pattern)

with open(filename, "r") as file:
    text = file.read()

matched = match(automata, text, pattern)
print(matched)
