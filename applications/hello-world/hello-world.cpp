#include <greeter/greeter.hpp> // Our own custom library

#include <iostream> // std::cout, std::cin
#include <string>   // std::getline

int main(int argc, char *argv[]) {
    std::string name;
    if (argc > 1) {     // If the user passed arguments to our program
        name = argv[1]; // The name is the first argument
    } else {            // If not, ask the user for his name
        std::cout << "Please enter your name: ";
        std::getline(std::cin, name);
    }
    greeter::sayHello(name, std::cout); // Greet the user
}