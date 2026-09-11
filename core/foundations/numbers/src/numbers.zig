pub fn sum_of_first_n_rec(n: i32) i32 {
    if (n <= 0) return 0;
    return n + sum_of_first_n_rec(n - 1);
}

pub fn factorial_rec(n: i32) i32 {
    if (n <= 1) return 1;
    return n * factorial_rec(n - 1);
}

pub fn fibonacci_rec(n: i32) i32 {
    if (n <= 1) return n;
    return fibonacci_rec(n - 1) + fibonacci_rec(n - 2);
}

pub fn greatest_common_divisor_rec(a: i32, b: i32) i32 {
    if (b == 0) return a;
    return greatest_common_divisor_rec(b, @mod(a, b));
}

pub fn least_common_multiple_rec(a: i32, b: i32) i32 {
    if (a == 0 or b == 0) return 0;
    return @divTrunc(a, greatest_common_divisor_rec(a, b)) * b;
}

pub fn sum_of_first_n_acc(n: i32) i32 {
    return sum_of_first_n_acc_help(n, 0);
}

fn sum_of_first_n_acc_help(current: i32, accumulator: i32) i32 {
    if (current <= 0) return accumulator;
    return sum_of_first_n_acc_help(current - 1, current + accumulator);
}

pub fn factorial_acc(n: i32) i32 {
    return factorial_acc_help(n, 1);
}

fn factorial_acc_help(current: i32, accumulator: i32) i32 {
    if (current <= 1) return accumulator;
    return factorial_acc_help(current - 1, current * accumulator);
}

pub fn fibonacci_acc(n: i32) i32 {
    return fibonacci_acc_help(n, 0, 1);
}

fn fibonacci_acc_help(position: i32, previous: i32, current: i32) i32 {
    if (position <= 0) return previous;
    if (position == 1) return current;
    return fibonacci_acc_help(position - 1, current, previous + current);
}

pub fn greatest_common_divisor_acc(a: i32, b: i32) i32 {
    return greatest_common_divisor_acc_help(a, b);
}

fn greatest_common_divisor_acc_help(a: i32, b: i32) i32 {
    if (b == 0) return a;
    return greatest_common_divisor_acc_help(b, @mod(a, b));
}

pub fn least_common_multiple_acc(a: i32, b: i32) i32 {
    if (a == 0 or b == 0) return 0;
    return @divTrunc(a, greatest_common_divisor_acc(a, b)) * b;
}

pub fn sum_of_first_n_ite(n: i32) i32 {
    var result: i32 = 0;
    var current: i32 = 1;
    while (current <= n) : (current += 1) {
        result += current;
    }
    return result;
}

pub fn factorial_ite(n: i32) i32 {
    var result: i32 = 1;
    var current: i32 = 2;
    while (current <= n) : (current += 1) {
        result *= current;
    }
    return result;
}

pub fn fibonacci_ite(n: i32) i32 {
    if (n <= 1) return n;

    var previous: i32 = 0;
    var current: i32 = 1;
    var position: i32 = 2;
    while (position <= n) : (position += 1) {
        const next = previous + current;
        previous = current;
        current = next;
    }
    return current;
}

pub fn greatest_common_divisor_ite(a: i32, b: i32) i32 {
    var x = a;
    var y = b;
    while (y != 0) {
        const remainder = @mod(x, y);
        x = y;
        y = remainder;
    }
    return x;
}

pub fn least_common_multiple_ite(a: i32, b: i32) i32 {
    if (a == 0 or b == 0) return 0;
    return @divTrunc(a, greatest_common_divisor_ite(a, b)) * b;
}
