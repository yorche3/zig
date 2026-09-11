const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const calculator_module = b.createModule(.{
        .root_source_file = b.path("src/calculator.zig"),
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addLibrary(.{
        .name = "calculator",
        .root_module = calculator_module,
        .linkage = .static,
    });
    b.installArtifact(lib);

    const test_module = b.createModule(.{
            .root_source_file = b.path("test/calculator_test.zig"),
            .target = target,
            .optimize = optimize,
        });
    test_module.addImport("calculator", calculator_module);

    const tests = b.addTest(.{
        .root_module = test_module,
    });

    const run_tests = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run calculator unit tests");
    test_step.dependOn(&run_tests.step);
}
