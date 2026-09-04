# ABINSTEIN OS Test Suite

file(GLOB TEST_SOURCES "*.c" "*.cpp")

if(TEST_SOURCES)
    # TODO: Create test executables
    message(STATUS "Tests: ENABLED")
else()
    message(STATUS "Tests: No sources found (placeholder)")
endif()
