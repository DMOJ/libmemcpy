static memcpy_t *CONCAT(select_, FUNCTION)(void) {
    if (avx_fast_unaligned_load) {
        if (rtm) {
            if (erms)
                return CONCAT(FUNCTION,  _avx_unaligned_erms_rtm);
            return CONCAT(FUNCTION,  _avx_unaligned_rtm);
        }
        if (erms)
            return CONCAT(FUNCTION,  _avx_unaligned_erms);
        return CONCAT(FUNCTION,  _avx_unaligned);
    }

    if (!ssse3 || fast_unaligned_copy) {
        if (erms)
            return CONCAT(FUNCTION,  _sse2_unaligned_erms);
        return CONCAT(FUNCTION,  _sse2_unaligned);
    }

    if (fast_copy_backward)
        return CONCAT(FUNCTION,  _ssse3_back);

    return CONCAT(FUNCTION,  _ssse3);
}
