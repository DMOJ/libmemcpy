#!/usr/bin/env python3
import os
import re
from pathlib import Path

reglobl = re.compile(r'\.globl\s+(\w+)')
reset = re.compile(r'\.set\s+(\w+)\s*,\s*(\w+)')


def process_file(orig_asm):
    in_chk = False
    lines = []

    with open(orig_asm, 'r') as f:
        for line in f:
            line = line.rstrip()
            if line.startswith(('#', '.symver')):
                continue
            elif '.section' in line:
                line = line.partition(',')[0]
            elif '.globl' in line:
                globl = line.partition(';')[0]
                in_chk = False
                match = reglobl.match(globl)
                if not match:
                    continue

                symbol = match.group(1).strip()
                if '_chk_' in symbol:
                    in_chk = True
                    continue

                lines.append(globl.strip())

                match = reset.search(line)
                if match:
                    lines.append(f'.set {match.group(1)}, {match.group(2)}')
                    lines.append('')
                else:
                    lines.append(f'{symbol}:')
                continue
            elif '.cfi_endproc' in line:
                continue

            if not in_chk and (line or (lines and lines[-1])):
                lines.append(line)

    if lines and lines[-1]:
        lines.append('')
    return '\n'.join(lines)


def main():
    import argparse

    parser = argparse.ArgumentParser(description='Simplify preprocessed glibc assembly files.')
    parser.add_argument('file', nargs='+', help='files to simplify')
    parser.add_argument('-o', '--output', type=Path, help='directory to output to')
    args = parser.parse_args()

    for file in args.file:
        result = process_file(file)
        if args.output:
            with open(args.output / os.path.basename(file), 'w') as f:
                f.write(result)
        else:
            print(result)


if __name__ == '__main__':
    main()
