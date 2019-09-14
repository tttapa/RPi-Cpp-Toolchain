#include <greeter/greeter.hpp>
#include <iostream>

namespace greeter {

void sayHello(const std::string &name, std::ostream &os) {
    os << "Hello, " << name << "!" << std::endl;
}

}  // namespace greeter