#ifndef FUNC_NAME
#define FUNC_NAME CONCAT(select_, FUNCTION)
#endif

static RESULT_TYPE FUNC_NAME(void) {
    if (avx_fast_unaligned_load) {
        if (rtm) {
            if (erms)
                return RESULT(CONCAT(FUNCTION,  _avx_unaligned_erms_rtm));
            return RESULT(CONCAT(FUNCTION,  _avx_unaligned_rtm));
        }
        if (erms)
            return RESULT(CONCAT(FUNCTION,  _avx_unaligned_erms));
        return RESULT(CONCAT(FUNCTION,  _avx_unaligned));
    }

    if (!ssse3 || fast_unaligned_copy) {
        if (erms)
            return RESULT(CONCAT(FUNCTION,  _sse2_unaligned_erms));
        return RESULT(CONCAT(FUNCTION,  _sse2_unaligned));
    }

    if (fast_copy_backward)
        return RESULT(CONCAT(FUNCTION,  _ssse3_back));

    return RESULT(CONCAT(FUNCTION,  _ssse3));
}

#undef FUNC_NAME
