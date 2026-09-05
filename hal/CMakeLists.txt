# ABINSTEIN OS Hardware Abstraction Layer
# Provides unified interface to hardware components
# Platform-specific implementations in hal/qemu and hal/a20e

cmake_minimum_required(VERSION 3.20)

# HAL Core Interface
file(GLOB HAL_COMMON_SOURCES "src/*.c" "src/*.cpp")
file(GLOB HAL_COMMON_HEADERS "include/*.h" "include/*.hpp")

# Platform-specific HAL implementations
set(HAL_QEMU_DIR "${CMAKE_CURRENT_SOURCE_DIR}/qemu")
set(HAL_A20E_DIR "${CMAKE_CURRENT_SOURCE_DIR}/a20e")

# Select HAL implementation based on platform
if(ABINSTEIN_PLATFORM STREQUAL "qemu")
    file(GLOB HAL_PLATFORM_SOURCES "${HAL_QEMU_DIR}/*.c" "${HAL_QEMU_DIR}/*.cpp")
    message(STATUS "HAL: QEMU platform selected")
elseif(ABINSTEIN_PLATFORM STREQUAL "a20e")
    file(GLOB HAL_PLATFORM_SOURCES "${HAL_A20E_DIR}/*.c" "${HAL_A20E_DIR}/*.cpp")
    message(STATUS "HAL: Samsung Galaxy A20e platform selected (EXPERIMENTAL)")
else()
    message(STATUS "HAL: Unknown platform '${ABINSTEIN_PLATFORM}' - using QEMU")
    file(GLOB HAL_PLATFORM_SOURCES "${HAL_QEMU_DIR}/*.c" "${HAL_QEMU_DIR}/*.cpp")
endif()

# Build HAL library
if(HAL_COMMON_SOURCES OR HAL_PLATFORM_SOURCES)
    add_library(abinstein-hal STATIC ${HAL_COMMON_SOURCES} ${HAL_PLATFORM_SOURCES})
    target_include_directories(abinstein-hal PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
        ${CMAKE_CURRENT_SOURCE_DIR}/qemu
        ${CMAKE_CURRENT_SOURCE_DIR}/a20e
    )
    target_link_libraries(abinstein-hal PUBLIC abinstein-core)
    set_target_properties(abinstein-hal PROPERTIES
        COMPILE_FLAGS "-fPIC -Wall -Wextra"
    )
    message(STATUS "HAL library: ENABLED")
else()
    message(STATUS "HAL library: PLACEHOLDER (no sources yet)")
    add_library(abinstein-hal INTERFACE)
    target_link_libraries(abinstein-hal INTERFACE abinstein-core)
endif()
