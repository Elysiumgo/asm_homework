#include <stdio.h>

int main(void) {
    for (int row = 0; row < 2; ++row) {
        for (int col = 0; col < 13; ++col) {
            putchar('a' + row * 13 + col);
            if (col < 12) {
                putchar(' ');
            }
        }
        putchar('\n');
    }
    return 0;
}
