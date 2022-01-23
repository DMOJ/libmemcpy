#!/usr/bin/env python3
import os
import re
from pathlib import Path

reglobl = re.compile(r'\.globl\s+(\w+)')


def process_file(orig_asm):
    in_chk = False
    lines = []

    with open(orig_asm, 'r') as f:
        for line in f:
            line = line.rstrip()
            if line.startswith('#'):
                continue
            elif '.section' in line:
                line = line.partition(',')[0]
            elif '.globl' in line:
                line = line.partition(';')[0]
                in_chk = False
                match = reglobl.match(line)
                if match:
                    if '_chk_' in match.group(1):
                        in_chk = True
                        continue

                    lines.append(line)
                    lines.append(f'{match.group(1)}:')
                    continue
            elif '.cfi_endproc' in line:
                continue

            if not in_chk and (line or (lines and lines[-1])):
                lines.append(line)
    return '\n'.join(lines) + '\n'


def main():
    import argparse

    parser = argparse.ArgumentParser(description='Simply preprocessed glibc assembly files.')
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
