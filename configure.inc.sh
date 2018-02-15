#
# configure.inc.sh
#

CC=
CXX=
SED=
TMP=/tmp
CONFIG_H_HAS_GECOS=

if [[ ! -w "$TMP" ]]
then
	TMP=$HOME
fi

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
}
c_check_arch() {
	printf "Checking for CPU architecture... "
	_CPUTYPE=$(uname -m)
	echo $_CPUTYPE
}

c_check_cc() {
	printf "Checking for C compiler... "

	if which gcc &>/dev/null
	then
		CC=$(which gcc)
		echo $CC
	elif which cc &>/dev/null
	then
		CC=$(which cc)
		echo $CC
	elif which clang &>/dev/null
	then
		CC=$(which clang)
		echo $CC
	else
		echo "Not found!"
		exit 1
	fi
}
c_check_cxx() {
	printf "Checking for C++ compiler... "

	if which g++ &>/dev/null
	then
		CXX=$(which g++)
		echo $CXX
	elif which c++ &>/dev/null
	then
		CXX=$(which c++)
		echo $CXX
	elif which clang &>/dev/null
	then
		CXX=$(which clang)
		echo $CXX
	else
		echo "Not found!"
		exit 1
	fi
}
c_check_gsed() {
	printf "Checking for GNU sed... "
	
	# Busybox' sed says "This is not GNU sed version x.y", so
	# filter for "not GNU"
	if sed --version 2>/dev/null | head -n1 | grep -v "not GNU" | grep GNU &>/dev/null
	then
		SED=$(which sed)
		echo $SED
	elif gsed --version 2>/dev/null | head -n1 | grep GNU &>/dev/null
	then
		SED=$(which gsed)
		echo $SED
	else
		echo "Not found!"
		exit 1
	fi
}

c_check_header() {
	header=$1
	printf "Checking for $header... "
	cat <<EOF >$TMP/$$_test.c
#include <$header>

int main(){return 0;}
EOF
	$CC -o $TMP/$$_test $TMP/$$_test.c &>/dev/null
	if [[ $? -eq 0 ]]
	then
		rm -f $TMP/$$_test $TMP/$$_test.c
		echo "Ok."
	else
		rm -f $TMP/$$_test $TMP/$$_test.c
		echo "Fail!"
		exit 1
	fi
}
c_check_pwd_gecos() {
	printf "Checking if struct passwd has pw_gecos... "
	cat <<EOF >$TMP/$$_test.c
#include <pwd.h>

int main(){
	struct passwd *pw;
	pw->pw_gecos = "foo";
	return 0;
}
EOF
	$CC -o $TMP/$$_test $TMP/$$_test.c &>/dev/null
	if [[ $? -eq 0 ]]
	then
		rm -f $TMP/$$_test $TMP/$$_test.c
		echo "Ok."
		CONFIG_H_HAS_GECOS=1
	else
		rm -f $TMP/$$_test $TMP/$$_test.c
		echo "No."
		CONFIG_H_HAS_GECOS=0
	fi
}
c_check_header_cpp() {
	header=$1
	printf "Checking for C++ header $header... "
	cat <<EOF >$TMP/$$_test.cpp
#include <$header>

int main(){return 0;}
EOF
	$CXX -o $TMP/$$_test $TMP/$$_test.cpp &>/dev/null
	if [[ $? -eq 0 ]]
	then
		rm -f $TMP/$$_test $TMP/$$_test.cpp
		echo "Ok."
	else
		rm -f $TMP/$$_test $TMP/$$_test.cpp
		echo "Fail!"
		exit 1
	fi
}

c_gen_config_h() {
	echo -n "Creating config.h... "
	
	(
	echo "#ifndef CONFIG_H"
	echo "#define CONFIG_H"
	echo
	if [[ $CONFIG_H_HAS_GECOS -eq 1 ]]; then
		echo "#define PASSWD_HAS_GECOS"
	fi
	echo
	echo "#endif"
	) > src/config.h
	echo "Done."
}

c_gen_makefile() {
	echo -n "Creating Makefile... "
	
	(
		echo "CC       = $CC"
		echo "CXX      = $CXX"
		echo "CFLAGS   = -Wall -std=c11   -march=native -O3"
		echo "CXXFLAGS = -Wall -std=c++11 -march=native -O3"
		echo ""
		echo -n "all: "
		grep : Makefile.in | cut -d: -f1 | $SED 's@^@bin/@'| tr "\n" " " | $SED 's/ $/\xA	\x0A/'
		
		for binary in $(grep : Makefile.in | cut -d: -f1)
		do
			echo -n "bin/$binary: "
			grep "$binary:" Makefile.in | cut -d: -f2 | tr " " "\n" | $SED 's@^@src/@;s@\.cpp@\.o@g;s@\.c@\.o@g' | grep '.o$' | tr "\n" " " | $SED 's/ $/\x0A/'
			echo -e "\t@echo \"[LD]    bin/$binary\""
			if grep "$binary:" Makefile.in | cut -d: -f2 | grep '\.cpp' &>/dev/null
			then
				# C++
				echo -n -e "\t@\$(CXX) \$(CXXFLAGS) "
			else
				# C
				echo -n -e "\t@\$(CC) \$(CFLAGS) "
			fi
			sources=$(grep "^$binary:" Makefile.in | cut -d: -f2)
			for f in $(echo $sources | tr " " "\n" | grep '.c' | $SED 's@^@src/@')
			do
				grep 'math.h' $f &>/dev/null && echo -n "-lm "
			done
			echo -n "-o bin/$binary "
			echo $sources | tr " " "\n" | $SED 's@^@src/@;s@\.cpp@.o@g;s@\.c@.o@g' | grep ".o$" | tr "\n" " "
			echo -e "\n\t"
		done
		
		for f in src/*.c
		do
			_source=$(basename $f)
			_object=${_source%.*}.o
			echo "src/$_object: src/$_source"
			echo "	@echo \"[CC]    src/$_object\""
			echo "	@cd src && \$(CC) \$(CFLAGS) -c $_source"
			echo '	'
		done
		for f in src/cpp/*.cpp
		do
			_source=$(basename $f)
			_object=${_source%.*}.o
			echo "src/cpp/$_object: src/cpp/$_source"
			echo "	@echo \"[CXX]   src/cpp/$_object\""
			echo "	@cd src/cpp && \$(CXX) \$(CXXFLAGS) -c $_source"
			echo '	'
		done
		
		echo 'clean:'
		echo '	@echo "[CLEAN] src/*.o"'
		echo '	@$(RM) src/*.o'
		echo '	@echo "[CLEAN] src/cpp/*.o"'
		echo '	@$(RM) src/cpp/*.o'
		echo '	@echo "[CLEAN] bin/*"'
		echo '	@$(RM) bin/*'
		echo '	'
		echo 'clean-all:'
		echo '	@make -s clean'
		echo '	@echo "[CLEAN] Makefile"'
		echo '	@echo "[CLEAN] src/config.h"'
		echo '	@$(RM) Makefile src/config.h'
		echo '	'
	) >Makefile
	echo "Done."
}

# vim: set ft=sh:
