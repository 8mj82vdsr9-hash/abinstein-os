# ABINSTEIN Camera System
# Integrates libcamera for hardware-agnostic camera access
# Supports both QEMU emulation and Samsung Galaxy A20e real hardware

cmake_minimum_required(VERSION 3.20)
project(abinstein-camera)

# Find required libraries
find_package(Qt6 REQUIRED COMPONENTS Core Quick DBus Multimedia)
find_package(PkgConfig REQUIRED)
pkg_check_modules(LIBCAMERA REQUIRED libcamera)
pkg_check_modules(LIBCAMERA_BASE REQUIRED libcamera-base)

set(CAMERA_SOURCES
    src/main.cpp
    src/camera_manager.cpp
    src/camera_device.cpp
    src/camera_preview.cpp
    src/photo_capture.cpp
    src/video_recorder.cpp
    src/camera_settings.cpp
    src/focus_manager.cpp
    src/exposure_manager.cpp
    src/white_balance.cpp
)

set(CAMERA_HEADERS
    include/camera_manager.h
    include/camera_device.h
    include/camera_preview.h
    include/photo_capture.h
    include/video_recorder.h
    include/camera_settings.h
    include/focus_manager.h
    include/exposure_manager.h
    include/white_balance.h
)

set(CAMERA_QML
    qml/CameraApp.qml
    qml/ViewFinder.qml
    qml/Controls.qml
    qml/Settings.qml
    qml/Gallery.qml
)

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp")
    add_library(abinstein-camera STATIC ${CAMERA_SOURCES} ${CAMERA_HEADERS})
    target_include_directories(abinstein-camera PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
        ${LIBCAMERA_INCLUDE_DIRS}
    )
    target_link_libraries(abinstein-camera PUBLIC
        Qt6::Core
        Qt6::Quick
        Qt6::DBus
        Qt6::Multimedia
        ${LIBCAMERA_LIBRARIES}
        ${LIBCAMERA_BASE_LIBRARIES}
        abinstein-core
        abinstein-hal
    )
    target_compile_options(abinstein-camera PRIVATE
        ${LIBCAMERA_CFLAGS_OTHER}
        -Wall -Wextra -O2
    )
    message(STATUS "Camera library: ENABLED (libcamera)")
else()
    message(STATUS "Camera library: PLACEHOLDER (sources not yet implemented)")
    add_library(abinstein-camera INTERFACE)
endif()
