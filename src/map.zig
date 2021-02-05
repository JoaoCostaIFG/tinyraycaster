const std = @import("std");

const map_data = @embedFile("../assets/map");

pub const Map = struct {
    w: usize,
    h: usize,
    data: []u8 = undefined,

    pub fn get(self: *Map, x: usize, y: usize) u32 {
        return self.data[y * self.w + x] - '0';
    }

    pub fn isEmpty(self: *Map, x: usize, y: usize) bool {
        return self.data[y * self.w + x] == ' ';
    }

    pub fn destructor(self: *Map) void {
        const allocator = std.heap.page_allocator;
        allocator.free(self.data);
    }
};

pub fn readMap() Map {
    var map_size: usize = map_data.len;
    var i: usize = 0;
    while (i < map_data.len) : (i += 1) {
        if (map_data[i] == '\n')
            map_size -= 1;
    }

    // TODO actual return err
    const allocator = std.heap.page_allocator;
    var map = allocator.alloc(u8, map_size) catch return Map{ .w = 0, .h = 0 };

    var map_h: usize = 0;
    i = 0;
    var j: usize = 0;
    while (i < map_data.len) : (i += 1) {
        if (map_data[i] != '\n') {
            map[j] = map_data[i];
            j += 1;
        } else {
            map_h += 1;
        }
    }

    const map_w: usize = j / map_h;

    return Map{
        .w = map_w,
        .h = map_h,
        .data = map,
    };
}
