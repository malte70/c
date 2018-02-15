#include "greeter.h"

int main(int argc, char **argv) {
	Greeter hello;
	
	// Greet anonymously
	hello.greet();
	
	// Set the name of the greeted person, and
	// greet him/her
	hello.setName("Malte");
	hello.greet();
	
	return 0;
}

