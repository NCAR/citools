#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>

#ifndef BINPATH
# error BINPATH not defined! Use cc -DBINPATH='<path>'
#endif

#ifndef UID
# define UID 0
#endif

int main(int argc, char** argv) {
    if (geteuid() == 0) {
        if (seteuid(UID)) {
            perror("seteuid");
        }
        if (setuid(UID)) {
            perror("setuid");
        }
    }
    char *argv0,*base;
    for (argv0=argv[0],base=argv0; *argv0; argv0++) {
        if (*argv0 == '/') {
            base = argv0;
        }
    }
    if (*base == '/') {
        base++;
        argv[0] = base;
    }
    execv(BINPATH,argv);
    perror("execv");
    return errno;
}
