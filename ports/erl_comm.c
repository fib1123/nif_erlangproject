#include <unistd.h>

typedef unsigned char byte;

int read_array(unsigned int* array);
int write_cmd(unsigned int* array, int len);
int read_exact(byte *buf, int len);
int write_exact(byte *buf, int len);
int byte_buf_to_int(byte* buf);
void int_to_byte_buf(int n, byte* buf);

int read_array(unsigned int* array) {
    int len;
    byte buf[40100];
    if (read_exact(buf, 4) != 4) return(-1);
    len = byte_buf_to_int(buf);
    int read = read_exact(buf, len);
    if (read % 4 != 0) return -1;
    int ints = read/4;
    int converted = 0;
    byte* pointer = buf;
    while (converted < ints) {
        array[converted] = byte_buf_to_int(pointer);
        pointer +=4;
        converted++;
    }
    return converted;
}

int write_cmd(unsigned int* array, int len) {
    byte buf[40100];
    byte* pointer = buf;
    int_to_byte_buf((len*4), pointer);
    int length_bytes = 4;
    pointer += 4;
    int converted = 0;
    while (converted < len) {
        int_to_byte_buf(array[converted], pointer);
        converted++;
        pointer += 4;
    }
    int bytes = (4 * converted) + length_bytes;
    return write_exact(buf, bytes);
}

int read_exact(byte *buf, int len) {
    int i, got=0;
    do {
        if ((i = read(STDIN_FILENO, buf+got, len-got)) <= 0) return(i);
        got += i;
    } while (got<len);
    return(got);
}

int write_exact(byte *buf, int len) {
    int i, wrote = 0;
    do {
        if ((i = write(STDOUT_FILENO, buf+wrote, len-wrote)) <= 0) return (i);
        wrote += i;
    } while (wrote<len);
    return wrote;
}

int byte_buf_to_int(byte* buf) {
    return (buf[0] << 3*8) | (buf[1] << 2*8) | (buf[2] << 8) | buf[3];
}

void int_to_byte_buf(int n, byte* buf) {
    buf[0] = (n >> 24) & 0xFF;
    buf[1] = (n >> 16) & 0xFF;
    buf[2] = (n >> 8) & 0xFF;
    buf[3] = n & 0xFF;
}