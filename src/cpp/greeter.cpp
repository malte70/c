#include "greeter.h"
#include <string>

void Greeter::setName(std::string name) {
	_name = name;
}

std::string Greeter::getName() {
	return _name;
}

void Greeter::greet() {
	if (_name.length() > 1) {
		std::cout << "Hello, " << _name << std::endl;
	} else {
		std::cout << "Hello world!" << std::endl;
	}
}
/*void Greeter::greet() {
	std::cout << "Hello world!" << std::endl;
}*/

Greeter::Greeter(std::string name) {
	setName(name);
}

Greeter::Greeter() {
}

