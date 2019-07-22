include(vcpkg_common_functions)
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO SOCI/soci
    REF ac3aa20d238d1ce1c7bcfffa4c4ce557c5c12351
    SHA512 b334f03945a84154a1d0b5c3b1eee4e288225a0a76446316bf3878cc4afc630bd1b31eab23f78ce5e3b2dbf8490c36d6fdcf48f25f9806004111852d7efbdf15
    HEAD_REF master
	PATCHES
        mysql-include-header.patch
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" SOCI_DYNAMIC)
string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static" SOCI_STATIC)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DSOCI_TESTS=OFF
        -DSOCI_CXX_C11=ON
        -DSOCI_LIBDIR=lib # This is to always have output in the lib folder and not lib64 for 64-bit builds
        -DSOCI_STATIC=${SOCI_STATIC}
        -DSOCI_SHARED=${SOCI_DYNAMIC}
)



vcpkg_install_cmake()
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/share/soci)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(RENAME ${CURRENT_PACKAGES_DIR}/cmake/SOCI.cmake ${CURRENT_PACKAGES_DIR}/share/soci/SOCIConfig.cmake)
file(RENAME ${CURRENT_PACKAGES_DIR}/cmake/SOCI-release.cmake ${CURRENT_PACKAGES_DIR}/share/soci/SOCI-release.cmake)
file(RENAME ${CURRENT_PACKAGES_DIR}/debug/cmake/SOCI-debug.cmake ${CURRENT_PACKAGES_DIR}/share/soci/SOCI-debug.cmake)
file(READ ${CURRENT_PACKAGES_DIR}/share/soci/SOCIConfig.cmake CONFIG_FILE)
set(pattern "get_filename_component(_IMPORT_PREFIX \"\${_IMPORT_PREFIX}\" PATH)\n")
string(REPLACE "${pattern}" "${pattern}${pattern}" CONFIG_FILE ${CONFIG_FILE})
file(WRITE ${CURRENT_PACKAGES_DIR}/share/soci/SOCIConfig.cmake ${CONFIG_FILE})
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/cmake)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/cmake)
# Handle copyright
file(COPY ${SOURCE_PATH}/LICENSE_1_0.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/soci)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/soci/LICENSE_1_0.txt ${CURRENT_PACKAGES_DIR}/share/soci/copyright)

vcpkg_copy_pdbs()
