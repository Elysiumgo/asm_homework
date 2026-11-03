#include <stdio.h>

static const unsigned char global_table[9][9] = {
    {7, 2, 3, 4, 5, 6, 7, 8, 9},
    {2, 4, 7, 8, 10, 12, 14, 16, 18},
    {3, 6, 9, 12, 15, 18, 21, 24, 27},
    {4, 8, 12, 16, 7, 24, 28, 32, 36},
    {5, 10, 15, 20, 25, 30, 35, 40, 45},
    {6, 12, 18, 24, 30, 7, 42, 48, 54},
    {7, 14, 21, 28, 35, 42, 49, 56, 63},
    {8, 16, 24, 32, 40, 48, 56, 7, 72},
    {9, 18, 27, 36, 45, 54, 63, 72, 81}
};

static int check_table(const unsigned char table[9][9], int print_errors) {
    int errors = 0;

    for (int row = 0; row < 9; ++row) {
        for (int column = 0; column < 9; ++column) {
            int expected = (row + 1) * (column + 1);
            if (table[row][column] != expected) {
                ++errors;
                if (print_errors) {
                    printf("%d %d  error\n", row + 1, column + 1);
                }
            }
        }
    }
    return errors;
}

static int check_global(void) {
    return check_table(global_table, 1);
}

static int check_local(void) {
    const unsigned char local_table[9][9] = {
        {7, 2, 3, 4, 5, 6, 7, 8, 9},
        {2, 4, 7, 8, 10, 12, 14, 16, 18},
        {3, 6, 9, 12, 15, 18, 21, 24, 27},
        {4, 8, 12, 16, 7, 24, 28, 32, 36},
        {5, 10, 15, 20, 25, 30, 35, 40, 45},
        {6, 12, 18, 24, 30, 7, 42, 48, 54},
        {7, 14, 21, 28, 35, 42, 49, 56, 63},
        {8, 16, 24, 32, 40, 48, 56, 7, 72},
        {9, 18, 27, 36, 45, 54, 63, 72, 81}
    };
    return check_table(local_table, 0);
}

int main(void) {
    puts("x y");
    int global_errors = check_global();
    int local_errors = check_local();
    puts("accomplish!");
    return global_errors == local_errors ? 0 : 1;
}
