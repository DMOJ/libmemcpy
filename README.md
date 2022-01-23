# `libmemcpy` [![Linux Build Status](https://img.shields.io/github/workflow/status/DMOJ/libmemcpy/update-memcpy?logo=github)](https://github.com/DMOJ/libmemcpy/actions?query=workflow%3Aupdate-memcpy)

`glibc` features very fast `memcpy` routines optimized for various architectures, and runtime logic to pick an optimal one for a given processor.

Unfortunately, if you are targetting systems without `glibc` &mdash; like Windows &mdash; you do not have this benefit.

That's where `libmemcpy` comes in: it contains `glibc`'s copy routines, routinely extracted and patched to build under MinGW.
