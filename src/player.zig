const math = @import("std").math;

pub const Player = struct {
    x: f32 = 0.0,
    y: f32 = 0.0,
    speed: f32 = 0.1, // distance traveled in each step
    a_speed: f32 = 0.05, // angle turning step
    angle: f32 = 0.0, // player view direction
    fov: f32 = math.pi / 3.0, // field of view

    pub fn getRayAngle(self: *Player, i: f32, win_w2: f32) f32 {
        return self.angle - self.fov / 2.0 + self.fov * i / win_w2;
    }

    pub fn front(self: *Player) void {
        self.x += @cos(self.angle) * self.speed;
        self.y += @sin(self.angle) * self.speed;
        self.normalizePos();
    }

    pub fn back(self: *Player) void {
        self.x -= @cos(self.angle) * self.speed;
        self.y -= @sin(self.angle) * self.speed;
        self.normalizePos();
    }

    pub fn lookLeft(self: *Player) void {
        self.angle -= self.a_speed;
    }

    pub fn lookRight(self: *Player) void {
        self.angle += self.a_speed;
    }

    fn normalizePos(self: *Player) void {
        if (self.x < 0) self.x = 0;
        if (self.y < 0) self.y = 0;
    }
};
