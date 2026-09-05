# ABINSTEIN OS Native Applications
# Collection of essential mobile apps

cmake_minimum_required(VERSION 3.20)

# Enable Qt tools
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# Find Qt6
find_package(Qt6 COMPONENTS Core Quick DBus Network QUIET)

# Applications
add_subdirectory(browser)
add_subdirectory(appstore)

if(Qt6_FOUND)
    message(STATUS "Applications: Qt6 framework available")
else()
    message(WARNING "Applications: Qt6 not found - apps will be placeholder only")
endif()

message(STATUS "Apps: Abinstein Browser (WPE WebKit) + App Store")
