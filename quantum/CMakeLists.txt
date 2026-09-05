# ABINSTEIN OS Quantum Core
# Quantum simulator (NOT real hardware quantum processor)
# Provides quantum state simulation for research and development

cmake_minimum_required(VERSION 3.20)

file(GLOB QUANTUM_SOURCES "src/*.c" "src/*.cpp")

if(QUANTUM_SOURCES)
    add_library(abinstein-quantum STATIC ${QUANTUM_SOURCES})
    target_include_directories(abinstein-quantum PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
    )
    target_link_libraries(abinstein-quantum PUBLIC abinstein-core)
    set_target_properties(abinstein-quantum PROPERTIES
        COMPILE_FLAGS "-fPIC -Wall -Wextra -O2"
    )
    message(STATUS "Quantum library: ENABLED (SIMULATOR)")
else()
    message(STATUS "Quantum library: PLACEHOLDER (no sources yet)")
    add_library(abinstein-quantum INTERFACE)
    target_link_libraries(abinstein-quantum INTERFACE abinstein-core)
endif()
