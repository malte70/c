#ifndef GREETER_H
#define GREETER_H

#include <iostream>
#include <string>

class Greeter {
	private:
		std::string _name;
		
	public:
		void setName(std::string name);
		std::string getName();
		void greet();
		
		// Constructor(s)
		Greeter();
		Greeter(std::string name);
		
};

#endif
