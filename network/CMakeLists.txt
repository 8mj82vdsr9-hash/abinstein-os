# ABINSTEIN OS Networking Subsystem

file(GLOB NETWORK_SOURCES "*.c" "*.cpp")

if(NETWORK_SOURCES)
    add_library(abinstein-network STATIC ${NETWORK_SOURCES})
    target_include_directories(abinstein-network PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
    )
    message(STATUS "Network library: ENABLED")
else()
    message(STATUS "Network library: No sources found (placeholder)")
endif()
