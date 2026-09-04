# ABINSTEIN OS Quantum Simulator Core

file(GLOB QUANTUM_SOURCES "*.c" "*.cpp")

if(QUANTUM_SOURCES)
    add_library(abinstein-quantum STATIC ${QUANTUM_SOURCES})
    target_include_directories(abinstein-quantum PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
    )
    message(STATUS "Quantum library: ENABLED")
else()
    message(STATUS "Quantum library: No sources found (placeholder)")
endif()
