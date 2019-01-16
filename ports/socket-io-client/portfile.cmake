include(vcpkg_common_functions)

vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO socketio/socket.io-client-cpp
    REF 6063cb1d612f6ca0232d4134a018053fb8faea20
    SHA512 8047a8683f6c8bba5682fd165eca2da302c65a7695787e6980658cd363bb9fb9ce12ac724b0f0502f74f16306d034f6b065165141078ad2e9ab6488acfd1fab0
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
