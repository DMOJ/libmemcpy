static memcpy_t *CONCAT(select_, FUNCTION)(void) {
    if (erms || fsrm)
        return CONCAT(FUNCTION, _erms);

    if (avx512f && !prefer_no_avx512) {
        if (avx512vl) {
            if (erms)
                return CONCAT(FUNCTION, _avx512_unaligned_erms);
            return CONCAT(FUNCTION, _avx512_unaligned);
        }
        return CONCAT(FUNCTION, _avx512_no_vzeroupper);
    }

    if (avx_fast_unaligned_load) {
        if (avx512vl) {
            if (erms)
                return CONCAT(FUNCTION, _evex_unaligned_erms);
            return CONCAT(FUNCTION, _evex_unaligned);
        }

        if (rtm) {
            if (erms)
                return CONCAT(FUNCTION, _avx_unaligned_erms_rtm);
            return CONCAT(FUNCTION, _avx_unaligned_rtm);
        }

        if (!prefer_no_vzeroupper) {
            if (erms)
                return CONCAT(FUNCTION, _avx_unaligned_erms);
            return CONCAT(FUNCTION, _avx_unaligned);
        }
    }

    if (ssse3 && !fast_unaligned_copy) {
        return CONCAT(FUNCTION, _ssse3);
    }

    if (erms)
        return CONCAT(FUNCTION, _sse2_unaligned_erms);

    return CONCAT(FUNCTION, _sse2_unaligned);
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
        functions[count++] = CONCAT(FUNCTION, _ssse3);
    }

    if (avx512vl) {
        functions[count++] = CONCAT(FUNCTION, _evex_unaligned);
        functions[count++] = CONCAT(FUNCTION, _evex_unaligned_erms);
        functions[count++] = CONCAT(FUNCTION, _avx512_unaligned);
        functions[count++] = CONCAT(FUNCTION, _avx512_unaligned_erms);
    }

    if (avx512f)
        functions[count++] = CONCAT(FUNCTION, _avx512_no_vzeroupper);

    functions[count++] = CONCAT(FUNCTION, _sse2_unaligned);
    functions[count++] = CONCAT(FUNCTION, _sse2_unaligned_erms);
    functions[count++] = CONCAT(FUNCTION, _erms);
    functions[count++] = NULL;

    return count;
}
