const std = @import("std");
const fs = std.fs;

const utils = @import("utils.zig");

pub const Framebuffer = struct {
    win_w: usize,
    win_h: usize,
    buffer: []u32 = undefined,

    pub fn init(self: *Framebuffer) !void {
        const allocator = std.heap.page_allocator;
        self.buffer = try allocator.alloc(u32, self.win_w * self.win_h);
    }

    pub fn destructor(self: *Framebuffer) void {
        const allocator = std.heap.page_allocator;
        allocator.free(self.buffer);
    }

    pub fn clear(self: *Framebuffer, color: u32) void {
        std.mem.set(u32, self.buffer, color);
    }

    pub fn setPixel(self: *Framebuffer, x: usize, y: usize, color: u32) void {
        self.buffer[y * self.win_w + x] = color;
    }

    pub fn drawRectangle(self: *Framebuffer, x: usize, y: usize, w: usize, h: usize, color: u32) void {
        var i: usize = 0;
        while (i < h) : (i += 1) {
            var j: usize = 0;
            while (j < w) : (j += 1) {
                const cx: usize = x + j;
                const cy: usize = y + i;
                // no need to check for negative values (unsigned vars)
                if (cx >= self.win_w or cy >= self.win_h)
                    continue;
                self.buffer[cx + cy * self.win_w] = color;
            }
        }
    }

    pub fn dropPpmImage(self: *Framebuffer, filename: []const u8) bool {
        // open file
        const cwd: fs.Dir = fs.cwd();
        const f: fs.File = cwd.createFile(filename, fs.File.CreateFlags{}) catch return false;
        // create a buffered writer
        var buf = std.io.bufferedWriter(f.writer());
        var buf_writer = buf.writer();

        // ppm file type meta-data
        buf_writer.print("P6\n{} {}\n255\n", .{ self.win_w, self.win_h }) catch return false;
        // write file data
        var color: [4]u8 = undefined;
        var i: usize = 0;
        while (i < self.win_w * self.win_h) : (i += 1) {
            utils.unpackColor(self.buffer[i], &color[0], &color[1], &color[2], &color[3]);
            _ = buf_writer.writeAll(color[0..3]) catch return false;
        }

        buf.flush() catch return false;
        f.close();

        return true;
    }
};
