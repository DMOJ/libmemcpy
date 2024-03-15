#!/bin/bash
set -euo pipefail

dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
workdir="$(mktemp -d)"

cleanup() {
  rm -rf "${workdir}"
}

trap cleanup EXIT

cd "${workdir}"
mkdir impls

git clone --depth 1 https://sourceware.org/git/glibc.git
mkdir glibc/build
cd glibc/build

../configure --prefix="${workdir}"
make -j$(nproc)

for impl in ../sysdeps/x86_64/multiarch/memmove-*.S; do
  impl_basename="$(basename "${impl}")"
  case "${impl_basename}" in
    # Only ever included by other copy implementations with differing values of
    # VEC_SIZE etc., so can't be built standalone.
    memmove-vec-unaligned-erms.S)
      continue;;
  esac

  gcc "${impl}" \
    -c \
    -I../include \
    -I./string \
    -I../sysdeps/unix/sysv/linux/x86_64/64 \
    -I../sysdeps/unix/sysv/linux/x86_64 \
    -I../sysdeps/unix/sysv/linux/x86/include \
    -I../sysdeps/unix/sysv/linux/x86 \
    -I../sysdeps/x86/nptl \
    -I../sysdeps/unix/sysv/linux/wordsize-64 \
    -I../sysdeps/x86_64/nptl \
    -I../sysdeps/unix/sysv/linux/include \
    -I../sysdeps/unix/sysv/linux \
    -I../sysdeps/nptl \
    -I../sysdeps/pthread \
    -I../sysdeps/gnu \
    -I../sysdeps/unix/inet \
    -I../sysdeps/unix/sysv \
    -I../sysdeps/unix/x86_64 \
    -I../sysdeps/unix \
    -I../sysdeps/posix \
    -I../sysdeps/x86_64/64 \
    -I../sysdeps/x86_64/fpu/multiarch \
    -I../sysdeps/x86_64/fpu \
    -I../sysdeps/x86/fpu \
    -I../sysdeps/x86_64/multiarch \
    -I../sysdeps/x86_64 \
    -I../sysdeps/x86/include \
    -I../sysdeps/x86 \
    -I../sysdeps/ieee754/float128 \
    -I../sysdeps/ieee754/ldbl-96/include \
    -I../sysdeps/ieee754/ldbl-96 \
    -I../sysdeps/ieee754/dbl-64 \
    -I../sysdeps/ieee754/flt-32 \
    -I../sysdeps/wordsize-64 \
    -I../sysdeps/ieee754 \
    -I../sysdeps/generic \
    -I../libio \
    -I.. \
    -I. \
    -D_LIBC_REENTRANT \
    -include ./libc-modules.h \
    -DMODULE_NAME=libc \
    -include ../include/libc-symbols.h \
    -DPIC \
    -DSHARED \
    -DTOP_NAMESPACE=glibc \
    -DASSEMBLER \
    -g \
    -S \
    > "${workdir}/impls/${impl_basename%.S}.s"
done

rm -rf "${dir}/impls" 
mkdir "${dir}/impls"
"${dir}/simplify_asm.py" "${workdir}/impls/"* -o "${dir}/impls"
