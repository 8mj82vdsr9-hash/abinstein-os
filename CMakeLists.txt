cmake_minimum_required(VERSION 3.20)
project(ABINSTEIN_OS VERSION 0.1.0 LANGUAGES C CXX ASM)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Default build type
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

# Platform detection
set(ABINSTEIN_ARCH "arm64" CACHE STRING "Target architecture")
set(ABINSTEIN_PLATFORM "qemu" CACHE STRING "Target platform (qemu|a20e)")

message(STATUS "ABINSTEIN OS Build Configuration")
message(STATUS "Architecture: ${ABINSTEIN_ARCH}")
message(STATUS "Platform: ${ABINSTEIN_PLATFORM}")
message(STATUS "Build Type: ${CMAKE_BUILD_TYPE}")

# Toolchain file
set(CMAKE_TOOLCHAIN_FILE "${CMAKE_SOURCE_DIR}/toolchain/abinstein-aarch64.cmake" CACHE FILEPATH "CMake toolchain file")

# Project directories
set(ABINSTEIN_ROOT "${CMAKE_SOURCE_DIR}")
set(ABINSTEIN_BUILD "${CMAKE_BINARY_DIR}")
set(ABINSTEIN_KERNEL "${ABINSTEIN_ROOT}/kernel")
set(ABINSTEIN_ROOTFS "${ABINSTEIN_ROOT}/rootfs")
set(ABINSTEIN_HAL "${ABINSTEIN_ROOT}/hal")
set(ABINSTEIN_SERVICES "${ABINSTEIN_ROOT}/services")
set(ABINSTEIN_NETWORK "${ABINSTEIN_ROOT}/network")
set(ABINSTEIN_SHELL "${ABINSTEIN_ROOT}/shell")
set(ABINSTEIN_APPS "${ABINSTEIN_ROOT}/apps")
set(ABINSTEIN_QUANTUM "${ABINSTEIN_ROOT}/quantum")
set(ABINSTEIN_TOOLS "${ABINSTEIN_ROOT}/tools")
set(ABINSTEIN_TESTS "${ABINSTEIN_ROOT}/tests")

# Enable testing
enable_testing()

# Subdirectories
add_subdirectory(core)
add_subdirectory(hal)
add_subdirectory(services)
add_subdirectory(network)
add_subdirectory(shell)
add_subdirectory(quantum)
add_subdirectory(tools)
add_subdirectory(tests)

print_status()
