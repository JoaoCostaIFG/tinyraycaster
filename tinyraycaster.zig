const std = @import("std");
const c = std.c; // for file output
const assert = std.debug.assert;
const print = std.debug.print;

// TODO why bother with alpha ?
inline fn packColor(r: u32, g: u32, b: u32) u32 {
    return (b << 16) + (g << 8) + r;
}

inline fn packColor_a(r: u32, g: u32, b: u32, a: u32) u32 {
    return (a << 24) + (b << 16) + (g << 8) + r;
}

inline fn unpack_color(color: u32, r: *u8, g: *u8, b: *u8, a: *u8) void {
    r.* = @intCast(u8, color & 255);
    g.* = @intCast(u8, (color >> 8) & 255);
    b.* = @intCast(u8, (color >> 16) & 255);
    a.* = @intCast(u8, (color >> 24) & 255);
}

fn drop_ppm_image(filename: [*:0]const u8, image: []const u32, w: usize, h: usize) void {
    assert(image.len == w * h);

    // open output file for NULL
    var f: ?*c.FILE = c.fopen(filename, "wb+");
    if (f == null) {
        print("Opening file {s} failed!\n", .{filename});
        return;
    }
    // show file as ppm
    // TODO actually write w and h instead of hardcode
    _ = c.fwrite("P6\n512 512\n255\n", @sizeOf(u8), 15, f.?);

    // this doesn't work because the file doesn't use alpha (would need u24 => weird)
    // var k = @ptrCast([*]const u8, image);
    // _ = c.fwrite(k, @sizeOf(u32), w * h, f.?);

    var i: usize = 0;
    var color: [4]u8 = undefined;
    while (i < w * h) : (i += 1) {
        unpack_color(image[i], &color[0], &color[1], &color[2], &color[3]);
        _ = c.fwrite(&color, @sizeOf(u8), 3, f.?);
    }

    _ = c.fclose(f.?);
}

pub fn main() !void {
    const win_w: usize = 512; // image width
    const win_h: usize = 512; // image height
    // the image itself, initialized to red
    var framebuffer = [_]u32{255} ** (win_w * win_h);

    // TODO I changed i with j (intended). DON'T FORGET IT
    // fill the screen with color gradients
    {
        @setFloatMode(@import("builtin").FloatMode.Optimized);
        var i: usize = 0;
        while (i < win_h) : (i += 1) {
            var j: usize = 0;
            while (j < win_w) : (j += 1) {
                const r: u8 = @intCast(u8, 255 * i / win_h);
                const g: u8 = @intCast(u8, 255 * j / win_w);
                const b: u8 = 0; // (r + g) / 2.0;
                framebuffer[i * win_w + j] = packColor(r, g, b);
            }
        }
    }

    drop_ppm_image("./out.ppm", &framebuffer, win_w, win_h);
}
