# ABINSTEIN OS Mobile Shell

file(GLOB SHELL_SOURCES "*.c" "*.cpp" "*.qml")

if(SHELL_SOURCES)
    add_library(abinstein-shell STATIC ${SHELL_SOURCES})
    target_include_directories(abinstein-shell PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
    )
    message(STATUS "Shell library: ENABLED")
else()
    message(STATUS "Shell library: No sources found (placeholder)")
endif()
