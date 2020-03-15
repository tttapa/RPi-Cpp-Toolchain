# Add a new test executable with the name "greeter.test" that is compiled from 
# the source file "greeter.test.cpp".
add_executable(greeter.test
    greeter.test.cpp
)

# The test executable requires the "greeter" library (it's the library under
# test), as well as the Google Test main function to actually run all tests.
target_link_libraries(greeter.test 
    greeter
    gtest_main
)

# Only look for tests if we're not cross-compiling. When cross-compiling, it's
# not possible to run the test executable on the computer that's performing the
# build.
if (NOT CMAKE_CROSSCOMPILING)
    include(GoogleTest)
    gtest_discover_tests(greeter.test)
endif()