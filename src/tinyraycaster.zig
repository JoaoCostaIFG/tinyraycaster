const std = @import("std");
const c = @import("c.zig");
const ArrayList = std.ArrayList;
const assert = std.debug.assert;
const log = std.log;
const math = std.math;
const Thread = std.Thread;

const Framebuffer = @import("framebuffer.zig").Framebuffer;
const Map = @import("map.zig");
const Player = @import("player.zig").Player;
const Sprite = @import("sprite.zig");
const Texture = @import("texture.zig");
const utils = @import("utils.zig");

pub extern "c" fn SDL_SetRelativeMouseMode(enabled: c_int) c_int;

var quit: bool = false;

fn wallXTexcoord(walltex: *Texture.Texture, hitx: f32, hity: f32) usize {
    const x: f32 = hitx - @floor(hitx + 0.5); // hitx and hity contain (signed) fractional parts of cx and cy,
    const y: f32 = hity - @floor(hity + 0.5); // between [-0.5, 0.5], one is very close to 0
    var x_texcoord: isize = @floatToInt(isize, x * @intToFloat(f32, walltex.size));

    // we need to determine whether we hit a "vertical" or
    // a "horizontal" wall (w.r.t the map)
    if (@fabs(y) > @fabs(x))
        x_texcoord = @floatToInt(isize, y * @intToFloat(f32, walltex.size));
    if (x_texcoord < 0)
        x_texcoord += @intCast(isize, walltex.*.size); // do not forget x_texcoord can be negative, fix that

    return @intCast(usize, x_texcoord);
}

fn drawMap(fb: *Framebuffer, map: *Map.Map, walltex: *Texture.Texture, sprites: []Sprite.Sprite, cell_w: usize, cell_h: usize) void {
    var i: usize = 0;
    while (i < map.h) : (i += 1) {
        var j: usize = 0;
        while (j < map.w) : (j += 1) {
            if (map.isEmpty(j, i)) continue; // skip empty spaces
            const rect_x: usize = j * cell_w;
            const rect_y: usize = i * cell_h;
            const texid: u32 = map.get(j, i);
            // the color is taken from the first (upper left) pixel of the texture, texid
            fb.drawRectangle(rect_x, rect_y, cell_w, cell_h, walltex.get(0, 0, texid));
        }
    }

    // show sprite on the map
    i = 0;
    while (i < sprites.len) : (i += 1) {
        const sprite = &sprites[i];
        fb.drawRectangle(
            @floatToInt(usize, @round(sprite.x * @intToFloat(f32, cell_w) - 3)),
            @floatToInt(usize, @round(sprite.y * @intToFloat(f32, cell_h) - 3)),
            6,
            6,
            utils.packColor(255, 0, 0),
        );
    }
}

fn drawSprite(sprite: *Sprite.Sprite, depth_buffer: []f32, fb: *Framebuffer, player: *Player, spritestex: *Texture.Texture) void {
    // absolute direction from the player to the sprite (in radians)
    var sprite_dir: f32 = math.atan2(f32, sprite.y - player.y, sprite.x - player.x);
    // remove unncesessary periods from the relative direction
    while (sprite_dir - player.angle > math.pi) sprite_dir -= math.tau;
    while (sprite_dir - player.angle < -math.pi) sprite_dir += math.tau;

    // screen sprite size
    var sprite_screen_size: usize = @floatToInt(usize, @intToFloat(f32, fb.h) / sprite.player_dist);
    if (sprite_screen_size > 1000) sprite_screen_size = 1000; // cap sprite size to 1000
    // the 3D view takes only a half of the framebuffer
    const fb_w2: f32 = @intToFloat(f32, fb.w) / 2;
    const h_offset: isize = @floatToInt(isize, (sprite_dir - player.angle) * fb_w2 / player.fov + fb_w2 / 2 -
        @intToFloat(f32, sprite_screen_size) / 2);
    const v_offset: isize = @intCast(isize, fb.h / 2) - @intCast(isize, sprite_screen_size / 2);

    var i: usize = 0;
    while (i < sprite_screen_size) : (i += 1) {
        // this sprite column is occluded
        if (h_offset + @intCast(isize, i) < 0 or
            h_offset + @intCast(isize, i) >= fb.w / 2 or
            depth_buffer[@intCast(usize, h_offset + @intCast(isize, i))] < sprite.player_dist)
            continue;

        var j: usize = 0;
        while (j < sprite_screen_size) : (j += 1) {
            if (v_offset + @intCast(isize, j) < 0 or
                v_offset + @intCast(isize, j) >= fb.h)
                continue;
            const color: u32 = spritestex.get(
                i * spritestex.size / sprite_screen_size,
                j * spritestex.size / sprite_screen_size,
                sprite.tex_id,
            );
            var color_comps: [4]u8 = undefined;
            utils.unpackColor(color, &color_comps[0], &color_comps[1], &color_comps[2], &color_comps[3]);
            if (color_comps[3] > 128)
                fb.setPixel(
                    @intCast(usize, @intCast(isize, fb.w / 2) + h_offset + @intCast(isize, i)),
                    @intCast(usize, v_offset + @intCast(isize, j)),
                    color,
                );
        }
    }
}

fn render(fb: *Framebuffer, map: *Map.Map, player: *Player, sprites: []Sprite.Sprite, walltex: *Texture.Texture, monstertex: *Texture.Texture) !void {
    fb.clear(utils.packColor(255, 255, 255)); // clear the screen

    var i: usize = undefined;
    var j: usize = undefined;

    // size of one map cell on the screen
    const cell_w: usize = fb.w / (map.w * 2);
    const cell_h: usize = fb.h / map.h;

    // draw the visibility cone && the 3D view
    const allocator = std.heap.c_allocator;
    var depth_buffer = try allocator.alloc(f32, fb.w / 2);
    defer allocator.free(depth_buffer);
    std.mem.set(f32, depth_buffer, 1e3);

    i = 0;
    while (i < fb.w / 2) : (i += 1) { // draw the visibility cone && 3D view
        const angle: f32 = player.getRayAngle(@intToFloat(f32, i), @intToFloat(f32, fb.w) / 2.0);

        var t: f32 = 0;
        while (t < 20) : (t += 0.01) { // ray marching loop
            const x: f32 = player.x + t * @cos(angle);
            const y: f32 = player.y + t * @sin(angle);
            // this draws the visibility cone
            fb.setPixel(
                @floatToInt(usize, x * @intToFloat(f32, cell_w)),
                @floatToInt(usize, y * @intToFloat(f32, cell_h)),
                utils.packColor(190, 190, 190),
            );

            // proceed with the ray march if we don't hit anything
            if (map.isEmpty(@floatToInt(usize, x), @floatToInt(usize, y))) continue;

            // our ray touches a wall, so draw the vertical column to create an
            // illusion of 3D
            const texid = map.get(@floatToInt(usize, x), @floatToInt(usize, y));
            const dist: f32 = t * @cos(angle - player.angle);
            depth_buffer[i] = dist;

            if (dist == 0) continue; // avoid division by 0 (inside walls)
            var column_height: usize = @floatToInt(usize, @intToFloat(f32, fb.h) / dist);
            // if (column_height > fb.h) column_height = fb.h; // cap column height to framebuffer height
            if (column_height > 2000) column_height = 2000;

            // draw textured wall
            const column: []u32 = walltex.getScaledColumn(texid, wallXTexcoord(walltex, x, y), column_height);
            defer std.heap.c_allocator.free(column);

            const pix_x: usize = fb.w / 2 + i; // drawing at the right side of the scrren => +fb.w/2
            j = 0;
            while (j < column_height) : (j += 1) { //  and j < fb.h
                const pix_y: isize = @intCast(isize, j + fb.h / 2) - column_height / 2;
                if (pix_y >= 0 and pix_y < fb.h)
                    fb.setPixel(pix_x, @intCast(usize, pix_y), column[j]);
            }

            // the ray stops when it hits something
            break;
        }
    }

    i = 0;
    while (i < sprites.len) : (i += 1) {
        const sprite = &sprites[i];
        drawSprite(sprite, depth_buffer, fb, player, monstertex);
    }

    drawMap(fb, map, walltex, sprites, cell_w, cell_h);
}

const Args = struct {
    fb: *Framebuffer,
    map: *Map.Map,
    player: *Player,
    sprites: []Sprite.Sprite,
    walltex: *Texture.Texture,
    monstertex: *Texture.Texture,
    sdlRenderer: ?*c.SDL_Renderer,
    sdlTexture: ?*c.SDL_Texture,
};

fn renderLoop(args: Args) void {
    const fps = 60;

    while (!quit) {
        // sort sprites
        var i: usize = 0;
        while (i < args.sprites.len) : (i += 1) {
            const sprite = &args.sprites[i];
            // distance from the player to the sprite
            sprite.player_dist = math.sqrt(math.pow(f32, args.player.x - sprite.x, 2) +
                math.pow(f32, args.player.y - sprite.y, 2));
        }
        std.sort.sort(Sprite.Sprite, args.sprites, {}, Sprite.desc);

        render(args.fb, args.map, args.player, args.sprites, args.walltex, args.monstertex) catch continue;
        _ = c.SDL_UpdateTexture(
            args.sdlTexture.?,
            null,
            args.fb.buffer.ptr,
            @intCast(c_int, args.fb.w) * @sizeOf(u32),
        );

        _ = c.SDL_RenderClear(args.sdlRenderer.?);
        _ = c.SDL_RenderCopy(args.sdlRenderer.?, args.sdlTexture.?, null, null);
        c.SDL_RenderPresent(args.sdlRenderer.?);

        std.time.sleep(std.time.ns_per_s / 30);
    }
}

pub fn main() !u8 {
    // the image itself
    var framebuffer = Framebuffer{
        .w = 1024,
        .h = 512,
    };
    try framebuffer.init();
    defer framebuffer.destructor();
    // load textures
    var walltex = Texture.loadTexture("assets/walltext.png");
    defer walltex.destructor();
    var monstertex = Texture.loadTexture("assets/monsters.png");
    defer monstertex.destructor();
    // sprites
    var sprites = ArrayList(Sprite.Sprite).init(std.heap.c_allocator);
    defer sprites.deinit();
    try sprites.append(Sprite.Sprite{ .x = 3.523, .y = 3.812, .tex_id = 2 });
    try sprites.append(Sprite.Sprite{ .x = 1.834, .y = 8.765, .tex_id = 0 });
    try sprites.append(Sprite.Sprite{ .x = 5.323, .y = 5.365, .tex_id = 1 });
    try sprites.append(Sprite.Sprite{ .x = 14.32, .y = 13.36, .tex_id = 3 });
    try sprites.append(Sprite.Sprite{ .x = 4.123, .y = 10.76, .tex_id = 1 });

    // read map
    var map = Map.readMap();
    defer map.destructor();
    // player options
    var player = Player{
        .x = 3.456,
        .y = 2.345,
        .angle = 1.523, //math.pi / 2.0
        .fov = math.pi / 3.0,
    };

    // SDL2
    _ = c.SDL_Init(c.SDL_INIT_VIDEO);
    defer c.SDL_Quit();
    var window: ?*c.SDL_Window =
        c.SDL_CreateWindow(
        "TinyRayCaster",
        c.SDL_WINDOWPOS_UNDEFINED,
        c.SDL_WINDOWPOS_UNDEFINED,
        @intCast(c_int, framebuffer.w),
        @intCast(c_int, framebuffer.h),
        0,
    );
    // cursor options
    // _ = c.SDL_ShowCursor(c.SDL_DISABLE);
    // _ = SDL_SetRelativeMouseMode(c.SDL_TRUE);

    // TODO c.SDL_RENDERER_PRESENTVSYNC makes input slow (needs confirm ?)
    var renderer: ?*c.SDL_Renderer = c.SDL_CreateRenderer(window.?, -1, c.SDL_RENDERER_ACCELERATED | c.SDL_RENDERER_PRESENTVSYNC);
    var texture: ?*c.SDL_Texture =
        c.SDL_CreateTexture(
        renderer.?,
        c.SDL_PIXELFORMAT_ABGR8888,
        c.SDL_TEXTUREACCESS_STREAMING,
        @intCast(c_int, framebuffer.w),
        @intCast(c_int, framebuffer.h),
    );

    var renderThread = try Thread.spawn(Args{
        .fb = &framebuffer,
        .map = &map,
        .player = &player,
        .sprites = sprites.items,
        .walltex = &walltex,
        .monstertex = &monstertex,
        .sdlRenderer = renderer,
        .sdlTexture = texture,
    }, renderLoop);

    var event: c.SDL_Event = undefined;
    while (!quit) {
        _ = c.SDL_WaitEvent(&event);
        switch (event.type) {
            c.SDL_KEYDOWN => {
                switch (event.key.keysym.sym) {
                    c.SDLK_w => {
                        player.front();
                    },
                    c.SDLK_s => {
                        player.back();
                    },
                    c.SDLK_a => {
                        player.lookLeft();
                    },
                    c.SDLK_d => {
                        player.lookRight();
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
    }

    renderThread.wait();

    // SDL cleanup
    c.SDL_DestroyTexture(texture.?);
    c.SDL_DestroyRenderer(renderer.?);
    c.SDL_DestroyWindow(window.?);

    return 0;
}
