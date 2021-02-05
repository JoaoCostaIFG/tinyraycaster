const math = @import("std").math;

pub const Player = struct {
    x: f32 = 0.0,
    y: f32 = 0.0,
    speed: f32 = 1.0, // distance traveled in each step
    angle: f32 = 0.0, // player view direction
    fov: f32 = math.pi / 3.0, // field of view

    pub fn getRayAngle(self: *Player, i: f32, win_w2: f32) f32 {
        return self.angle - self.fov / 2.0 + self.fov * i / win_w2;
    }

    pub fn up(self: *Player) void {
        self.y -= self.speed;
        if (self.y < 0) self.y = 0;
    }

    pub fn down(self: *Player) void {
        self.y += self.speed;
    }

    pub fn left(self: *Player) void {
        self.x -= self.speed;
        if (self.x < 0) self.x = 0;
    }

    pub fn right(self: *Player) void {
        self.x += self.speed;
    }
};
