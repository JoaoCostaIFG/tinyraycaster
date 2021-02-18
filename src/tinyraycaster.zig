const std = @import("std");
const ArrayList = std.ArrayList;
const assert = std.debug.assert;
const log = std.log;
const math = std.math;
const Thread = std.Thread;
const c = @import("c.zig");

const Framebuffer = @import("framebuffer.zig").Framebuffer;
const Map = @import("map.zig");
const Player = @import("player.zig");
const render = @import("render.zig").render;
const Sprite = @import("sprite.zig");
const Texture = @import("texture.zig");
const utils = @import("utils.zig");

pub extern "c" fn SDL_SetRelativeMouseMode(enabled: c_int) c_int;

const GameState = struct {
    fb: *Framebuffer,
    map: *Map.Map,
    player: *Player.Player,
    sprites: *ArrayList(Sprite.Sprite),
    walltex: *Texture.Texture,
    monstertex: *Texture.Texture,
    sdlRenderer: ?*c.SDL_Renderer,
    sdlTexture: ?*c.SDL_Texture,
};

var quit: bool = false;
var kbd = [_]bool{ false, false, false, false }; // front, back, left, right
var mouse = [_]i32{ 0, 0 }; // left, right

fn movePlayer(player: *Player.Player) void {
    // player movement direction
    // TODO deltatime (use timer)
    var move: i8 = @enumToInt(Player.Direction.stop);
    if (kbd[0]) move += @enumToInt(Player.Direction.front);
    if (kbd[1]) move += @enumToInt(Player.Direction.back);
    if (kbd[2]) move += @enumToInt(Player.Direction.left);
    if (kbd[3]) move += @enumToInt(Player.Direction.right);

    player.move(@intToEnum(Player.Direction, move));
}

fn moveCamera(player: *Player.Player) void {
    player.look(@divFloor(mouse[0], 10));
    mouse[0] = 0;
    mouse[1] = 0;
}

fn renderLoop(gs: GameState) void {
    const fps = 60;
    const sleep_len = std.time.ns_per_s / fps;

    // TODO deltatime (use Timer)
    while (!quit) {
        movePlayer(gs.player);
        moveCamera(gs.player);

        // sort sprites
        var i: usize = 0;
        while (i < gs.sprites.items.len) : (i += 1) {
            const sprite = &gs.sprites.items[i];
            // distance from the player to the sprite
            sprite.player_dist = math.sqrt(math.pow(f32, gs.player.x - sprite.x, 2) +
                math.pow(f32, gs.player.y - sprite.y, 2));
        }
        std.sort.sort(Sprite.Sprite, gs.sprites.items, {}, Sprite.desc);

        render(gs.fb, gs.map, gs.player, gs.sprites.items, gs.walltex, gs.monstertex) catch continue;
        _ = c.SDL_UpdateTexture(
            gs.sdlTexture.?,
            null,
            gs.fb.buffer.ptr,
            @intCast(c_int, gs.fb.w) * @sizeOf(u32),
        );

        _ = c.SDL_RenderClear(gs.sdlRenderer.?);
        _ = c.SDL_RenderCopy(gs.sdlRenderer.?, gs.sdlTexture.?, null, null);
        c.SDL_RenderPresent(gs.sdlRenderer.?);

        std.time.sleep(sleep_len);
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
    var player = Player.Player{
        .x = 3.456,
        .y = 2.345,
        .angle = math.pi / 2.0,
        .fov = math.pi / 3.0,
        .a_speed = math.pi / 100.0,
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
    // don't show mouse cursor and select relative mouse input
    _ = SDL_SetRelativeMouseMode(c.SDL_TRUE);

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

    var renderThread = try Thread.spawn(GameState{
        .fb = &framebuffer,
        .map = &map,
        .player = &player,
        .sprites = &sprites,
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
                        kbd[0] = true;
                    },
                    c.SDLK_s => {
                        kbd[1] = true;
                    },
                    c.SDLK_a => {
                        kbd[2] = true;
                    },
                    c.SDLK_d => {
                        kbd[3] = true;
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
            c.SDL_KEYUP => {
                switch (event.key.keysym.sym) {
                    c.SDLK_w => {
                        kbd[0] = false;
                    },
                    c.SDLK_s => {
                        kbd[1] = false;
                    },
                    c.SDLK_a => {
                        kbd[2] = false;
                    },
                    c.SDLK_d => {
                        kbd[3] = false;
                    },
                    else => {},
                }
            },
            c.SDL_MOUSEMOTION => {
                mouse[0] += event.motion.xrel;
                mouse[1] += event.motion.yrel;
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
