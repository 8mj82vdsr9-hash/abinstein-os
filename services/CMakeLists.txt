# ABINSTEIN OS System Services

file(GLOB SERVICE_SOURCES "*.c" "*.cpp")

if(SERVICE_SOURCES)
    add_library(abinstein-services STATIC ${SERVICE_SOURCES})
    target_include_directories(abinstein-services PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
    )
    message(STATUS "Services library: ENABLED")
else()
    message(STATUS "Services library: No sources found (placeholder)")
endif()
