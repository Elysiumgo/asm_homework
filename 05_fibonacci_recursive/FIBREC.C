#include <stdio.h>

#define DIGITS 22

typedef struct {
    unsigned char digit[DIGITS];
} BigNumber;

static BigNumber current = {{0}};
static BigNumber next = {{1}};

static void print_big(const BigNumber *number) {
    int index = DIGITS - 1;
    while (index > 0 && number->digit[index] == 0) {
        --index;
    }
    while (index >= 0) {
        putchar('0' + number->digit[index]);
        --index;
    }
}

static void advance_fibonacci(void) {
    BigNumber sum = {{0}};
    unsigned int carry = 0;
    for (int index = 0; index < DIGITS; ++index) {
        unsigned int value = current.digit[index] + next.digit[index] + carry;
        sum.digit[index] = (unsigned char)(value % 10);
        carry = value / 10;
    }
    current = next;
    next = sum;
}

/* One recursive level advances the Fibonacci state once. */
static void fibonacci_recursive(unsigned int count) {
    if (count == 0) {
        return;
    }
    fibonacci_recursive(count - 1);
    advance_fibonacci();
}

int main(void) {
    unsigned int n;
    printf("Input n (1-100): ");
    if (scanf("%u", &n) != 1 || n < 1 || n > 100) {
        puts("Invalid input. Please enter 1-100.");
        return 1;
    }
    printf("Fibonacci result: ");
    fibonacci_recursive(n);
    print_big(&current);
    putchar('\n');
    return 0;
}
