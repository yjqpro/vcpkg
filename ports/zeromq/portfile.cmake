include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO zeromq/libzmq
    REF 3154f3eab7fee360991e244c2d710f274e0ad4d9
    SHA512 c964add0fb93965bc26f6e981908dd2c8c321ed9857621a4f8a35145a4cd0f087298db0eddf659f4e91e0c4c1641edbba00a3771e520771bfdcbe8fb925cfb05
    HEAD_REF master
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static" BUILD_STATIC)
string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" BUILD_SHARED)

set(VCPKG_C_FLAGS "${VCPKG_C_FLAGS} \"-I${SOURCE_PATH}/builds/msvc\"")
set(VCPKG_CXX_FLAGS "${VCPKG_CXX_FLAGS} \"-I${SOURCE_PATH}/builds/msvc\"")

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DZMQ_BUILD_TESTS=OFF
        -DPOLLER=select
        -DBUILD_STATIC=${BUILD_STATIC}
        -DBUILD_SHARED=${BUILD_SHARED}
        -DWITH_PERF_TOOL=OFF
    OPTIONS_DEBUG
        "-DCMAKE_PDB_OUTPUT_DIRECTORY=${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg"
)

vcpkg_install_cmake()

vcpkg_copy_pdbs()

if(EXISTS ${CURRENT_PACKAGES_DIR}/CMake)
    vcpkg_fixup_cmake_targets(CONFIG_PATH CMake)
endif()
if(EXISTS ${CURRENT_PACKAGES_DIR}/share/cmake/ZeroMQ)
    vcpkg_fixup_cmake_targets(CONFIG_PATH share/cmake/ZeroMQ)
endif()

file(READ ${CURRENT_PACKAGES_DIR}/share/zeromq/ZeroMQConfig.cmake _contents)
if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    string(REPLACE "get_target_property(ZeroMQ_STATIC_LIBRARY libzmq-static LOCATION)" "add_library(libzmq-static INTERFACE IMPORTED)\nset_target_properties(libzmq-static PROPERTIES INTERFACE_LINK_LIBRARIES libzmq)" _contents "${_contents}")
    set(_contents "${_contents}\nset(ZeroMQ_STATIC_LIBRARY \${ZeroMQ_LIBRARY})\n")
else()
    string(REPLACE "get_target_property(ZeroMQ_INCLUDE_DIR libzmq INTERFACE_INCLUDE_DIRECTORIES)" "get_target_property(ZeroMQ_INCLUDE_DIR libzmq-static INTERFACE_INCLUDE_DIRECTORIES)" _contents "${_contents}")
    string(REPLACE "get_target_property(ZeroMQ_LIBRARY libzmq LOCATION)" "add_library(libzmq INTERFACE IMPORTED)\nset_target_properties(libzmq PROPERTIES INTERFACE_LINK_LIBRARIES libzmq-static)" _contents "${_contents}")
    set(_contents "${_contents}\nset(ZeroMQ_LIBRARY \${ZeroMQ_STATIC_LIBRARY})\n")

    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)
endif()
file(WRITE ${CURRENT_PACKAGES_DIR}/share/zeromq/ZeroMQConfig.cmake "${_contents}")

# Handle copyright
file(RENAME ${CURRENT_PACKAGES_DIR}/share/zmq/COPYING.LESSER.txt ${CURRENT_PACKAGES_DIR}/share/zeromq/copyright)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include ${CURRENT_PACKAGES_DIR}/debug/share ${CURRENT_PACKAGES_DIR}/share/zmq)
