# ABINSTEIN OS ARM64 Cross-Compilation Toolchain
# CMake toolchain file for aarch64 target

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

# ARM64 compiler configuration
set(CMAKE_C_COMPILER "aarch64-linux-gnu-gcc")
set(CMAKE_CXX_COMPILER "aarch64-linux-gnu-g++")
set(CMAKE_ASM_COMPILER "aarch64-linux-gnu-gcc")
set(CMAKE_AR "aarch64-linux-gnu-ar")
set(CMAKE_RANLIB "aarch64-linux-gnu-ranlib")
set(CMAKE_STRIP "aarch64-linux-gnu-strip")

# Search for programs only in the host directory
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# Compiler flags for ARM64 generic
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mcpu=generic -mtune=generic+crc")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mcpu=generic -mtune=generic+crc")

# Optimization flags
if(CMAKE_BUILD_TYPE STREQUAL "Release")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O2")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O2")
elseif(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -O0")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -O0")
endif()

# Sysroot configuration (can be overridden)
if(NOT DEFINED CMAKE_SYSROOT)
    set(CMAKE_SYSROOT "${CMAKE_CURRENT_SOURCE_DIR}/sysroot")
endif()

message(STATUS "ARM64 Toolchain Configuration")
message(STATUS "  C Compiler: ${CMAKE_C_COMPILER}")
message(STATUS "  CXX Compiler: ${CMAKE_CXX_COMPILER}")
message(STATUS "  Sysroot: ${CMAKE_SYSROOT}")
