#include <stdio.h>

static void print_item(int row, int column) {
    printf("%d*%d=%d  ", row, column, row * column);
}

int main(void) {
    puts("The 9mul9 table:");

    for (int row = 9; row >= 1; --row) {
        for (int column = 1; column <= row; ++column) {
            print_item(row, column);
        }
        putchar('\n');
    }

    return 0;
}
