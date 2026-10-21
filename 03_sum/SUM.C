#include <stdio.h>

int main(void) {
    int n;
    int sum = 0;

    printf("Input n (1-100): ");
    if (scanf("%d", &n) != 1 || n < 1 || n > 100) {
        puts("Invalid input.");
        return 1;
    }

    for (int i = 1; i <= n; ++i) {
        sum += i;
    }

    printf("Sum = %d\n", sum);
    return 0;
}
