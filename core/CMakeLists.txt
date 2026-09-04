# ABINSTEIN OS Core System Libraries

file(GLOB CORE_SOURCES "*.c" "*.cpp")

if(CORE_SOURCES)
    add_library(abinstein-core STATIC ${CORE_SOURCES})
    target_include_directories(abinstein-core PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
    )
    message(STATUS "Core library: ENABLED")
else()
    message(STATUS "Core library: No sources found (placeholder)")
endif()
