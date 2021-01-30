const std = @import("std");
const c = std.c; // for file output
const assert = std.debug.assert;
const print = std.debug.print;

const map_data = @embedFile("map");

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

fn itoa(val: usize) [32]u8 {
    var int: usize = val;
    var i: usize = 0;
    var ret = [_]u8{0} ** 32;
    // separate number, char by char
    while (int > 0) : ({
        int /= 10;
        i += 1;
    }) {
        ret[i] = @intCast(u8, (int % 10) + 48);
    }

    // invert the resulting chars
    var j: usize = 0;
    while (j < i / 2) : (j += 1) {
        const tmp: u8 = ret[j];
        ret[j] = ret[i - j - 1];
        ret[i - j - 1] = tmp;
    }

    return ret;
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
    _ = c.fwrite("P6\n", @sizeOf(u8), 3, f.?);
    const w_str = itoa(w);
    var w_str_len: usize = 0;
    while (w_str[w_str_len] != 0) : (w_str_len += 1) {}
    _ = c.fwrite(&w_str, @sizeOf(u8), w_str_len, f.?);
    _ = c.fwrite(" ", @sizeOf(u8), 1, f.?);
    const h_str = itoa(h);
    var h_str_len: usize = 0;
    while (h_str[h_str_len] != 0) : (h_str_len += 1) {}
    _ = c.fwrite(&h_str, @sizeOf(u8), h_str_len, f.?);
    _ = c.fwrite(" 255\n", @sizeOf(u8), 5, f.?);

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

fn draw_rectangle(img: []u32, img_w: usize, img_h: usize, x: usize, y: usize, w: usize, h: usize, color: u32) void {
    assert(img.len == img_w * img_h);
    var i: usize = 0;
    while (i < h) : (i += 1) {
        var j: usize = 0;
        while (j < w) : (j += 1) {
            const cx: usize = x + j;
            const cy: usize = y + i;
            // no need to check negative values
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

pub fn main() !void {
    const win_w: usize = 1024; // image width
    const win_h: usize = 512; // image height
    // the image itself, initialized to red
    var framebuffer = [_]u32{packColor(255, 255, 255)} ** (win_w * win_h);
    // read map
    var map_w: usize = 0;
    var map_h: usize = 0;
    const map = readMap(&map_w, &map_h);

    var player_x: f32 = 3.456; // player x
    var player_y: f32 = 2.345; // player y
    var player_a: f32 = 1.523; // player view direction
    const fov: f32 = std.math.pi / 3.0; // field of view

    // draw map
    const rect_w: usize = win_w / (map_w * 2);
    const rect_h: usize = win_h / map_h;
    {
        var i: usize = 0;
        while (i < map_h) : (i += 1) {
            var j: usize = 0;
            while (j < map_w) : (j += 1) {
                if (map[i * map_w + j] == ' ') continue; // skip empty spaces
                const rect_x: usize = j * rect_w;
                const rect_y: usize = i * rect_h;
                draw_rectangle(&framebuffer, win_w, win_h, rect_x, rect_y, rect_w, rect_h, packColor(0, 255, 255));
            }
        }
    }
    // draw the player on the map
    draw_rectangle(&framebuffer, win_w, win_h, @floatToInt(usize, player_x * @intToFloat(f32, rect_w)), @floatToInt(usize, player_y * @intToFloat(f32, rect_h)), 5, 5, packColor(255, 255, 255));

    var i: usize = 0;
    while (i < win_w / 2) : (i += 1) { // draw the visibility cone
        const angle: f32 = player_a - fov / 2.0 + fov * @intToFloat(f32, i) / @intToFloat(f32, win_w / 2);

        // laser range finder
        var t: f32 = 0;
        while (t < 20) : (t += 0.05) {
            const cx: f32 = player_x + t * @cos(angle);
            const cy: f32 = player_y + t * @sin(angle);

            const pix_x: usize = @floatToInt(usize, cx * @intToFloat(f32, rect_w));
            const pix_y: usize = @floatToInt(usize, cy * @intToFloat(f32, rect_h));
            // this draws the visibility cone
            framebuffer[pix_y * win_w + pix_x] = packColor(160, 160, 160);

            // our ray touches a wall, so draw the vertical column to create an
            // illusion of 3D
            if (map[@floatToInt(usize, cx) + @floatToInt(usize, cy) * map_w] != ' ') { // hit obstacle
                const column_height: usize = @floatToInt(usize, @intToFloat(f32, win_h) / t);
                draw_rectangle(&framebuffer, win_w, win_h, win_w / 2 + i, win_h / 2 - column_height / 2, 1, column_height, packColor(41, 47, 54));
                break;
            }
        }
    }

    drop_ppm_image("./out.ppm", &framebuffer, win_w, win_h);
}
