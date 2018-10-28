include(vcpkg_common_functions)

set(GLFW_VERSION 3.2.1)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/glfw/glfw/releases/download/${GLFW_VERSION}/glfw-${GLFW_VERSION}.zip"
    FILENAME "glfw-${GLFW_VERSION}.zip"
    SHA512 73dd6d4a8d28a2b423f0fb25489659c1a845182b7ef09848d4f442cdc489528aea90f43ac84aeedb9d2301c4487f39782b647ee4959e67e83babb838372b980c
)
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${GLFW_VERSION}
    PATCHES
        unify-lib-names.patch
        move-cmake-min-req.patch
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DGLFW_BUILD_EXAMPLES=OFF
        -DGLFW_BUILD_TESTS=OFF
        -DGLFW_BUILD_DOCS=OFF
        -DPACKAGE_CMAKE_INSTALL_PREFIX=\${CMAKE_CURRENT_LIST_DIR}/../..
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/glfw3)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

configure_file(${SOURCE_PATH}/COPYING.txt ${CURRENT_PACKAGES_DIR}/share/glfw3/copyright COPYONLY)

vcpkg_copy_pdbs()
