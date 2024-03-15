#!/usr/bin/env python3

import re
from collections import defaultdict
from glob import glob
from pathlib import Path

DIR = Path(__file__).parent
IMPL_GLOB = str(DIR / 'impls' / '*.s')
HEADER = DIR / 'include' / 'libmemcpy.h'
CPU = DIR / 'src' / 'cpu.c'
CMAKE = DIR / 'CMakeLists.txt'
SIGNATURE = {'memmove': 'memcpy', 'mempcpy': 'memcpy'}
WINDOWS_BAD_XMM = frozenset(range(6, 16))

reglobl = re.compile(r'\.globl\s+(\w+)')
rexmm = re.compile(r'%[xyz]mm(\d+)')

def get_functions():
    functions = []
    xmm_usage = defaultdict(set)
    function_xmm = {}

    for file in glob(IMPL_GLOB):
        with open(file) as f:
            for line in f:
                match = reglobl.search(line)
                if match:
                    name = match.group(1)
                    if name.startswith('__mem'):
                        name = name.lstrip('_')
                        print('Found `%s` in "%s"' % (name, file))
                        functions.append(name)
                        function_xmm[name] = xmm_usage[file]

                match = rexmm.search(line)
                if match:
                    xmm_usage[file].add(int(match.group(1)))

    functions.sort()
    return functions, function_xmm


def generate_mingw_shim(func, xmm_usage):
    bad_xmm = sorted(WINDOWS_BAD_XMM & xmm_usage)
    spill_zone = len(bad_xmm) * 16

    parts = [f'''\
	.global	{func}
{func}:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
''']

    if spill_zone:
        # Stack is misaligned by 8 on entry, pushing rdi and rsi keeps this
        # misalignment. We add 8 bytes so that stack is realigned to 16 bytes.
        # Then we can use movdqa instead movdqu.
        parts.append(f'\tsubq\t${spill_zone + 8}, %rsp\n')
        for i, xmm in enumerate(bad_xmm):
            parts.append(f'\tmovdqa\t%xmm{xmm}, {i * 16}(%rsp)\n')

    parts.append(f'\tcall\t__{func}\n')

    if spill_zone:
        for i, xmm in enumerate(bad_xmm):
            parts.append(f'\tmovdqa\t{i * 16}(%rsp), %xmm{xmm}\n')
        parts.append(f'\taddq\t${spill_zone + 8}, %rsp\n')

    parts.append(f'''\
	popq	%rsi
	popq	%rdi
	ret
''')
    return ''.join(parts)


def group_functions(functions):
    func_group = defaultdict(list)
    file_group = defaultdict(set)

    for func in functions:
        group = func.partition('_')[0]
        func_group[group].append(func)
        file_group[SIGNATURE.get(group, group)].add(group)

    return func_group, file_group


def generate_name_lookup(func_group, file_group):
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


def update_cpu(func_group):
    with open(CPU) as f:
        preamble, postamble = get_ambles(f, '//', 'GENERATED CODE')

    prototypes = []
    with open(CPU, 'w') as f:
        for line in preamble:
            f.write(line)

        groups = sorted(func_group.keys())

        for group in groups:
            t = SIGNATURE.get(group, group)
            print(f'{t}_t *{group}_fast;', file=f)
        print(file=f)

        for group in groups:
            t = SIGNATURE.get(group, group)
            size = len(func_group[group])
            print(f'static {t}_t *{group}_available[{size + 1}];', file=f)
        print(file=f)

        for group in groups:
            print(f'static int {group}_available_count;', file=f)

        for group in groups:
            print(file=f)
            t = SIGNATURE.get(group, group)
            proto = f'{t}_t **libmemcpy_{group}_available(int *count)'
            prototypes.append(proto)
            print(f'{proto} {{', file=f)
            print( '    if (count)', file=f)
            print(f'        *count = {group}_available_count;', file=f)
            print(f'    return {group}_available;', file=f)
            print( '}', file=f)

        for line in postamble:
            f.write(line)

    return prototypes


def update_header(functions, func_group, name_prototypes, available_prototypes):
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
        for group in sorted(func_group.keys()):
            print(f'extern memcpy_t *{group}_fast;', file=f)

        print(file=f)
        for proto in name_prototypes:
            print(f'{proto};', file=f)

        print(file=f)
        for proto in available_prototypes:
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
    functions, xmm_usage = get_functions()

    with open(DIR / 'src' / 'mingw-shim.s', 'w') as f:
        for func in functions:
            print(generate_mingw_shim(func, xmm_usage[func]), file=f)

    func_group, file_group = group_functions(functions)
    name_files, name_prototypes = generate_name_lookup(func_group, file_group)
    available_prototypes = update_cpu(func_group)
    update_header(functions, func_group, name_prototypes, available_prototypes)
    update_cmake(name_files)


if __name__ == '__main__':
    main()
