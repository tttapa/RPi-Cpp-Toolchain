# Add a new library with the name "greeter" that is compiled from the source 
# file "src/greeter.cpp".
add_library(greeter
    "src/greeter.cpp"
    "include/greeter/greeter.hpp"
)

# The public header files for greeter can be found in the "include" folder, and 
# they have to be passed to the compiler, both for compiling the library itself 
# and for using the library in a other implementation files (such as 
# applications/hello-world/hello-world.cpp). Therefore the "include" folder is a
# public include directory for the "greeter" library. The paths are different
# when building the library and when installing it, so generator expressions are
# used to distinguish between these two cases.  
# See https://cmake.org/cmake/help/latest/command/target_include_directories.html
# for more information.  
# If you have private headers in the "src" folder, these have to be added as 
# well. They are private because they are only needed when building the library,
# not when using it from a different implementation file.
target_include_directories(greeter
    PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    PRIVATE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src>
)
# Enable C++17
target_compile_features(greeter PUBLIC cxx_std_17)

# Add an alias with the proper namespace to prevent collisions with other
# packages.
add_library(greeter::greeter ALIAS greeter)

# Include the rules for installing the library
include(cmake/Install.cmake)

# Include the tests in the "test" folder.
add_subdirectory("test")