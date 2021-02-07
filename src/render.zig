const std = @import("std");
const math = std.math;

const Framebuffer = @import("framebuffer.zig").Framebuffer;
const Map = @import("map.zig");
const Player = @import("player.zig").Player;
const Sprite = @import("sprite.zig");
const Texture = @import("texture.zig");
const utils = @import("utils.zig");

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

pub fn render(
    fb: *Framebuffer,
    map: *Map.Map,
    player: *Player,
    sprites: []Sprite.Sprite,
    walltex: *Texture.Texture,
    monstertex: *Texture.Texture,
) !void {
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
            // cap column height to 2000. The higher the number, the closer we can get to walls without distortion
            if (column_height > 2000) column_height = 2000;

            // draw textured wall
            const column: []u32 = walltex.getScaledColumn(texid, wallXTexcoord(walltex, x, y), column_height);
            defer std.heap.c_allocator.free(column);
            const pix_x: usize = fb.w / 2 + i; // drawing at the right side of the scrren => +fb.w/2
            j = 0;
            while (j < column_height) : (j += 1) { //  and j < fb.h
                const pix_y: isize = @intCast(isize, j + fb.h / 2) - @intCast(isize, column_height / 2);
                // we won't draw position outside framebuffer
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
