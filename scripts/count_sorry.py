#!/usr/bin/env python3
"""Count occurrences of the token `sorry` in a Lean file, ignoring comments.

Used by verify.sh as an independent check on the compiler's warnings: a
solutions file must contain no `sorry` in code, and prose that merely
*discusses* `sorry` must not trip the check.
"""
import re, sys

def strip_comments(src: str) -> str:
    out, i, n, depth = [], 0, len(src), 0
    while i < n:
        if depth == 0 and src.startswith('--', i):
            j = src.find('\n', i)
            i = n if j == -1 else j
        elif src.startswith('/-', i):
            depth += 1
            i += 2
        elif depth > 0 and src.startswith('-/', i):
            depth -= 1
            i += 2
        else:
            if depth == 0:
                out.append(src[i])
            i += 1
    return ''.join(out)

if __name__ == '__main__':
    total = 0
    for path in sys.argv[1:]:
        with open(path, encoding='utf-8') as fh:
            code = strip_comments(fh.read())
        total = len(re.findall(r'\bsorry\b', code))
    print(total)
