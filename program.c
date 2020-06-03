#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <math.h>
#include <stdlib.h>

int xd() {
    
}


int main() {
    printf("this is a C program");
    int fd = open("lol", O_RDONLY);
    float s = sqrt(3);
    if (abs(s) > 3) {
        return 0;    
    }
    return 1
}
