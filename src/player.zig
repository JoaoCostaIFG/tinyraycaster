const math = @import("std").math;

pub const Player = struct {
    x: f32 = 0.0,
    y: f32 = 0.0,
    speed: f32 = 0.1, // distance traveled in each step
    a_speed: f32 = math.pi / 60.0, // angle turning step
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

    pub fn left(self: *Player) void {
        self.x += @cos(math.pi / 2.0 - self.angle) * self.speed;
        self.y -= @sin(math.pi / 2.0 - self.angle) * self.speed;
        self.normalizePos();
    }

    pub fn right(self: *Player) void {
        self.x -= @cos(math.pi / 2.0 - self.angle) * self.speed;
        self.y += @sin(math.pi / 2.0 - self.angle) * self.speed;
        self.normalizePos();
    }

    fn normalizePos(self: *Player) void {
        if (self.x < 0) self.x = 0;
        if (self.y < 0) self.y = 0;
    }

    pub fn look(self: *Player, amount: i32) void {
        self.angle += self.a_speed * @intToFloat(f32, amount);
    }

    pub fn move(self: *Player, moveDirection: Direction) void {
        switch (moveDirection) {
            Direction.front => {
                self.front();
            },
            Direction.back => {
                self.back();
            },
            Direction.left => {
                self.left();
            },
            Direction.right => {
                self.right();
            },
            Direction.lfront => {
                self.front();
                self.left();
            },
            Direction.rfront => {
                self.front();
                self.right();
            },
            Direction.lback => {
                self.back();
                self.left();
            },
            Direction.rback => {
                self.back();
                self.right();
            },
            else => {},
        }
    }
};

pub const Direction = enum(i8) {
    stop = 0,
    front = 2,
    back = -2,
    left = -3,
    right = 3,
    lfront = -1,
    rfront = 5,
    lback = -5,
    rback = 1,
};
