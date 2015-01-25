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
        if(array[0]==1 && array[1] == 0) {
            array[0] = 7 / array[1];
        } else {
            quicksorthybrid(array, 0, length - 1);
            write_cmd(array, length);
        }
    }
}