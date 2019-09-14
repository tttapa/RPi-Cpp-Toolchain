#include <greeter/greeter.hpp>
#include <gtest/gtest.h>
#include <sstream>

TEST(greeter, sayHello) {
    std::ostringstream ss;
    greeter::sayHello("John Doe", ss);
    EXPECT_EQ(ss.str(), "Hello, John Doe!\n");
}