include(vcpkg_common_functions)

vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO actor-framework/actor-framework
    REF 0.17.3
    SHA512 55b05d0f890bf3e690db3bf17f5716fd764f0b210acc104d88c4807e2923ef3592a56c0625765070a15e5723951893897b813288aaf00bc8d7b39175d4e0305a
    HEAD_REF master
	PATCHES
		modern-cmake.patch
)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/caf-config.cmake.in DESTINATION ${SOURCE_PATH}/cmake)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=ON
        -DCAF_BUILD_STATIC=ON
        -DCAF_BUILD_STATIC_ONLY=ON
        -DCAF_NO_TOOLS=ON
        -DCAF_NO_EXAMPLES=ON
        -DCAF_NO_BENCHMARKS=ON
        -DCAF_NO_UNIT_TESTS=ON
        -DCAF_NO_PROTOBUF_EXAMPLES=ON
        -DCAF_NO_QT_EXAMPLES=ON
        -DCAF_NO_OPENCL=ON
	-DCAF_NO_OPENSSL=ON
        -DCAF_NO_CURL_EXAMPLES=ON
        -DCAF_OPENSSL_VERSION_OVERRIDE=ON
)

vcpkg_install_cmake()

if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "debug")
    file(READ ${CURRENT_PACKAGES_DIR}/debug/share/caf/caf-core-targets-debug.cmake CORE_DEBUG_MODULE)
    string(REPLACE "\${_IMPORT_PREFIX}" "\${_IMPORT_PREFIX}/debug" CORE_DEBUG_MODULE "${CORE_DEBUG_MODULE}")
    string(REPLACE "\${_IMPORT_PREFIX}/debug/bin/protoc${EXECUTABLE_SUFFIX}" "\${_IMPORT_PREFIX}/tools/caf/protoc${EXECUTABLE_SUFFIX}" CORE_DEBUG_MODULE "${CORE_DEBUG_MODULE}")
    file(WRITE ${CURRENT_PACKAGES_DIR}/share/caf/caf-core-targets-debug.cmake "${CORE_DEBUG_MODULE}")

    file(READ ${CURRENT_PACKAGES_DIR}/debug/share/caf/caf-io-targets-debug.cmake IO_DEBUG_MODULE)
    string(REPLACE "\${_IMPORT_PREFIX}" "\${_IMPORT_PREFIX}/debug" IO_DEBUG_MODULE "${IO_DEBUG_MODULE}")
    string(REPLACE "\${_IMPORT_PREFIX}/debug/bin/protoc${EXECUTABLE_SUFFIX}" "\${_IMPORT_PREFIX}/tools/caf/protoc${EXECUTABLE_SUFFIX}" IO_DEBUG_MODULE "${IO_DEBUG_MODULE}")
    file(WRITE ${CURRENT_PACKAGES_DIR}/share/caf/caf-io-targets-debug.cmake "${IO_DEBUG_MODULE}")
endif()


file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include ${CURRENT_PACKAGES_DIR}/debug/share)

file(INSTALL
    ${SOURCE_PATH}/LICENSE
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/caf RENAME copyright)

vcpkg_copy_pdbs()
