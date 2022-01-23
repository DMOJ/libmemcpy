#!/usr/bin/env python3

import re
from glob import glob
from pathlib import Path

DIR = Path(__file__).parent
reglobl = re.compile(r'\.globl\s+(\w+)')


def get_functions():
    result = []

    for file in glob(str(DIR / 'impls' / '*.S')):
        with open(file) as f:
            for line in f:
                match = reglobl.search(line)
                if match:
                    name = match.group(1)
                    if name.startswith('__mem'):
                        result.append(name.lstrip('_'))
    result.sort()
    return result


def generate_mingw_shim(func):
    return f'''\
	.global	{func}
{func}:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__{func}
	popq	%rsi
	popq	%rdi
	ret
'''


def update_header(functions):
    state = 0
    preamble = []
    postamble = []

    with open(DIR / 'libmemcpy.h') as f:
        for line in f:
            if state == 0:
                if '// BEGIN GENERATED CODE' in line:
                    state = 1
                preamble.append(line)
            elif state == 1:
                if '// END GENERATED CODE' in line:
                    state = 2
                    postamble.append(line)
            else:
                postamble.append(line)

    with open(DIR / 'libmemcpy.h', 'w') as f:
        for line in preamble:
            f.write(line)

        print(file=f)
        print('#ifndef __MINGW32__', file=f)

        for func in functions:
            print(f'#define {func} __{func}', file=f)

        print('#endif', file=f)
        print(file=f)

        for func in functions:
            print(f'memcpy_t {func};', file=f)

        print(file=f)
        for line in postamble:
            f.write(line)


def main():
    functions = get_functions()

    with open(DIR / 'mingw-shim.s', 'w') as f:
        for func in functions:
            print(generate_mingw_shim(func), file=f)

    update_header(functions)


if __name__ == '__main__':
    main()
