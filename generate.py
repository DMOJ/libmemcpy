#!/usr/bin/env python3

import re
from collections import defaultdict
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


def generate_name_lookup(functions):
    signature = {'memmove': 'memcpy', 'mempcpy': 'memcpy'}
    func_group = defaultdict(list)
    file_group = defaultdict(set)

    for func in functions:
        group = func.partition('_')[0]
        func_group[group].append(func)
        file_group[signature.get(group, group)].add(group)

    files = []
    prototypes = []
    for file, groups in file_group.items():
        path = DIR / 'src' / f'names-{file}.c'

        with open(path, 'w') as f:
            print('// This is a generated file.', file=f)
            print(file=f)
            print('#include <libmemcpy.h>', file=f)
            for group in sorted(groups):
                print(file=f)
                proto = f'const char *libmemcpy_{group}_name({file}_t *func)'
                prototypes.append(proto)

                print(f'{proto} {{', file=f)
                for func in func_group[group]:
                    print(f'    if (func == {func})', file=f)
                    print(f'        return "{func}";', file=f)
                print('    return NULL;', file=f)
                print('}', file=f)

        files.append(path)

    files.sort()
    prototypes.sort()
    return files, prototypes


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


def update_header(functions, name_prototypes):
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
        for proto in name_prototypes:
            print(f'{proto};', file=f)

        print(file=f)
        for line in postamble:
            f.write(line)


def update_cmake(name_files):
    with open(CMAKE) as f:
        preamble, postamble = get_ambles(f, '#', 'GENERATED FILES')

    with open(CMAKE, 'w') as f:
        for line in preamble:
            f.write(line)

        files = name_files + sorted(glob(IMPL_GLOB))
        for file in files:
            print(f'    {Path(file).relative_to(DIR).as_posix()}', file=f)

        for line in postamble:
            f.write(line)


def main():
    functions = get_functions()

    with open(DIR / 'src' / 'mingw-shim.s', 'w') as f:
        for func in functions:
            print(generate_mingw_shim(func), file=f)

    name_files, name_prototypes = generate_name_lookup(functions)
    update_header(functions, name_prototypes)
    update_cmake(name_files)


if __name__ == '__main__':
    main()
