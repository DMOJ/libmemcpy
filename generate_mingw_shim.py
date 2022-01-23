#!/usr/bin/env python3

def generate_shim(func):
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


def main():
    import argparse

    parser = argparse.ArgumentParser(description='Generate shim for MinGW to call Linux functions.')
    parser.add_argument('func', nargs='+', help='memcpy function to preprocess')
    args = parser.parse_args()

    for func in args.func:
        print(generate_shim(func))


if __name__ == '__main__':
    main()
