const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("tinyraycaster", "src/tinyraycaster.zig");
    // exe.setOutputDir(".");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.addIncludeDir("./stb_image-2.26");
    exe.linkSystemLibrary("SDL2");
    exe.linkLibC();
    exe.addCSourceFile("./stb_image-2.26/stb_image_impl.c", &[_][]const u8{"-std=c99"});

    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
