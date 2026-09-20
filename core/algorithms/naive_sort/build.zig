const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const naive_sort_module = b.createModule(.{
        .root_source_file = b.path("src/naive_sort.zig"),
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addLibrary(.{
        .name = "naive_sort",
        .root_module = naive_sort_module,
        .linkage = .static,
    });
    b.installArtifact(lib);

    const test_module = b.createModule(.{
        .root_source_file = b.path("test/naive_sort_test.zig"),
        .target = target,
        .optimize = optimize,
    });
    test_module.addImport("naive_sort", naive_sort_module);

    const tests = b.addTest(.{
        .root_module = test_module,
    });

    const run_tests = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run naive_sort unit tests");
    test_step.dependOn(&run_tests.step);
}
