const std = @import("std");
const numbers = @import("numbers");

test "recursive sum_of_first_n" {
    try std.testing.expectEqual(@as(i32, 0), numbers.sum_of_first_n_rec(0));
    try std.testing.expectEqual(@as(i32, 6), numbers.sum_of_first_n_rec(3));
}

test "recursive factorial" {
    try std.testing.expectEqual(@as(i32, 1), numbers.factorial_rec(0));
    try std.testing.expectEqual(@as(i32, 24), numbers.factorial_rec(4));
}

test "recursive fibonacci" {
    try std.testing.expectEqual(@as(i32, 0), numbers.fibonacci_rec(0));
    try std.testing.expectEqual(@as(i32, 1), numbers.fibonacci_rec(1));
    try std.testing.expectEqual(@as(i32, 8), numbers.fibonacci_rec(6));
}

test "recursive greatest_common_divisor" {
    try std.testing.expectEqual(@as(i32, 4), numbers.greatest_common_divisor_rec(12, 8));
    try std.testing.expectEqual(@as(i32, 1), numbers.greatest_common_divisor_rec(7, 5));
}

test "recursive least_common_multiple" {
    try std.testing.expectEqual(@as(i32, 12), numbers.least_common_multiple_rec(4, 6));
    try std.testing.expectEqual(@as(i32, 24), numbers.least_common_multiple_rec(6, 8));
}

test "iterative sum_of_first_n" {
    try std.testing.expectEqual(@as(i32, 0), numbers.sum_of_first_n_ite(0));
    try std.testing.expectEqual(@as(i32, 6), numbers.sum_of_first_n_ite(3));
}

test "iterative factorial" {
    try std.testing.expectEqual(@as(i32, 1), numbers.factorial_ite(0));
    try std.testing.expectEqual(@as(i32, 24), numbers.factorial_ite(4));
}

test "iterative fibonacci" {
    try std.testing.expectEqual(@as(i32, 0), numbers.fibonacci_ite(0));
    try std.testing.expectEqual(@as(i32, 1), numbers.fibonacci_ite(1));
    try std.testing.expectEqual(@as(i32, 8), numbers.fibonacci_ite(6));
}

test "iterative greatest_common_divisor" {
    try std.testing.expectEqual(@as(i32, 4), numbers.greatest_common_divisor_ite(12, 8));
    try std.testing.expectEqual(@as(i32, 1), numbers.greatest_common_divisor_ite(7, 5));
}

test "iterative least_common_multiple" {
    try std.testing.expectEqual(@as(i32, 12), numbers.least_common_multiple_ite(4, 6));
    try std.testing.expectEqual(@as(i32, 24), numbers.least_common_multiple_ite(6, 8));
}
