const std = @import("std");
const assert = std.debug.assert;
const log = std.log;

const c = @import("c.zig");
const utils = @import("utils.zig");

pub const Texture = struct {
    w: usize,
    h: usize,
    size: usize,
    cnt: usize,
    tex: []u32 = undefined,

    pub fn destructor(self: *Texture) void {
        const allocator = std.heap.c_allocator;
        allocator.free(self.tex);
    }

    pub fn get(self: *Texture, x: usize, y: usize, idx: usize) u32 {
        assert(idx < self.cnt);
        return self.tex[x + idx * self.size + y * self.w];
    }

    // TODO txcoord usize instead of isize?
    pub fn getScaledColumn(self: *Texture, texid: usize, texcoord: usize, column_height: usize) []u32 {
        assert(texcoord < self.size and texid < self.cnt);

        const allocator = std.heap.c_allocator;
        var column = allocator.alloc(u32, column_height) catch unreachable;

        var y: usize = 0;
        while (y < column_height) : (y += 1) {
            column[y] = self.get(texcoord, (y * self.size) / column_height, texid);
        }
        return column;
    }
};

// TODO optional pointer?
pub fn loadTexture(filename: [*:0]const u8) Texture {
    var nchannels: c_int = -1;
    var w: c_int = undefined;
    var h: c_int = undefined;
    const pixmap: ?[*]u8 = c.stbi_load(filename, &w, &h, &nchannels, 0);
    if (pixmap == null) {
        log.err("loadTexture: can't load the texture ({s}).", .{filename});
        // return false;
    }
    defer c.stbi_image_free(pixmap.?);

    if (4 != nchannels) {
        log.err("loadTexture: the texture must be a 32 bit image ({s}).", .{filename});
        // return false;
    }

    const tex_cnt: usize = @intCast(usize, @divTrunc(w, h));
    const tex_size: usize = @intCast(usize, w) / tex_cnt;
    if (w != @intCast(usize, h) * tex_cnt) {
        log.err("loadTexture: the texture file must contain N square textures packed horizontally ({s}).", .{filename});
        // return false;
    }

    // read the texture data
    const allocator = std.heap.c_allocator;
    var texture = allocator.alloc(u32, @intCast(usize, h * w)) catch {
        log.err("loadTexture: texture memory allocation failed ({s}).", .{filename});
        return Texture{ .w = 0, .h = 0, .size = 0, .cnt = 0 };
    };
    var i: usize = 0;
    while (i < h) : (i += 1) {
        var j: usize = 0;
        while (j < w) : (j += 1) {
            const ind: usize = i * @intCast(usize, w) + j;
            texture[ind] = utils.packColorA(
                pixmap.?[ind * 4],
                pixmap.?[ind * 4 + 1],
                pixmap.?[ind * 4 + 2],
                pixmap.?[ind * 4 + 3],
            );
        }
    }

    return Texture{
        .w = @intCast(usize, w),
        .h = @intCast(usize, h),
        .size = tex_size,
        .cnt = tex_cnt,
        .tex = texture,
    };
}
