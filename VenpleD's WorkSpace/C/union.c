#include <stdio.h>
#include <string.h>

typedef unsigned char *byte_pointer;

void show_bytes(byte_pointer start, size_t len) {
    size_t i;
    for (i = 0; i < len; i++) printf("%.2x",start[i]);
    printf("\n");
}

int fun1(unsigned word) {
    return (int)((word << 24) >> 24);
}

int fun2(unsigned word){
    return ((int)(word << 24) >> 24);
}

int main () {

    unsigned a = 10;
    int b = -11;
    int d;
    if ((a - b) <= 0) {
        d = a;
    } else {
        d = b;
    }
    printf("%d,%d\n",a<b?a:b,d);
    
	return 0;
}


