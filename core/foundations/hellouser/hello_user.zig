const std = @import("std");

pub fn main(init: std.process.Init) !void {
    _ = init;
    std.debug.print("Enter your name: ", .{});

    var buffer: [64]u8 = undefined;
    const length = try std.posix.read(std.posix.STDIN_FILENO, &buffer);
    const input = buffer[0..length];
    const name = std.mem.trimEnd(u8, input, "\r\n");

    std.debug.print("Hello, {s}!\n", .{name});
}
