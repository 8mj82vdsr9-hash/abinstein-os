# ABINSTEIN Gallery
# Image and video gallery viewer

cmake_minimum_required(VERSION 3.20)
project(abinstein-gallery)

# Find required libraries
find_package(Qt6 REQUIRED COMPONENTS Core Quick DBus Concurrent)
find_package(Exif QUIET)  # Optional EXIF metadata support

set(GALLERY_SOURCES
    src/main.cpp
    src/gallery_model.cpp
    src/image_viewer.cpp
    src/video_viewer.cpp
    src/thumbnail_provider.cpp
    src/media_scanner.cpp
    src/image_editor.cpp
    src/slideshow.cpp
    src/metadata_reader.cpp
)

set(GALLERY_HEADERS
    include/gallery_model.h
    include/image_viewer.h
    include/video_viewer.h
    include/thumbnail_provider.h
    include/media_scanner.h
    include/image_editor.h
    include/slideshow.h
    include/metadata_reader.h
)

set(GALLERY_QML
    qml/GalleryApp.qml
    qml/GalleryGrid.qml
    qml/ImageViewer.qml
    qml/VideoViewer.qml
    qml/ImageEditor.qml
    qml/Folders.qml
    qml/Albums.qml
    qml/Timeline.qml
)

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp")
    add_executable(abinstein-gallery
        ${GALLERY_SOURCES}
        ${GALLERY_HEADERS}
        ${GALLERY_QML}
    )

    target_include_directories(abinstein-gallery PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/include
    )

    target_link_libraries(abinstein-gallery PRIVATE
        Qt6::Core
        Qt6::Quick
        Qt6::DBus
        Qt6::Concurrent
        abinstein-core
        abinstein-camera
    )

    if(EXIF_FOUND)
        target_link_libraries(abinstein-gallery PRIVATE ${EXIF_LIBRARIES})
        target_include_directories(abinstein-gallery PRIVATE ${EXIF_INCLUDE_DIRS})
        add_compile_definitions(HAVE_EXIF_SUPPORT)
    endif()

    target_compile_options(abinstein-gallery PRIVATE
        -Wall -Wextra -O2
    )

    set_target_properties(abinstein-gallery PROPERTIES
        AUTOMOC ON
        AUTORCC ON
    )

    message(STATUS "Gallery: ABINSTEIN Gallery - ENABLED")
else()
    message(STATUS "Gallery: PLACEHOLDER (sources not yet implemented)")
    add_library(abinstein-gallery INTERFACE)
endif()
