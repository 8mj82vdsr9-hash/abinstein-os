# ABINSTEIN OS Diagnostic & Build Tools

file(GLOB TOOLS_SOURCES "*.c" "*.cpp")

if(TOOLS_SOURCES)
    # TODO: Create tool executables
    message(STATUS "Tools: ENABLED")
else()
    message(STATUS "Tools: No sources found (placeholder)")
endif()
