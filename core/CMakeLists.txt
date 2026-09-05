# ABINSTEIN OS Core System Libraries
# Provides fundamental runtime support for the OS

cmake_minimum_required(VERSION 3.20)

file(GLOB CORE_SOURCES "src/*.c" "src/*.cpp")
file(GLOB CORE_HEADERS "include/*.h" "include/*.hpp")

# Create core library if sources exist
if(CORE_SOURCES)
    add_library(abinstein-core STATIC ${CORE_SOURCES})
    target_include_directories(abinstein-core PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
    )
    set_target_properties(abinstein-core PROPERTIES
        COMPILE_FLAGS "-fPIC -Wall -Wextra"
    )
    message(STATUS "Core library: ENABLED")
else()
    message(STATUS "Core library: PLACEHOLDER (no sources yet)")
    # Create a dummy target to satisfy dependencies
    add_library(abinstein-core INTERFACE)
endif()
