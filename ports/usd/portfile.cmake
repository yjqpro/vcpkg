include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO PixarAnimationStudios/USD
    REF v0.8.4
    SHA512 913049d441f43cacf3fc9d80e0559470e5aea5bd2f59aedb1e739206bae66eb025c7c891434e3d484b350fed686b8ea8f55863c895f587f22d7473128354259a
    HEAD_REF master
    PATCHES
        0001-Install-PDB-files.patch
        patch1.patch
)

vcpkg_find_acquire_program(PYTHON2)
get_filename_component(PYTHON2_DIR "${PYTHON2}" DIRECTORY)
vcpkg_add_to_path("${PYTHON2_DIR}")

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DPXR_BUILD_ALEMBIC_PLUGIN:BOOL=OFF
        -DPXR_BUILD_EMBREE_PLUGIN:BOOL=OFF
        -DPXR_BUILD_IMAGING:BOOL=OFF
        -DPXR_BUILD_MAYA_PLUGIN:BOOL=OFF
        -DPXR_BUILD_MONOLITHIC:BOOL=OFF
        -DPXR_BUILD_TESTS:BOOL=OFF
        -DPXR_BUILD_USD_IMAGING:BOOL=OFF
        -DPXR_ENABLE_PYTHON_SUPPORT:BOOL=OFF
)

vcpkg_install_cmake()

file(READ ${CURRENT_PACKAGES_DIR}/pxrConfig.cmake _contents)
string(REPLACE "\${PXR_CMAKE_DIR}/cmake" "\${PXR_CMAKE_DIR}/share/usd" _contents "${_contents}")
string(REPLACE "set(PXR_CMAKE_DIR " "set(PXR_CMAKE_DIR \"${CMAKE_CURRENT_LIST_DIR}/../..\")\n# set(PXR_CMAKE_DIR " _contents "${_contents}")
file(WRITE ${CURRENT_PACKAGES_DIR}/cmake/pxrConfig.cmake "${_contents}")
file(REMOVE ${CURRENT_PACKAGES_DIR}/pxrConfig.cmake ${CURRENT_PACKAGES_DIR}/debug/pxrConfig.cmake)
vcpkg_fixup_cmake_targets(CONFIG_PATH cmake TARGET_PATH share/pxr)

vcpkg_copy_pdbs()

# Remove duplicates in debug folder
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

# Handle copyright
file(
    COPY ${SOURCE_PATH}/LICENSE.txt
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/usd
)
file(
    RENAME
        ${CURRENT_PACKAGES_DIR}/share/usd/LICENSE.txt
        ${CURRENT_PACKAGES_DIR}/share/usd/copyright
)
