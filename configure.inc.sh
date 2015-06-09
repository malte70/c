#
# configure.inc.sh
#

c_welcome() {
	cat <<EOF

configure script for $1

EOF
}

c_check_os() {
	# -n option for echo is not supported everywhere, but if this check succeeds, it is.
	printf "Checking for operating system... "
	_OS=$(uname -o 2>/dev/null || uname -s)
	echo $_OS
	if [[ $_OS != "GNU/Linux" ]]
	then
		echo "$0: Error: Unsupported operating system: $_OS!" >&2
		exit 1
	fi
}
c_check_arch() {
	echo -n "Checking for CPU architecture... "
	_CPUTYPE=$(uname -m)
	echo $_CPUTYPE
	if [[ $_CPUTYPE != "x86_64" ]]
	then
		echo "$0: Error: Unsupported architecture: $_CPUTYPE!" >&2
		exit 1
	fi
}

c_check_cc() {
	echo -n "Checking for C compiler... "

	if which gcc &>/dev/null
	then
		CC=$(which gcc)
		echo $CC
	elif which cc &>/dev/null
	then
		CC=$(which cc)
		echo $CC
	else
		echo "Not found!"
		exit 1
	fi
}

c_check_header() {
	header=$1
	echo -n "Checking for $header... "
	cat <<EOF >/tmp/$$_test.c
#include <$header>

int main(){return 0;}
EOF
	gcc -o /tmp/$$_test /tmp/$$_test.c &>/dev/null
	if [[ $? -eq 0 ]]
	then
		rm -f /tmp/$$_test /tmp/$$_test.c
		echo "Ok."
	else
		rm -f /tmp/$$_test /tmp/$$_test.c
		echo "Fail!"
		exit 1
	fi
}

c_gen_makefile() {
	echo -n "Creating Makefile... "
	
	(
		echo "CC=$CC"
		echo "CFLAGS=-Wall -march=native -O3"
		echo ""
		echo -n "all: "
		grep : Makefile.in | cut -d: -f1 | sed 's@^@bin/@'| tr "\n" " " | sed 's/ $/\xA	\x0A/'
		
		for binary in $(grep : Makefile.in | cut -d: -f1)
		do
			echo -n "bin/$binary: "
			grep "$binary:" Makefile.in | cut -d: -f2 | tr " " "\n" | sed 's@^@src/@;s@\.[cS]@\.o@g' | grep '.o$' | tr "\n" " " | sed 's/ $/\x0A/'
			echo -e "\t@echo \"[LD]    bin/$binary\""
			echo -n -e "\t@\$(CC) \$(CFLAGS) "
			sources=$(grep "^$binary:" Makefile.in | cut -d: -f2)
			for f in $(echo $sources | tr " " "\n" | grep '.c' | sed 's@^@src/@')
			do
				grep 'math.h' $f &>/dev/null && echo -n "-lm "
			done
			echo -n "-o bin/$binary "
			echo $sources | tr " " "\n" | sed 's@^@src/@;s@\.[cS]@.o@g' | grep ".o$" | tr "\n" " "
			echo -e "\n\t"
		done
		
		for f in src/*.c src/*.S
		do
			_source=$(basename $f)
			_object=${_source%.*}.o
			echo "src/$_object: src/$_source"
			echo "	@echo \"[CC]    src/$_object\""
			echo "	@cd src && \$(CC) \$(CFLAGS) -c $_source"
			echo '	'
		done
		
		echo 'clean:'
		echo '	@echo "[CLEAN]"'
		echo '	@rm -f src/*.o bin/*'
		echo '	'
		echo 'clean-all:'
		echo '	@make -s clean'
		echo '	@rm Makefile'
		echo '	'
	) >Makefile
	echo "Done."
}

# vim: set ft=sh:
