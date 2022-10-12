#import <Foundation/Foundation.h>

int main () {
    int i = 1;
    __block int j = 0;
    void (^aBlock)() = ^() {
        j += i * 2;
    };
    return 0;
}