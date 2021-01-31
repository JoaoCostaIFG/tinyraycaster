const std = @import("std");
const assert = std.debug.assert;
const log = std.log;
const fs = std.fs;
// const stb = @cImport({
// @cDefine("STB_IMAGE_IMPLEMENTATION", {});
// @cInclude("stb_image.h");
// });

pub extern "c" fn rand() c_int;
// pub extern "c" fn sprintf(noalias __s: [*]u8, noalias __format: [*]const u8, ...) c_int;

const map_data = @embedFile("../res/map");

// TODO why bother with alpha ?
inline fn packColor(r: u32, g: u32, b: u32) u32 {
    return (b << 16) + (g << 8) + r;
}

inline fn packColor_a(r: u32, g: u32, b: u32, a: u32) u32 {
    return (a << 24) + (b << 16) + (g << 8) + r;
}

inline fn unpackColor(color: u32, r: *u8, g: *u8, b: *u8, a: *u8) void {
    r.* = @intCast(u8, color & 255);
    g.* = @intCast(u8, (color >> 8) & 255);
    b.* = @intCast(u8, (color >> 16) & 255);
    a.* = @intCast(u8, (color >> 24) & 255);
}

fn dropPpmImage(filename: []const u8, image: []const u32, w: usize, h: usize) bool {
    assert(image.len == w * h);

    // open file
    const cwd: fs.Dir = fs.cwd();
    const f: fs.File = cwd.createFile(filename, fs.File.CreateFlags{}) catch return false;
    // create a buffered writer
    var buf = std.io.bufferedWriter(f.writer());
    var buf_writer = buf.writer();

    // ppm file type meta-data
    buf_writer.print("P6\n{} {}\n255\n", .{ w, h }) catch return false;
    // write file data
    var i: usize = 0;
    var color: [4]u8 = undefined;
    while (i < w * h) : (i += 1) {
        unpackColor(image[i], &color[0], &color[1], &color[2], &color[3]);
        _ = buf_writer.write(color[0..3]) catch false;
    }

    buf.flush() catch return false;
    f.close();

    return true;
}

fn drawRectangle(img: []u32, img_w: usize, img_h: usize, x: usize, y: usize, w: usize, h: usize, color: u32) void {
    assert(img.len == img_w * img_h);
    var i: usize = 0;
    while (i < h) : (i += 1) {
        var j: usize = 0;
        while (j < w) : (j += 1) {
            const cx: usize = x + j;
            const cy: usize = y + i;
            // no need to check for negative values (unsigned vars)
            if (cx >= img_w or cy >= img_h)
                continue;
            img[cx + cy * img_w] = color;
        }
    }
}

pub fn readMap(map_w: *usize, map_h: *usize) [map_data.len]u8 {
    map_w.* = 0;
    map_h.* = 0;

    var map = [_]u8{0} ** map_data.len;
    var i: usize = 0;
    var j: usize = 0;
    while (i < map_data.len) : (i += 1) {
        if (map_data[i] != '\n') {
            map[j] = map_data[i];
            j += 1;
            map_w.* += 1;
        } else {
            map_h.* += 1;
        }
    }

    map_w.* /= map_h.*;
    return map;
}

fn loadTexture(filename: [*:0]const u8) bool {
    var nchannels: c_int = -1;
    var w: c_int = undefined;
    var h: c_int = undefined;

    // _ = stb.stbi_load("tchu", &w, &h, &[_][]const u8{}&nchannels, 0);
    // _ = stb.stbi_is_16_bit_from_file(null);

    return true;
}

pub fn main() !void {
    _ = loadTexture("../res/walltext.png");

    const win_w: usize = 1024; // image width
    const win_h: usize = 512; // image height
    // the image itself, initialized to red
    var framebuffer = [_]u32{packColor(255, 255, 255)} ** (win_w * win_h);
    // read map
    var map_w: usize = 0;
    var map_h: usize = 0;
    const map = readMap(&map_w, &map_h);
    // player options
    var player_x: f32 = 3.456; // player x
    var player_y: f32 = 2.345; // player y
    var player_a: f32 = 1.523; // player view direction
    const fov: f32 = std.math.pi / 3.0; // field of view

    // colors
    const ncolors: usize = 10;
    var colors = init: {
        var initial_value: [ncolors]u32 = undefined;
        for (initial_value) |*color| {
            color.* = packColor(@intCast(u32, rand()) % 255, @intCast(u32, rand()) % 255, @intCast(u32, rand()) % 255);
        }
        break :init initial_value;
    };

    // draw map
    const rect_w: usize = win_w / (map_w * 2);
    const rect_h: usize = win_h / map_h;

    // clear the screen
    framebuffer = [_]u32{packColor(255, 255, 255)} ** (win_w * win_h);

    // draw the map
    {
        var i: usize = 0;
        while (i < map_h) : (i += 1) {
            var j: usize = 0;
            while (j < map_w) : (j += 1) {
                if (map[i * map_w + j] == ' ') continue; // skip empty spaces
                const rect_x: usize = j * rect_w;
                const rect_y: usize = i * rect_h;
                const icolor: u32 = map[i * map_w + j] - '0';
                assert(icolor < ncolors);
                drawRectangle(&framebuffer, win_w, win_h, rect_x, rect_y, rect_w, rect_h, colors[icolor]);
            }
        }
    }

    // draw the player on the map
    drawRectangle(&framebuffer, win_w, win_h, @floatToInt(usize, player_x * @intToFloat(f32, rect_w)), @floatToInt(usize, player_y * @intToFloat(f32, rect_h)), 5, 5, packColor(0, 255, 0));

    // draw the visibility cone AND the "3D" view
    {
        var i: usize = 0;
        while (i < win_w / 2) : (i += 1) { // draw the visibility cone
            const angle: f32 = player_a - fov / 2.0 + fov * @intToFloat(f32, i) / @intToFloat(f32, win_w / 2);

            // laser range finder
            var t: f32 = 0;
            while (t < 20) : (t += 0.01) {
                const cx: f32 = player_x + t * @cos(angle);
                const cy: f32 = player_y + t * @sin(angle);

                const pix_x: usize = @floatToInt(usize, cx * @intToFloat(f32, rect_w));
                const pix_y: usize = @floatToInt(usize, cy * @intToFloat(f32, rect_h));
                // this draws the visibility cone
                framebuffer[pix_y * win_w + pix_x] = packColor(160, 160, 160);

                // our ray touches a wall, so draw the vertical column to create an
                // illusion of 3D
                const mape: u32 = map[@floatToInt(usize, cx) + @floatToInt(usize, cy) * map_w];
                if (mape != ' ') { // hit obstacle
                    const icolor = mape - '0';
                    assert(icolor < ncolors);
                    const column_height: usize = @floatToInt(usize, @intToFloat(f32, win_h) / (t * @cos(angle - player_a)));
                    drawRectangle(&framebuffer, win_w, win_h, win_w / 2 + i, win_h / 2 - column_height / 2, 1, column_height, colors[icolor]);
                    break;
                }
            }
        }
    }

    // output resulting image
    if (!dropPpmImage("out.ppm", &framebuffer, win_w, win_h))
        log.err("dropPpmImage: Saving the image to a file failed!", .{});
}
