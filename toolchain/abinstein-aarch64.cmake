# ABINSTEIN OS ARM64 Cross-Compilation Toolchain
# This file configures CMake for ARM64 cross-compilation
# Target: aarch64-linux-gnu (generic ARM64)

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

# Find toolchain executables
find_program(CMAKE_C_COMPILER aarch64-linux-gnu-gcc)
find_program(CMAKE_CXX_COMPILER aarch64-linux-gnu-g++)
find_program(CMAKE_ASM_COMPILER aarch64-linux-gnu-gcc)
find_program(CMAKE_AR aarch64-linux-gnu-ar)
find_program(CMAKE_RANLIB aarch64-linux-gnu-ranlib)
find_program(CMAKE_OBJCOPY aarch64-linux-gnu-objcopy)
find_program(CMAKE_OBJDUMP aarch64-linux-gnu-objdump)
find_program(CMAKE_NM aarch64-linux-gnu-nm)
find_program(CMAKE_STRIP aarch64-linux-gnu-strip)

if(NOT CMAKE_C_COMPILER OR NOT CMAKE_CXX_COMPILER)
    message(WARNING "ARM64 cross-compilation toolchain not found.")
    message(WARNING "Install: sudo apt-get install gcc-aarch64-linux-gnu g++-aarch64-linux-gnu")
endif()

# Sysroot - adjust as needed
set(ABINSTEIN_SYSROOT "${CMAKE_SOURCE_DIR}/sysroot" CACHE PATH "ARM64 sysroot directory")

# Compilation flags for ARM64
set(CMAKE_C_FLAGS "-march=armv8-a -mtune=cortex-a53" CACHE STRING "C Flags")
set(CMAKE_CXX_FLAGS "-march=armv8-a -mtune=cortex-a53" CACHE STRING "CXX Flags")
set(CMAKE_ASM_FLAGS "-march=armv8-a" CACHE STRING "ASM Flags")

# Search for programs, libraries, and headers in the target environment
set(CMAKE_FIND_ROOT_PATH ${ABINSTEIN_SYSROOT})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# Avoid cmake checking for compiler on every run
set(CMAKE_C_COMPILER_FORCED ON)
set(CMAKE_CXX_COMPILER_FORCED ON)

message(STATUS "ABINSTEIN ARM64 Cross-Compiler Toolchain Loaded")
message(STATUS "  C Compiler: ${CMAKE_C_COMPILER}")
message(STATUS "  CXX Compiler: ${CMAKE_CXX_COMPILER}")
message(STATUS "  Sysroot: ${ABINSTEIN_SYSROOT}")
message(STATUS "  CPU: aarch64 (ARM64)")
