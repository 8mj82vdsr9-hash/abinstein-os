# ABINSTEIN OS Hardware Abstraction Layer

file(GLOB HAL_SOURCES "*.c" "*.cpp")

if(HAL_SOURCES)
    add_library(abinstein-hal STATIC ${HAL_SOURCES})
    target_include_directories(abinstein-hal PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
    )
    message(STATUS "HAL library: ENABLED")
else()
    message(STATUS "HAL library: No sources found (placeholder)")
endif()
