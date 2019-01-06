include(vcpkg_common_functions)

vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO actor-framework/actor-framework
    REF 0.16.3
    SHA512 f7e567264ea1686a431eacbf2a62f49c0f4467df073ec983ae622d9417c28124eb456eb40d6a70dbe062ad58333944924f04f7e3fee5a7b76917890d98bedce1
    HEAD_REF master
	PATCHES
		# openssl-version-override.patch
        0001-modern-cmake-for-caf-core.patch
        0002-modern-cmake-for-caf-io.patch
        0003-modern-cmake.patch
)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/caf-config.cmake.in DESTINATION ${SOURCE_PATH}/cmake)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DCMAKE_DEBUG_POSTFIX=d
        -DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=ON
        -DCAF_BUILD_STATIC=ON
        -DCAF_BUILD_STATIC_ONLY=ON
        -DCAF_NO_TOOLS=ON
        -DCAF_NO_EXAMPLES=ON
        -DCAF_NO_BENCHMARKS=ON
        -DCAF_NO_UNIT_TESTS=ON
        -DCAF_NO_caf_EXAMPLES=ON
        -DCAF_NO_QT_EXAMPLES=ON
        -DCAF_NO_OPENCL=ON
        -DCAF_NO_OPENSSL=ON
        -DCAF_NO_CURL_EXAMPLES=ON
        -DCAF_OPENSSL_VERSION_OVERRIDE=ON
        -DCAF_NO_PYTHON=ON 
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
