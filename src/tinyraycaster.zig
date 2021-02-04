const std = @import("std");
const c = @import("c.zig");
const assert = std.debug.assert;
const log = std.log;
const fs = std.fs;

const Framebuffer = @import("framebuffer.zig").Framebuffer;

pub extern "c" fn SDL_SetRelativeMouseMode(enabled: c_int) c_int;

const map_data = @embedFile("../assets/map");

inline fn packColor(r: u32, g: u32, b: u32) u32 {
    return (255 << 24) + (b << 16) + (g << 8) + r;
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
        _ = buf_writer.writeAll(color[0..3]) catch return false;
    }

    buf.flush() catch return false;
    f.close();

    return true;
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

fn loadTexture(filename: [*:0]const u8, texture: *[]u32, tex_size: *usize, tex_cnt: *usize) bool {
    var nchannels: c_int = -1;
    var w: c_int = undefined;
    var h: c_int = undefined;
    const pixmap: ?[*]u8 = c.stbi_load(filename, &w, &h, &nchannels, 0);
    if (pixmap == null) {
        log.err("loadTexture: can't load the texture ({s}).", .{filename});
        return false;
    }
    defer c.stbi_image_free(pixmap.?);

    if (4 != nchannels) {
        log.err("loadTexture: the texture must be a 32 bit image ({s}).", .{filename});
        return false;
    }

    tex_cnt.* = @intCast(usize, @divTrunc(w, h));
    tex_size.* = @intCast(usize, w) / tex_cnt.*;
    if (w != @intCast(usize, h) * tex_cnt.*) {
        log.err("loadTexture: the texture file must contain N square textures packed horizontally ({s}).", .{filename});
        return false;
    }

    texture.* = std.heap.c_allocator.alloc(u32, @intCast(usize, h * w)) catch {
        log.err("loadTexture: texture memory allocation failed ({s}).", .{filename});
        return false;
    };
    var i: usize = 0;
    while (i < h) : (i += 1) {
        var j: usize = 0;
        while (j < w) : (j += 1) {
            const ind: usize = i * @intCast(usize, w) + j;
            texture.*[ind] = packColor_a(pixmap.?[ind * 4], pixmap.?[ind * 4 + 1], pixmap.?[ind * 4 + 2], pixmap.?[ind * 4 + 3]);
        }
    }

    return true;
}

// TODO txcoord usize instead of isize?
fn textureColumn(img: *[]u32, texsize: usize, ntextures: usize, texid: usize, texcoord: usize, column_height: usize) *[]u32 {
    const img_w: usize = texsize * ntextures;
    const img_h: usize = texsize;
    assert(texcoord < texsize and texid < ntextures);

    var column = std.heap.c_allocator.alloc(u32, column_height) catch unreachable;

    var y: usize = 0;
    while (y < column_height) : (y += 1) {
        const pix_x: usize = texid * texsize + texcoord;
        const pix_y: usize = (y * texsize) / column_height;
        column[y] = img.*[pix_x + pix_y * img_w];
    }
    return &column;
}

pub fn main() !u8 {
    var walltex: []u32 = undefined;
    var walltex_size: usize = undefined;
    var walltex_cnt: usize = undefined;
    if (!loadTexture("assets/walltext.png", &walltex, &walltex_size, &walltex_cnt))
        return 1;
    defer std.heap.c_allocator.free(walltex);

    const win_w: usize = 1024; // image width
    const win_h: usize = 512; // image height
    // the image itself, initialized to white
    var framebuffer = Framebuffer{
        .win_w = 1024,
        .win_h = 512,
    };
    try framebuffer.init();
    defer framebuffer.destructor();
    framebuffer.clear(packColor(255, 255, 255));
    // read map
    var map_w: usize = 0;
    var map_h: usize = 0;
    const map = readMap(&map_w, &map_h);
    // player options
    var player_x: f32 = 3.456; // player x
    var player_y: f32 = 2.345; // player y
    var player_a: f32 = 1.523; // player view direction
    const fov: f32 = std.math.pi / 3.0; // field of view

    // draw map
    const rect_w: usize = win_w / (map_w * 2);
    const rect_h: usize = win_h / map_h;

    // clear the screen
    framebuffer.clear(packColor(255, 255, 255));

    // draw the map
    {
        var i: usize = 0;
        while (i < map_h) : (i += 1) {
            var j: usize = 0;
            while (j < map_w) : (j += 1) {
                if (map[i * map_w + j] == ' ') continue; // skip empty spaces
                const rect_x: usize = j * rect_w;
                const rect_y: usize = i * rect_h;
                const texid: u32 = map[i * map_w + j] - '0';
                assert(texid < walltex_cnt);
                framebuffer.drawRectangle(rect_x, rect_y, rect_w, rect_h, walltex[texid * walltex_size]);
            }
        }
    }

    // draw the player on the map
    framebuffer.drawRectangle(@floatToInt(usize, player_x * @intToFloat(f32, rect_w)), @floatToInt(usize, player_y * @intToFloat(f32, rect_h)), 5, 5, packColor(0, 255, 0));

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

                var pix_x: usize = @floatToInt(usize, cx * @intToFloat(f32, rect_w));
                var pix_y: usize = @floatToInt(usize, cy * @intToFloat(f32, rect_h));
                // this draws the visibility cone
                framebuffer.setPixel(pix_x, pix_y, packColor(160, 160, 160));

                // our ray touches a wall, so draw the vertical column to create an
                // illusion of 3D
                const mape: u32 = map[@floatToInt(usize, cx) + @floatToInt(usize, cy) * map_w];
                if (mape != ' ') { // hit obstacle
                    const texid = mape - '0';
                    assert(texid < walltex_cnt);
                    const column_height: usize = @floatToInt(usize, @intToFloat(f32, win_h) / (t * @cos(angle - player_a)));

                    const hitx: f32 = cx - @floor(cx + 0.5); // hitx and hity contain (signed) fractional parts of cx and cy,
                    const hity: f32 = cy - @floor(cy + 0.5); // between [-0.5, 0.5], one is very close to 0
                    var x_texcoord: isize = @floatToInt(isize, hitx * @intToFloat(f32, walltex_size));

                    // we need to determine whether we hit a "vertical" or
                    // a "horizontal" wall (w.r.t the map)
                    if (@fabs(hity) > @fabs(hitx))
                        x_texcoord = @floatToInt(isize, hity * @intToFloat(f32, walltex_size));
                    if (x_texcoord < 0)
                        x_texcoord += @intCast(isize, walltex_size); // do not forget x_texcoord can be negative, fix that

                    // draw textured wall
                    const column: *[]u32 = textureColumn(&walltex, walltex_size, walltex_cnt, texid, @intCast(usize, x_texcoord), column_height);
                    defer std.heap.c_allocator.free(column.*);

                    pix_x = win_w / 2 + i;
                    var j: usize = 0;
                    while (j < column_height) : (j += 1) {
                        pix_y = j + win_h / 2 - column_height / 2;
                        if (pix_y < 0 or pix_y >= win_h)
                            continue;
                        framebuffer.setPixel(pix_x, pix_y, column.*[j]);
                    }

                    break;
                }
            }
        }
    }

    _ = c.SDL_Init(c.SDL_INIT_VIDEO);
    defer c.SDL_Quit();
    var window: ?*c.SDL_Window =
        c.SDL_CreateWindow("TinyRayCaster", c.SDL_WINDOWPOS_UNDEFINED, c.SDL_WINDOWPOS_UNDEFINED, win_w, win_h, 0);
    // SDL2 ops
    _ = c.SDL_ShowCursor(c.SDL_DISABLE);
    _ = SDL_SetRelativeMouseMode(c.SDL_TRUE);

    var renderer: ?*c.SDL_Renderer = c.SDL_CreateRenderer(window.?, -1, 0);
    var texture: ?*c.SDL_Texture =
        c.SDL_CreateTexture(renderer.?, c.SDL_PIXELFORMAT_ABGR8888, c.SDL_TEXTUREACCESS_STATIC, win_w, win_h);

    var quit: bool = false;
    var event: c.SDL_Event = undefined;
    while (!quit) {
        _ = c.SDL_UpdateTexture(texture.?, null, framebuffer.buffer.ptr, win_w * @sizeOf(u32));

        _ = c.SDL_WaitEvent(&event);
        switch (event.type) {
            c.SDL_KEYDOWN => {
                switch (event.key.keysym.sym) {
                    c.SDLK_PRINTSCREEN => {
                        // output resulting image
                        if (!dropPpmImage("out.ppm", framebuffer.buffer, win_w, win_h))
                            log.err("dropPpmImage: Saving the image to a file failed!", .{});
                    },
                    c.SDLK_q, c.SDLK_ESCAPE => {
                        quit = true;
                    },
                    else => {},
                }
            },
            c.SDL_MOUSEMOTION => {
                // std.debug.print("mouse move {} {}\n", .{ event.motion.xrel, event.motion.yrel });
            },
            c.SDL_QUIT => {
                quit = true;
            },
            else => {},
        }

        _ = c.SDL_RenderClear(renderer.?);
        _ = c.SDL_RenderCopy(renderer.?, texture.?, null, null);
        c.SDL_RenderPresent(renderer.?);
    }

    c.SDL_DestroyTexture(texture.?);
    c.SDL_DestroyRenderer(renderer.?);
    c.SDL_DestroyWindow(window.?);

    return 0;
}
