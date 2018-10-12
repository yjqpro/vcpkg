include(vcpkg_common_functions)

set(FFTW_VERSION 3.3.7)

vcpkg_download_distfile(ARCHIVE
    URLS "http://www.fftw.org/fftw-${FFTW_VERSION}.tar.gz"
    FILENAME "fftw-${FFTW_VERSION}.tar.gz"
    SHA512 a5db54293a6d711408bed5894766437eee920be015ad27023c7a91d4581e2ff5b96e3db0201e6eaccf7b064c4d32db1a2a8fab3e6813e524b4743ddd6216ba77
)

vcpkg_extract_source_archive_ex(
	OUT_SOURCE_PATH SOURCE_PATH
	ARCHIVE ${ARCHIVE}
	REF ${FFTW_VERSION}
	PATCHES omp_test.patch
)

if ("openmp" IN_LIST FEATURES)
    set(ENABLE_OPENMP ON)
else()
    set(ENABLE_OPENMP OFF)
endif()

foreach(PRECISION ENABLE_DEFAULT_PRECISION ENABLE_FLOAT ENABLE_LONG_DOUBLE)
	vcpkg_configure_cmake(
		SOURCE_PATH ${SOURCE_PATH}
		PREFER_NINJA
		OPTIONS 
			-D${PRECISION}=ON
			-DENABLE_OPENMP=${ENABLE_OPENMP}
	)

	vcpkg_install_cmake()
	vcpkg_copy_pdbs()

	file(COPY ${SOURCE_PATH}/api/fftw3.h DESTINATION ${CURRENT_PACKAGES_DIR}/include)

	vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake)

	if (VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
		vcpkg_apply_patches(
			SOURCE_PATH ${CURRENT_PACKAGES_DIR}/include
			PATCHES fix-dynamic.patch
		)
	endif()

	# Cleanup
	file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
	file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
endforeach()

# Handle copyright
file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/fftw3)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/fftw3/COPYING ${CURRENT_PACKAGES_DIR}/share/fftw3/copyright)
