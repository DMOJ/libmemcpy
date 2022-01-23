static memcpy_t *CONCAT(select_, FUNCTION)(void) {
    if (avx_fast_unaligned_load) {
        if (rtm) {
            if (erms)
                return CONCAT(FUNCTION, _avx_unaligned_erms_rtm);
            return CONCAT(FUNCTION, _avx_unaligned_rtm);
        }
        if (erms)
            return CONCAT(FUNCTION, _avx_unaligned_erms);
        return CONCAT(FUNCTION, _avx_unaligned);
    }

    if (!ssse3 || fast_unaligned_copy) {
        if (erms)
            return CONCAT(FUNCTION, _sse2_unaligned_erms);
        return CONCAT(FUNCTION, _sse2_unaligned);
    }

    if (fast_copy_backward)
        return CONCAT(FUNCTION, _ssse3_back);

    return CONCAT(FUNCTION, _ssse3);
}

static int CONCAT(available_, FUNCTION)(memcpy_t **functions) {
    int count = 0;
    if (avx && ymm) {
        functions[count++] = CONCAT(FUNCTION, _avx_unaligned);
        functions[count++] = CONCAT(FUNCTION, _avx_unaligned_erms);

        if (rtm) {
            functions[count++] = CONCAT(FUNCTION, _avx_unaligned_rtm);
            functions[count++] = CONCAT(FUNCTION, _avx_unaligned_erms_rtm);
        }
    }

    if (ssse3 && xmm) {
        functions[count++] = CONCAT(FUNCTION, _ssse3_back);
        functions[count++] = CONCAT(FUNCTION, _ssse3);
    }

    functions[count++] = CONCAT(FUNCTION, _sse2_unaligned);
    functions[count++] = CONCAT(FUNCTION, _sse2_unaligned_erms);
    functions[count++] = CONCAT(FUNCTION, _erms);
    functions[count++] = NULL;

    return count;
}
