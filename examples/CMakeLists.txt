set(LIBMEMCPY_EXAMPLES detect.c)

add_custom_target(examples)

foreach(file ${LIBMEMCPY_EXAMPLES})
    string(REGEX REPLACE "\\.[^.]*$" "" executable "${file}")
    add_executable("${executable}" "${file}")
    target_link_libraries("${executable}" memcpy)

    add_dependencies(examples "${executable}")
endforeach()
