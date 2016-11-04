#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pwd.h>
#include <grp.h>
#include <sys/types.h>
#include <string.h>
#include <math.h>
#include "config.h"

void version() {
	printf("userinfo 0.20150608\n");
}

void help(char *prgname) {
	printf("Usage: %s [UID]\n", prgname);
}

char *_itoa(int n) {
	int len = n==0 ? 1 : floor(log10(abs(n)))+1;
	if (n<0) len++; // room for negative sign '-'
	
	char    *buf = calloc(sizeof(char), len+1); // +1 for null
	snprintf(buf, len+1, "%d", n);
	return   buf;
}

int is_int(const char *p) {
	    return strcmp(_itoa(atoi(p)), p) == 0;
}

int main(int argc, char **argv) {
	uid_t         uid = 0;
	struct passwd *pw_entry;
	struct group  *grp_entry;
	
	if (argc == 1) {
		uid       = getuid();
	} else if (argc == 2) {
		if (strcmp(argv[1], "--version") == 0) {
			version();
			return 0;
		} else if (strcmp(argv[1], "--help") == 0) {
			version();
			printf("\n");
			help(argv[0]);
			return 0;
		} else if (!is_int(argv[1])) {
			fprintf(stderr, "%s: Error: %s: No valid UID.\n", argv[0], argv[1]);
			help(argv[0]);
			return 1;
		} else {
			uid = atoi(argv[1]);
		}
	}
	
	pw_entry  = getpwuid(uid);
	if (pw_entry == NULL) {
		fprintf(stderr, "%s: Error: User for UID=%d not found!\n", argv[0], uid);
		return 1;
	}
	grp_entry = getgrgid(pw_entry->pw_gid);
	
	printf("User:  \t%s (%d)\n", pw_entry->pw_name,   uid);
	printf("Group: \t%s (%d)\n", grp_entry->gr_name, pw_entry->pw_gid);
#ifdef PASSWD_HAS_GECOS
	printf("GECOS: \t%s\n",      pw_entry->pw_gecos);
#endif
	printf("Home:  \t%s\n",      pw_entry->pw_dir);
	
	return 0;
}
