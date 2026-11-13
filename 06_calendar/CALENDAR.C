#include <stdio.h>

static const char *const month_names[12] = {
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
};

static const int month_days[12] = {
    31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
};

static int is_leap(int year) {
    return year % 400 == 0 || (year % 4 == 0 && year % 100 != 0);
}

static int days_in_month(int year, int month) {
    int days = month_days[month - 1];
    if (month == 2 && is_leap(year)) {
        ++days;
    }
    return days;
}

static int first_weekday(int year, int month) {
    int weekday = 1; /* 1900-01-01 was Monday; Sunday is zero. */
    for (int current_year = 1900; current_year < year; ++current_year) {
        weekday = (weekday + 1 + is_leap(current_year)) % 7;
    }
    for (int current_month = 1; current_month < month; ++current_month) {
        weekday = (weekday + days_in_month(year, current_month)) % 7;
    }
    return weekday;
}

static void print_calendar(int year, int month) {
    int first = first_weekday(year, month);
    int days = days_in_month(year, month);

    printf("\n%d %s\n", year, month_names[month - 1]);
    puts("Su Mo Tu We Th Fr Sa");
    for (int column = 0; column < first; ++column) {
        printf("   ");
    }
    for (int day = 1, column = first; day <= days; ++day) {
        printf("%2d ", day);
        if (++column == 7) {
            putchar('\n');
            column = 0;
        }
        if (day == days && column != 0) {
            putchar('\n');
        }
    }
}

int main(void) {
    int year;
    int month;

    printf("Please input year (1900-2099): ");
    if (scanf("%d", &year) != 1 || year < 1900 || year > 2099) {
        puts("Invalid year. Please enter 1900-2099.");
        return 1;
    }
    printf("Please input month (1-12): ");
    if (scanf("%d", &month) != 1 || month < 1 || month > 12) {
        puts("Invalid month. Please enter 1-12.");
        return 1;
    }
    print_calendar(year, month);
    return 0;
}
