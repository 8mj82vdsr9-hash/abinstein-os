# ABINSTEIN OS Mobile Shell
# Launcher, status bar, notifications, quick settings, lock screen

cmake_minimum_required(VERSION 3.20)

# Qt/QML required for shell UI
find_package(Qt6 COMPONENTS Core Quick DBus QUIET)

file(GLOB SHELL_SOURCES "src/*.c" "src/*.cpp")
file(GLOB SHELL_QML "qml/*.qml")

if(SHELL_SOURCES)
    add_library(abinstein-shell STATIC ${SHELL_SOURCES})
    target_include_directories(abinstein-shell PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
    )
    target_link_libraries(abinstein-shell PUBLIC 
        abinstein-core
        abinstein-services
        abinstein-network
    )
    if(Qt6_FOUND)
        target_link_libraries(abinstein-shell PUBLIC Qt6::Core Qt6::Quick Qt6::DBus)
    endif()
    set_target_properties(abinstein-shell PROPERTIES
        COMPILE_FLAGS "-fPIC -Wall -Wextra"
    )
    message(STATUS "Shell library: ENABLED")
else()
    message(STATUS "Shell library: PLACEHOLDER (no sources yet)")
    add_library(abinstein-shell INTERFACE)
    target_link_libraries(abinstein-shell INTERFACE 
        abinstein-core
        abinstein-services
        abinstein-network
    )
endif()
