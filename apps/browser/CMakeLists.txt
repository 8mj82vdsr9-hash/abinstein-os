# ABINSTEIN Browser
# WPE WebKit-based mobile web browser
# NO Chromium - Pure WPE WebKit implementation

cmake_minimum_required(VERSION 3.20)
project(abinstein-browser)

# Find required libraries
find_package(Qt6 REQUIRED COMPONENTS Core Quick DBus Network)
find_package(PkgConfig REQUIRED)
pkg_check_modules(WPE REQUIRED wpe-1.0)
pkg_check_modules(WPEBACKEND REQUIRED wpebackend-fdo-1.0)

set(BROWSER_SOURCES
    src/main.cpp
    src/browser_window.cpp
    src/browser_engine.cpp
    src/url_bar.cpp
    src/tab_manager.cpp
    src/history_manager.cpp
    src/bookmark_manager.cpp
    src/download_manager.cpp
    src/privacy_mode.cpp
    src/network_state_observer.cpp
)

set(BROWSER_HEADERS
    include/browser_window.h
    include/browser_engine.h
    include/url_bar.h
    include/tab_manager.h
    include/history_manager.h
    include/bookmark_manager.h
    include/download_manager.h
    include/privacy_mode.h
    include/network_state_observer.h
)

set(BROWSER_QML
    qml/main.qml
    qml/BrowserWindow.qml
    qml/URLBar.qml
    qml/TabBar.qml
    qml/Menu.qml
    qml/Settings.qml
    qml/History.qml
    qml/Bookmarks.qml
)

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp")
    # WPE WebKit Browser executable
    add_executable(abinstein-browser
        ${BROWSER_SOURCES}
        ${BROWSER_HEADERS}
        ${BROWSER_QML}
    )

    target_include_directories(abinstein-browser PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/include
        ${WPE_INCLUDE_DIRS}
        ${WPEBACKEND_INCLUDE_DIRS}
    )

    target_link_libraries(abinstein-browser PRIVATE
        Qt6::Core
        Qt6::Quick
        Qt6::DBus
        Qt6::Network
        ${WPE_LIBRARIES}
        ${WPEBACKEND_LIBRARIES}
        abinstein-core
        abinstein-network
        abinstein-shell
    )

    target_compile_options(abinstein-browser PRIVATE
        ${WPE_CFLAGS_OTHER}
        -Wall -Wextra -O2
    )

    set_target_properties(abinstein-browser PROPERTIES
        AUTOMOC ON
        AUTORCC ON
    )

    message(STATUS "Browser: ABINSTEIN Browser - ENABLED (WPE WebKit)")
else()
    message(STATUS "Browser: PLACEHOLDER (sources not yet implemented)")
    add_library(abinstein-browser INTERFACE)
endif()
