import sys
from typing import List

def compute_prefix_function(pattern: str)-> List[int]:
    prefix_function = [0] * len(pattern)
    matched_len = 0
    for index in range(1, len(pattern)):
        while matched_len > 0 and pattern[matched_len] != pattern[index]:
            matched_len = prefix_function[matched_len - 1]

        if pattern[matched_len] == pattern[index]:
            matched_len += 1

        prefix_function[index] = matched_len

    return prefix_function


def match(prefix_function: List[int], text: str, pattern: str) -> List[int]:
    match_indexes = []
    pattern_len = len(pattern)

    prefix_index = 0
    for index in range(len(text)):
        while prefix_index > 0 and pattern[prefix_index] != text[index]:
            prefix_index = prefix_function[prefix_index - 1]

        if pattern[prefix_index] == text[index]:
            prefix_index += 1

        if prefix_index == pattern_len:
            match_indexes.append(index - pattern_len + 1)
            prefix_index = prefix_function[prefix_index - 1]

    return match_indexes


if len(sys.argv) != 3:
    print("Bad input!. Correct input is: KMP <pattern> <filename>")
    exit(-1)

pattern = sys.argv[1]
filename = sys.argv[2]

prefix_function = compute_prefix_function(pattern)

with open(filename, "r") as file:
    text = file.read()

matched = match(prefix_function, text, pattern)
print(matched)