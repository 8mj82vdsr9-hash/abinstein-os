# ABINSTEIN OS Networking Subsystem
# Network state management, Wi-Fi, Bluetooth, connectivity detection

cmake_minimum_required(VERSION 3.20)

file(GLOB NETWORK_SOURCES "src/*.c" "src/*.cpp")

if(NETWORK_SOURCES)
    add_library(abinstein-network STATIC ${NETWORK_SOURCES})
    target_include_directories(abinstein-network PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
    )
    target_link_libraries(abinstein-network PUBLIC 
        abinstein-core
        abinstein-hal
        abinstein-services
    )
    set_target_properties(abinstein-network PROPERTIES
        COMPILE_FLAGS "-fPIC -Wall -Wextra"
    )
    message(STATUS "Network library: ENABLED")
else()
    message(STATUS "Network library: PLACEHOLDER (no sources yet)")
    add_library(abinstein-network INTERFACE)
    target_link_libraries(abinstein-network INTERFACE 
        abinstein-core
        abinstein-hal
        abinstein-services
    )
endif()
