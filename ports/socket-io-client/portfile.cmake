include(vcpkg_common_functions)

vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO socketio/socket.io-client-cpp
    REF 1.6.1
    SHA512 01c9c172e58a16b25af07c6bde593507792726aca28a9b202ed9531d51cd7e77c7e7d536102e50265d66de96e9708616075902dfdcfc72983758755381bad707
    HEAD_REF master
    PATCHES
          compatible-cmake-for-vcpkg.patch
          fixed-compile-error-on-release.patch
)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/socket-io-client-config.cmake.in DESTINATION ${SOURCE_PATH})
vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
    OPTIONS
        -DCMAKE_DEBUG_POSTFIX=d
    # OPTIONS -DUSE_THIS_IN_ALL_BUILDS=1 -DUSE_THIS_TOO=2
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets(CONFIG_PATH CMake)

vcpkg_copy_pdbs()

file(READ ${CURRENT_PACKAGES_DIR}/share/socket-io-client/socket-io-client-target.cmake _contents)
string(REPLACE
    "get_filename_component(_IMPORT_PREFIX \"\${_IMPORT_PREFIX}\" PATH)"
    "get_filename_component(_IMPORT_PREFIX \"\${_IMPORT_PREFIX}\" PATH)\nget_filename_component(_IMPORT_PREFIX \"\${_IMPORT_PREFIX}\" PATH)"
    _contents
    "${_contents}"
)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/socket-io-client/socket-io-client-target.cmake "${_contents}")

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include ${CURRENT_PACKAGES_DIR}/debug/share)

# Handle copyright
configure_file(${SOURCE_PATH}/LICENSE ${CURRENT_PACKAGES_DIR}/share/socket-io-client/copyright COPYONLY)
