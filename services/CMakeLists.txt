# ABINSTEIN OS System Services
# Core services: D-Bus, power management, device management, etc.

cmake_minimum_required(VERSION 3.20)

file(GLOB SERVICES_SOURCES "src/*.c" "src/*.cpp")

if(SERVICES_SOURCES)
    add_library(abinstein-services STATIC ${SERVICES_SOURCES})
    target_include_directories(abinstein-services PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
    )
    target_link_libraries(abinstein-services PUBLIC 
        abinstein-core
        abinstein-hal
    )
    set_target_properties(abinstein-services PROPERTIES
        COMPILE_FLAGS "-fPIC -Wall -Wextra"
    )
    message(STATUS "Services library: ENABLED")
else()
    message(STATUS "Services library: PLACEHOLDER (no sources yet)")
    add_library(abinstein-services INTERFACE)
    target_link_libraries(abinstein-services INTERFACE 
        abinstein-core
        abinstein-hal
    )
endif()
