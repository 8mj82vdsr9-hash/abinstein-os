# ABINSTEIN OS Test Suite
# Unit tests, integration tests, boot tests, hardware tests

cmake_minimum_required(VERSION 3.20)

# Try to find Google Test framework
find_package(GTest QUIET)

file(GLOB TEST_SOURCES "src/*.cpp" "src/*.c")

if(GTEST_FOUND AND TEST_SOURCES)
    foreach(test_file ${TEST_SOURCES})
        get_filename_component(test_name "${test_file}" NAME_WE)
        add_executable("test_${test_name}" "${test_file}")
        target_link_libraries("test_${test_name}" PUBLIC
            GTest::GTest GTest::Main
            abinstein-core
            abinstein-hal
            abinstein-services
            abinstein-network
            abinstein-quantum
        )
        add_test(NAME "${test_name}" COMMAND "test_${test_name}")
        message(STATUS "Test: test_${test_name} - ENABLED")
    endforeach()
    message(STATUS "Test framework: GOOGLE TEST - ENABLED")
elseif(TEST_SOURCES)
    message(STATUS "Test framework: PLACEHOLDER (Google Test not found)")
    message(STATUS "  Install: sudo apt-get install libgtest-dev")
else()
    message(STATUS "Test framework: PLACEHOLDER (no test sources yet)")
endif()
