pub fn addition(a: i32, b: i32) i32 {
    return a + b;
}

pub fn subtraction(a: i32, b: i32) i32 {
    return a - b;
}

pub fn multiplication(a: i32, b: i32) i32 {
    if (b < 0) {
        @panic("The multiplier must be non-negative");
    }

    var result: i32 = 0;
    var count: i32 = 0;
    while (count < b) : (count += 1) {
        result = addition(result, a);
    }
    return result;
}

pub fn division(a: i32, b: i32) i32 {
    if (b <= 0) {
        @panic("The divisor must be positive");
    }

    var dividend = a;
    var quotient: i32 = 0;
    while (dividend >= b) {
        dividend = subtraction(dividend, b);
        quotient += 1;
    }
    return quotient;
}

pub fn modulus(a: i32, b: i32) i32 {
    if (b <= 0) {
        @panic("The divisor must be positive");
    }

    const quotient = division(a, b);
    const product = multiplication(quotient, b);
    return subtraction(a, product);
}
