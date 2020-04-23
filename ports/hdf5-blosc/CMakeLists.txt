cmake_minimum_required(VERSION 2.8.10)
project(blosc_hdf5)


# sources
set(SOURCES src/blosc_filter.c)
set(PLUGIN_SOURCES src/blosc_filter.c src/blosc_plugin.c )

# dependencies
find_package(hdf5 CONFIG REQUIRED)
find_package(blosc CONFIG REQUIRED)

add_library(blosc_filter STATIC ${SOURCES})
target_link_libraries(blosc_filter 
    PRIVATE
        blosc
        hdf5::hdf5-static
)

add_library(H5Zblosc ${PLUGIN_SOURCES})
target_link_libraries(H5Zblosc 
    PRIVATE
        blosc
        hdf5::hdf5-static
)
install(TARGETS H5Zblosc RUNTIME DESTINATION plugin ARCHIVE DESTINATION plugin LIBRARY DESTINATION plugin)

install(TARGETS blosc_filter EXPORT hdf5-blosc-config RUNTIME DESTINATION bin ARCHIVE DESTINATION lib LIBRARY DESTINATION lib)
install(EXPORT hdf5-blosc-config DESTINATION share/cmake/hdf5-blosc)
install(FILES src/blosc_filter.h DESTINATION include)
