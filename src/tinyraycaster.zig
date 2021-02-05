const std = @import("std");
const c = @import("c.zig");
const assert = std.debug.assert;
const log = std.log;

const Framebuffer = @import("framebuffer.zig").Framebuffer;
const utils = @import("utils.zig");
const Map = @import("map.zig");
const Player = @import("player.zig").Player;

pub extern "c" fn SDL_SetRelativeMouseMode(enabled: c_int) c_int;

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
            texture.*[ind] = utils.packColorA(pixmap.?[ind * 4], pixmap.?[ind * 4 + 1], pixmap.?[ind * 4 + 2], pixmap.?[ind * 4 + 3]);
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
    framebuffer.clear(utils.packColor(255, 255, 255));
    // read map
    var map = Map.readMap();
    defer map.destructor();
    // player options
    var player = Player{
        .x = 3.456,
        .y = 2.345,
        .angle = 1.523,
        .fov = std.math.pi / 3.0,
    };

    // draw map
    const rect_w: usize = win_w / (map.w * 2);
    const rect_h: usize = win_h / map.h;
    // clear the screen
    framebuffer.clear(utils.packColor(255, 255, 255));
    {
        var i: usize = 0;
        while (i < map.h) : (i += 1) {
            var j: usize = 0;
            while (j < map.w) : (j += 1) {
                if (map.isEmpty(j, i)) continue; // skip empty spaces
                const rect_x: usize = j * rect_w;
                const rect_y: usize = i * rect_h;
                const texid: u32 = map.get(j, i);
                assert(texid < walltex_cnt);
                framebuffer.drawRectangle(rect_x, rect_y, rect_w, rect_h, walltex[texid * walltex_size]);
            }
        }
    }

    // draw the player on the map
    framebuffer.drawRectangle(@floatToInt(usize, player.x * @intToFloat(f32, rect_w)), @floatToInt(usize, player.y * @intToFloat(f32, rect_h)), 5, 5, utils.packColor(0, 255, 0));

    // draw the visibility cone AND the "3D" view
    {
        var i: usize = 0;
        while (i < win_w / 2) : (i += 1) { // draw the visibility cone
            const angle: f32 = player.angle - player.fov / 2.0 + player.fov * @intToFloat(f32, i) / @intToFloat(f32, win_w / 2);

            // laser range finder
            var t: f32 = 0;
            while (t < 20) : (t += 0.01) {
                const cx: f32 = player.x + t * @cos(angle);
                const cy: f32 = player.y + t * @sin(angle);

                var pix_x: usize = @floatToInt(usize, cx * @intToFloat(f32, rect_w));
                var pix_y: usize = @floatToInt(usize, cy * @intToFloat(f32, rect_h));
                // this draws the visibility cone
                framebuffer.setPixel(pix_x, pix_y, utils.packColor(160, 160, 160));

                // our ray touches a wall, so draw the vertical column to create an
                // illusion of 3D
                const map_x: usize = @floatToInt(usize, cx);
                const map_y: usize = @floatToInt(usize, cy);
                if (!map.isEmpty(map_x, map_y)) { // hit obstacle
                    const texid = map.get(map_x, map_y);
                    assert(texid < walltex_cnt);
                    const column_height: usize = @floatToInt(usize, @intToFloat(f32, win_h) / (t * @cos(angle - player.angle)));

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
                        log.info("Print screen.", .{});
                        // output resulting image
                        if (!framebuffer.dropPpmImage("out.ppm"))
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
