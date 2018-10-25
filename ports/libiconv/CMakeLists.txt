cmake_minimum_required(VERSION 3.0.0)
project(libiconv C)

if(BUILD_SHARED_LIBS)
  set(LIBICONV_DYNAMIC "1 /*LIBICONV_DYNAMIC*/")
else()
  set(LIBICONV_DYNAMIC "0 /*LIBICONV_DYNAMIC*/")
endif()
set(HAVE_WCHAR_T "1 /*HAVE_WCHAR_T*/")
set(USE_MBSTATE_T "0 /*USE_MBSTATE_T*/")
set(BROKEN_WCHAR_H "0 /*BROKEN_WCHAR_H*/")
set(HAVE_VISIBILITY "0 /*HAVE_VISIBILITY*/")
set(ICONV_CONST const)

configure_file(config.h.in config.h)
file(READ "${CMAKE_CURRENT_BINARY_DIR}/config.h" _contents)
string(REPLACE "#undef HAVE_WORKING_O_NOFOLLOW" "#define HAVE_WORKING_O_NOFOLLOW 0" _contents "${_contents}")
string(REPLACE "#undef HAVE_MBRTOWC" "#define HAVE_MBRTOWC 1" _contents "${_contents}")
string(REPLACE "#undef HAVE_MBSINIT" "#define HAVE_MBSINIT 1" _contents "${_contents}")
string(REPLACE "#undef HAVE_WCRTOMB" "#define HAVE_WCRTOMB 1" _contents "${_contents}")
string(REPLACE "#undef ICONV_CONST" "#define ICONV_CONST const" _contents "${_contents}")
string(REPLACE "#undef ENABLE_RELOCATABLE" "#define ENABLE_RELOCATABLE 1" _contents "${_contents}")
string(REPLACE "#undef EILSEQ" "" _contents "${_contents}")
string(REPLACE "#undef WORDS_LITTLEENDIAN" "#define WORDS_LITTLEENDIAN 1" _contents "${_contents}")
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/config.h" "${_contents}")

configure_file(libcharset/include/localcharset.h.build.in localcharset.h @ONLY)
configure_file(include/iconv.h.build.in iconv.h @ONLY)

include_directories(${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR})

add_definitions(
  -DICONV_CONST=const
  -DLIBDIR=\"\"
  -D_CRT_SECURE_NO_WARNINGS
  -Drelocate=libiconv_relocate
  -Dset_relocation_prefix=libiconv_set_relocation_prefix
)

add_library(libcharset libcharset/lib/localcharset.c)
target_include_directories(libcharset PUBLIC $<INSTALL_INTERFACE:include>)

add_library(libiconv lib/iconv.c)
target_compile_options(libiconv PRIVATE -DBUILDING_LIBICONV)
target_link_libraries(libiconv PRIVATE libcharset)
target_include_directories(libiconv PUBLIC $<INSTALL_INTERFACE:include>)

install(TARGETS libcharset libiconv EXPORT unofficial-iconv-targets
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
)

if(NOT DISABLE_INSTALL_HEADERS)
  install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/iconv.h
    ${CMAKE_CURRENT_BINARY_DIR}/localcharset.h
    DESTINATION include
  )
endif()

install(
    EXPORT unofficial-iconv-targets
    FILE unofficial-iconv-config.cmake
    NAMESPACE unofficial::iconv::
    DESTINATION share/unofficial-iconv
)