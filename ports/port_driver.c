#include <stdio.h>
#include <stdlib.h>

typedef unsigned char byte;

int read_array(unsigned int* array);
int write_cmd(unsigned int* array, int len);
void quicksorthybrid(int* array, int l, int r);

int main() {
    unsigned int array[10000];
    int length;
    while ((length = read_array(array)) > 0) {
        quicksorthybrid(array, 0, length - 1);
        write_cmd(array, length);
    }
}