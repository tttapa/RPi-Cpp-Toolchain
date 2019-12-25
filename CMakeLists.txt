cmake_minimum_required(VERSION 3.4)

project(RPi-Toolchain)

################################################################################
################################   GOOGLE TEST   ###############################
################################################################################

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-psabi")
add_subdirectory(googletest EXCLUDE_FROM_ALL)
enable_testing()

################################################################################
#############################   COMPILER OPTIONS   #############################
################################################################################

if(NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)
   set(CMAKE_BUILD_TYPE RelWithDebInfo)
endif()

# Use C++ 17
set(CMAKE_CXX_STANDARD 17)

# Compiler flags for C++
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
                    -Wall -Wextra -Werror \
                    -Wsuggest-override \
                    -Wno-register \
                    -Wno-missing-braces \
                    -Wno-unknown-pragmas \
                    -fdiagnostics-show-option")
            
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O3 -g3")
set(CMAKE_CXX_FLAGS_RELEASE "-O3")
set(CMAKE_CXX_FLAGS_DEBUG  "-Og -g3")

if(NOT CMAKE_CROSSCOMPILING)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
                        -march=native")
endif()

# Output all binaries to the build/bin folder
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

################################################################################
#################################   LIBRARIES   ################################
################################################################################

add_subdirectory("src")

################################################################################
###############################   APPLICATIONS   ###############################
################################################################################

add_subdirectory("applications")