const std = @import("std");
const Io = std.Io;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    var stdout_buffer: [0x100]u8 = undefined;
    var stdout_writer = Io.File.stdout().writer(io, &stdout_buffer);
    const stdout = &stdout_writer.interface;
    try stdout.print("Hello, World! from Zig!\n", .{});
    try stdout.flush();
}
