#!/usr/bin/env python3

import re
from glob import glob
from pathlib import Path

DIR = Path(__file__).parent
IMPL_GLOB = str(DIR / 'impls' / '*.s')
HEADER = DIR / 'include' / 'libmemcpy.h'
CMAKE = DIR / 'CMakeLists.txt'
reglobl = re.compile(r'\.globl\s+(\w+)')


def get_functions():
    result = []

    for file in glob(IMPL_GLOB):
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


def get_ambles(f, comment, name):
    state = 0
    begin = f'{comment} BEGIN {name}'
    end = f'{comment} END {name}'
    preamble = []
    postamble = []

    for line in f:
        if state == 0:
            if begin in line:
                state = 1
            preamble.append(line)
        elif state == 1:
            if end in line:
                state = 2
                postamble.append(line)
        else:
            postamble.append(line)

    return preamble, postamble


def update_header(functions):
    with open(HEADER) as f:
        preamble, postamble = get_ambles(f, '//', 'GENERATED CODE')

    with open(HEADER, 'w') as f:
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


def update_cmake():
    with open(CMAKE) as f:
        preamble, postamble = get_ambles(f, '#', 'CMAKE ASM FILES')

    with open(CMAKE, 'w') as f:
        for line in preamble:
            f.write(line)

        for file in glob(IMPL_GLOB):
            print(f'    {Path(file).relative_to(DIR).as_posix()}', file=f)

        for line in postamble:
            f.write(line)


def main():
    functions = get_functions()

    with open(DIR / 'src' / 'mingw-shim.s', 'w') as f:
        for func in functions:
            print(generate_mingw_shim(func), file=f)

    update_header(functions)
    update_cmake()


if __name__ == '__main__':
    main()
