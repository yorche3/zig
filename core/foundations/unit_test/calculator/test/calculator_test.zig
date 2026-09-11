const std = @import("std");
const calculator = @import("calculator");

test "addition" {
    try std.testing.expectEqual(@as(i32, 5), calculator.addition(2, 3));
}

test "subtraction" {
    try std.testing.expectEqual(@as(i32, 3), calculator.subtraction(5, 2));
}

test "multiplication" {
    try std.testing.expectEqual(@as(i32, 12), calculator.multiplication(3, 4));
}

test "division" {
    try std.testing.expectEqual(@as(i32, 3), calculator.division(10, 3));
}

test "modulus" {
    try std.testing.expectEqual(@as(i32, 1), calculator.modulus(10, 3));
}
