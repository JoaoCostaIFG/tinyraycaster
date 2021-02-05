const std = @import("std");
const c = @import("c.zig");
const assert = std.debug.assert;
const log = std.log;

const Framebuffer = @import("framebuffer.zig").Framebuffer;
const Map = @import("map.zig");
const Player = @import("player.zig").Player;
const Texture = @import("texture.zig");
const utils = @import("utils.zig");

pub extern "c" fn SDL_SetRelativeMouseMode(enabled: c_int) c_int;

fn wallXTexcoord(walltex: *Texture.Texture, x: f32, y: f32) usize {
    const hitx: f32 = x - @floor(x + 0.5); // hitx and hity contain (signed) fractional parts of cx and cy,
    const hity: f32 = y - @floor(y + 0.5); // between [-0.5, 0.5], one is very close to 0
    var x_texcoord: isize = @floatToInt(isize, hitx * @intToFloat(f32, walltex.*.size));

    // we need to determine whether we hit a "vertical" or
    // a "horizontal" wall (w.r.t the map)
    if (@fabs(hity) > @fabs(hitx))
        x_texcoord = @floatToInt(isize, hity * @intToFloat(f32, walltex.*.size));
    if (x_texcoord < 0)
        x_texcoord += @intCast(isize, walltex.*.size); // do not forget x_texcoord can be negative, fix that

    return @intCast(usize, x_texcoord);
}

fn render(framebuffer: *Framebuffer, map: *Map.Map, player: *Player, walltex: *Texture.Texture) void {
    framebuffer.clear(utils.packColor(255, 255, 255)); // clear the screen

    var i: usize = undefined;
    var j: usize = undefined;

    // draw map
    const rect_w: usize = framebuffer.win_w / (map.w * 2);
    const rect_h: usize = framebuffer.win_h / map.h;
    i = 0;
    while (i < map.h) : (i += 1) {
        j = 0;
        while (j < map.w) : (j += 1) {
            if (map.isEmpty(j, i)) continue; // skip empty spaces
            const rect_x: usize = j * rect_w;
            const rect_y: usize = i * rect_h;
            const texid: u32 = map.get(j, i);
            framebuffer.drawRectangle(rect_x, rect_y, rect_w, rect_h, walltex.get(0, 0, texid));
        }
    }

    // draw the player on the map
    // framebuffer.drawRectangle(
    // @floatToInt(usize, player.x * @intToFloat(f32, rect_w)),
    // @floatToInt(usize, player.y * @intToFloat(f32, rect_h)),
    // rect_w,
    // rect_h,
    // utils.packColor(0, 255, 0),
    // );

    // draw the visibility cone AND the "3D" view
    i = 0;
    while (i < framebuffer.win_w / 2) : (i += 1) { // draw the visibility cone
        const angle: f32 = player.getRayAngle(@intToFloat(f32, i), @intToFloat(f32, framebuffer.win_w) / 2.0);

        // laser range finder
        var t: f32 = 0;
        while (t < 20) : (t += 0.01) {
            const x: f32 = player.x + t * @cos(angle);
            const y: f32 = player.y + t * @sin(angle);

            // this draws the visibility cone
            framebuffer.*.setPixel(
                @floatToInt(usize, x * @intToFloat(f32, rect_w)),
                @floatToInt(usize, y * @intToFloat(f32, rect_h)),
                utils.packColor(160, 160, 160),
            );
            if (map.isEmpty(@floatToInt(usize, x), @floatToInt(usize, y))) continue;

            // our ray touches a wall, so draw the vertical column to create an
            // illusion of 3D
            const texid = map.get(@floatToInt(usize, x), @floatToInt(usize, y));
            const column_height: usize = @floatToInt(
                usize,
                @intToFloat(f32, framebuffer.win_h) / (t * @cos(angle - player.angle)),
            );

            // draw textured wall
            const column: []u32 = walltex.getScaledColumn(texid, wallXTexcoord(walltex, x, y), column_height);
            defer std.heap.page_allocator.free(column);

            const pix_x: usize = framebuffer.win_w / 2 + i;
            j = 0;
            while (j < column_height) : (j += 1) {
                const pix_y: usize = j + framebuffer.win_h / 2 - column_height / 2;
                if (pix_y >= 0 and pix_y < framebuffer.win_h)
                    framebuffer.setPixel(pix_x, pix_y, column[j]);
            }

            break;
        }
    }
}

pub fn main() !u8 {
    // the image itself
    var framebuffer = Framebuffer{
        .win_w = 1024,
        .win_h = 512,
    };
    try framebuffer.init();
    defer framebuffer.destructor();
    // load textures
    var walltex = Texture.loadTexture("assets/walltext.png");
    defer walltex.destructor();
    // read map
    var map = Map.readMap();
    defer map.destructor();
    // player options
    var player = Player{
        .x = 3.456,
        .y = 2.345,
        .speed = 0.1,
        .angle = 1.523,
        .fov = std.math.pi / 3.0,
    };

    render(&framebuffer, &map, &player, &walltex);

    // SDL2
    _ = c.SDL_Init(c.SDL_INIT_VIDEO);
    defer c.SDL_Quit();
    var window: ?*c.SDL_Window =
        c.SDL_CreateWindow(
        "TinyRayCaster",
        c.SDL_WINDOWPOS_UNDEFINED,
        c.SDL_WINDOWPOS_UNDEFINED,
        @intCast(c_int, framebuffer.win_w),
        @intCast(c_int, framebuffer.win_h),
        0,
    );
    // cursor options
    _ = c.SDL_ShowCursor(c.SDL_DISABLE);
    _ = SDL_SetRelativeMouseMode(c.SDL_TRUE);

    var renderer: ?*c.SDL_Renderer = c.SDL_CreateRenderer(window.?, -1, 0);
    var texture: ?*c.SDL_Texture =
        c.SDL_CreateTexture(
        renderer.?,
        c.SDL_PIXELFORMAT_ABGR8888,
        c.SDL_TEXTUREACCESS_STATIC,
        @intCast(c_int, framebuffer.win_w),
        @intCast(c_int, framebuffer.win_h),
    );

    var quit: bool = false;
    var event: c.SDL_Event = undefined;
    while (!quit) {
        _ = c.SDL_UpdateTexture(
            texture.?,
            null,
            framebuffer.buffer.ptr,
            @intCast(c_int, framebuffer.win_w) * @sizeOf(u32),
        );

        _ = c.SDL_WaitEvent(&event);
        switch (event.type) {
            c.SDL_KEYDOWN => {
                switch (event.key.keysym.sym) {
                    c.SDLK_w => {
                        player.up();
                    },
                    c.SDLK_s => {
                        player.down();
                    },
                    c.SDLK_a => {
                        player.left();
                    },
                    c.SDLK_d => {
                        player.right();
                    },
                    c.SDLK_n => {
                        render(&framebuffer, &map, &player, &walltex);
                    },
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
