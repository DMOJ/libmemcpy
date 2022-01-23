#include <stdio.h>
#include <string.h>

#include <windows.h>
#include <libmemcpy.h>

const int SZ = 2560 * 1440 * 4;
const int ITERS = 10000;

static void time(char *name, memcpy_t *t, char *src, char *dst, int sz) {
    printf("%s, %d iterations: ", name, ITERS);

    LARGE_INTEGER freq;
    QueryPerformanceFrequency(&freq);

    LARGE_INTEGER start;
    QueryPerformanceCounter(&start);

    for (int i = 0; i < ITERS; i++) {
      (*t)(dst, src, sz);
    }

    LARGE_INTEGER end;
    QueryPerformanceCounter(&end);

    double time = (end.QuadPart - start.QuadPart) / (double)freq.QuadPart *
			1000 * 1000 / ITERS;
    printf("%.4f us/copy\n", time);
}

int main(void) {
    char *src = malloc(SZ);
    char *dst = malloc(SZ);

    for (int i = 0; i < SZ; i++) {
        src[i] = i;
        dst[i] = 0;
    }

    time("libmemcpy", memcpy_fast, src, dst, SZ);
    time("system memcpy", &memcpy, src, dst, SZ);
    return 0;
}
