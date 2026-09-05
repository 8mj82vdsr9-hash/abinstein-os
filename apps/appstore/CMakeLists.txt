# ABINSTEIN App Store
# Package/Application Distribution System
# Similar to Google Play but independent

cmake_minimum_required(VERSION 3.20)
project(abinstein-appstore)

# Find required libraries
find_package(Qt6 REQUIRED COMPONENTS Core Quick DBus Network Sql)
find_package(OpenSSL REQUIRED)

set(APPSTORE_SOURCES
    src/main.cpp
    src/app_store_ui.cpp
    src/app_catalog.cpp
    src/app_installer.cpp
    src/app_manager.cpp
    src/download_manager.cpp
    src/signature_verifier.cpp
    src/rating_system.cpp
    src/update_checker.cpp
)

set(APPSTORE_HEADERS
    include/app_store_ui.h
    include/app_catalog.h
    include/app_installer.h
    include/app_manager.h
    include/download_manager.h
    include/signature_verifier.h
    include/rating_system.h
    include/update_checker.h
)

set(APPSTORE_QML
    qml/main.qml
    qml/AppStoreWindow.qml
    qml/AppGrid.qml
    qml/AppDetail.qml
    qml/CategoryBrowser.qml
    qml/SearchResults.qml
    qml/MyApps.qml
    qml/Downloads.qml
    qml/Reviews.qml
)

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp")
    # Abinstein App Store executable
    add_executable(abinstein-appstore
        ${APPSTORE_SOURCES}
        ${APPSTORE_HEADERS}
        ${APPSTORE_QML}
    )

    target_include_directories(abinstein-appstore PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/include
    )

    target_link_libraries(abinstein-appstore PRIVATE
        Qt6::Core
        Qt6::Quick
        Qt6::DBus
        Qt6::Network
        Qt6::Sql
        OpenSSL::Crypto
        OpenSSL::SSL
        abinstein-core
        abinstein-network
        abinstein-shell
    )

    target_compile_options(abinstein-appstore PRIVATE
        -Wall -Wextra -O2
    )

    set_target_properties(abinstein-appstore PROPERTIES
        AUTOMOC ON
        AUTORCC ON
    )

    message(STATUS "App Store: ABINSTEIN App Store - ENABLED")
else()
    message(STATUS "App Store: PLACEHOLDER (sources not yet implemented)")
    add_library(abinstein-appstore INTERFACE)
endif()
