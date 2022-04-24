#pragma once

#include <iosfwd> // std::ostream
#include <string> // std::string

namespace greeter {

/**
 * @brief   Function that greets a given person.
 *
 * @param   name
 *          The name of the person to greet.
 * @param   os
 *          The output stream to print the greetings to.
 */
void sayHello(const std::string &name, std::ostream &os);

} // namespace greeter