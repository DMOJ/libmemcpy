#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <libmemcpy.h>

#ifdef WIN32
#include <windows.h>
#else
#include <time.h>

inline static void timespec_duration(struct timespec *start,
    struct timespec *end, struct timespec *duration) {
    duration->tv_sec = end->tv_sec - start->tv_sec;
    if (end->tv_nsec < start->tv_nsec) {
        duration->tv_nsec = end->tv_nsec + 1000000000L - start->tv_nsec;
        duration->tv_sec--; /* Borrow a second-> */
    } else {
        duration->tv_nsec = end->tv_nsec - start->tv_nsec;
    }
}
#endif

const int SZ = 2560 * 1440 * 4;
const int ITERS = 10000;

static void bench(const char *name, memcpy_t *t, char *src, char *dst, int sz) {
    printf("%s, %d iterations: ", name, ITERS);

#ifdef WIN32
    LARGE_INTEGER freq;
    QueryPerformanceFrequency(&freq);

    LARGE_INTEGER start;
    QueryPerformanceCounter(&start);
#else
    struct timespec start;
    clock_gettime(CLOCK_MONOTONIC, &start);
#endif

    for (int i = 0; i < ITERS; i++) {
        (*t)(dst, src, sz);
    }

#ifdef WIN32
    LARGE_INTEGER end;
    QueryPerformanceCounter(&end);

    double time = (end.QuadPart - start.QuadPart) / (double)freq.QuadPart *
        1000 * 1000 / ITERS;
#else
    struct timespec end;
    clock_gettime(CLOCK_MONOTONIC, &end);

    struct timespec duration;
    timespec_duration(&start, &end, &duration);
    double time = duration.tv_sec * 1000.0 * 1000.0 + duration.tv_nsec / 1000.0;
    time /= ITERS;
#endif
    printf("%.4f us/copy\n", time);
}

int main(void) {
    char *src = malloc(SZ);
    char *dst = malloc(SZ);

    for (int i = 0; i < SZ; i++) {
        src[i] = i;
        dst[i] = 0;
    }

    bench("system memcpy", &memcpy, src, dst, SZ);
    bench("libmemcpy_fast", memcpy_fast, src, dst, SZ);

    for (memcpy_t **func = libmemcpy_memcpy_available(NULL); *func; ++func) {
        bench(libmemcpy_memcpy_name(*func), *func, src, dst, SZ);
    }
    return 0;
}
