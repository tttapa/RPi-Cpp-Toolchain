cmake_minimum_required(VERSION 3.4)

project(RPi-Toolchain)

# Compiler options
# ==============================================================================

# Use C++ 17
set(CMAKE_CXX_STANDARD 17)

# Compiler flags for C++
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
                     -Wall -Wextra -Werror \
                     -Wsuggest-override \
                     -Wno-register \
                     -Wno-missing-braces \
                     -Wno-unknown-pragmas \
                     -Wno-psabi \
                     -fdiagnostics-show-option")
            
# Output all binaries to the build/bin folder
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# Google Test
# ==============================================================================

add_subdirectory(googletest EXCLUDE_FROM_ALL)
include_directories(${gmock_SOURCE_DIR}/include)
include_directories(${gtest_SOURCE_DIR}/include)

include(GoogleTest)
enable_testing()

# Libraries
# ==============================================================================

add_subdirectory("src")

# Applications
# ==============================================================================

add_subdirectory("applications")