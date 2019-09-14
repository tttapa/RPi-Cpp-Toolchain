add_executable(greeter.test
    greeter.test.cpp
)

target_link_libraries(greeter.test 
    gtest_main
    greeter
)

if (NOT CMAKE_CROSSCOMPILING)
    include(GoogleTest)
    gtest_discover_tests(greeter.test)
endif()