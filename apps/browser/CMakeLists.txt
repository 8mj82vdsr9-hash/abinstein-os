# ABINSTEIN Browser
# Real Qt-based mobile browser using Qt WebEngine
# Lightweight and native to ABINSTEIN OS architecture

cmake_minimum_required(VERSION 3.20)
project(abinstein-browser)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Quick QuickControls2 WebEngineQuick Network)
find_package(PkgConfig REQUIRED)

set(BROWSER_SOURCES
    src/main.cpp
    src/browser_engine.cpp
    src/browser_window.cpp
)

set(BROWSER_HEADERS
    include/browser_engine.h
    include/browser_window.h
)

set(BROWSER_QML
    qml/main.qml
)

add_executable(abinstein-browser
    ${BROWSER_SOURCES}
    ${BROWSER_HEADERS}
    ${BROWSER_QML}
)

target_include_directories(abinstein-browser PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(abinstein-browser PRIVATE
    Qt6::Core
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::WebEngineQuick
    Qt6::Network
    abinstein-core
    abinstein-network
    abinstein-shell
)

target_compile_options(abinstein-browser PRIVATE
    -Wall -Wextra -O2
)

set_target_properties(abinstein-browser PROPERTIES
    AUTOMOC ON
    AUTORCC ON
)

message(STATUS "Browser: ABINSTEIN Browser - ENABLED (Qt WebEngine)")
