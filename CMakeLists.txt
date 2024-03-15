cmake_minimum_required(VERSION 3.0)
project(libmemcpy LANGUAGES C ASM-ATT)
set(CMAKE_C_STANDARD 99)

add_compile_options(
    "$<$<COMPILE_LANGUAGE:C>:-Wall>"
    "$<$<COMPILE_LANGUAGE:C>:-Werror>"
)

if (WIN32)
    set(LIBMEMCPY_PLATFORM_FILES src/mingw-shim.s)
else()
    set(LIBMEMCPY_PLATFORM_FILES "")
endif()

add_library(memcpy STATIC
    src/cpu.c
    "${LIBMEMCPY_PLATFORM_FILES}"
# BEGIN GENERATED FILES
    src/names-memcpy.c
    impls/memmove-avx-unaligned-erms-rtm.s
    impls/memmove-avx-unaligned-erms.s
    impls/memmove-avx512-no-vzeroupper.s
    impls/memmove-avx512-unaligned-erms.s
    impls/memmove-erms.s
    impls/memmove-evex-unaligned-erms.s
    impls/memmove-sse2-unaligned-erms.s
    impls/memmove-ssse3.s
# END GENERATED FILES
)

target_include_directories(memcpy
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
    PRIVATE
        src
)

add_subdirectory(examples EXCLUDE_FROM_ALL)
