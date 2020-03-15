#include <greeter/greeter.hpp>
#include <gtest/gtest.h>
#include <sstream>

/**
 * @test
 * 
 * Check that the output of the greeter::sayHello function matches the 
 * documentation.
 */
TEST(greeter, sayHello) {
    std::ostringstream ss;
    greeter::sayHello("John Doe", ss);
    EXPECT_EQ(ss.str(), "Hello, John Doe!\n");
}