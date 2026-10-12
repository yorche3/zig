const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const data_structures_basics_module = b.createModule(.{
        .root_source_file = b.path("src/data_structures_basics.zig"),
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addLibrary(.{
        .name = "data_structures_basics",
        .root_module = data_structures_basics_module,
        .linkage = .static,
    });
    b.installArtifact(lib);

    const test_module = b.createModule(.{
        .root_source_file = b.path("test/data_structures_basics_test.zig"),
        .target = target,
        .optimize = optimize,
    });
    test_module.addImport("data_structures_basics", data_structures_basics_module);

    const tests = b.addTest(.{
        .root_module = test_module,
    });
    const run_tests = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run data_structures_basics unit tests");
    test_step.dependOn(&run_tests.step);
}
