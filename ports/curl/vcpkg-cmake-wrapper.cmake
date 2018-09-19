_find_package(${ARGS})

if(NOT "CONFIG" IN_LIST ARGS)
    find_package(ZLIB REQUIRED)
    find_package(Threads REQUIRED)
    if("@USE_OPENSSL@" STREQUAL "ON")
        find_package(OpenSSL REQUIRED)

        list(APPEND CURL_LIBRARIES OpenSSL::SSL OpenSSL::Crypto)
    endif()

    list(APPEND CURL_LIBRARIES ZLIB::ZLIB Threads::Threads)

    if(TARGET CURL::libcurl)
        if("@USE_OPENSSL@" STREQUAL "ON")
            set_target_properties(CURL::libcurl PROPERTIES INTERFACE_LINK_LIBRARIES "OpenSSL::SSL;OpenSSL::Crypto;ZLIB::ZLIB;Threads::Threads")
        else()
            set_target_properties(CURL::libcurl PROPERTIES INTERFACE_LINK_LIBRARIES "ZLIB::ZLIB;Threads::Threads")
        endif()
    endif()
endif()
