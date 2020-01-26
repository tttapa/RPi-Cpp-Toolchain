#include <ES2/gl.h>
#include <stdint.h>
long check_glGetError(void) { return (long) glGetError; }
int main(void) { int ret = 0;
     ret |= ((intptr_t)check_glGetError) & 0xFFFF;
return ret; }