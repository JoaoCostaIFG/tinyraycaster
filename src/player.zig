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

    pub fn front(self: *Player, speed: f32) void {
        self.x += @cos(self.angle) * speed;
        self.y += @sin(self.angle) * speed;
        self.normalizePos();
    }

    pub fn back(self: *Player, speed: f32) void {
        self.x -= @cos(self.angle) * speed;
        self.y -= @sin(self.angle) * speed;
        self.normalizePos();
    }

    pub fn left(self: *Player, speed: f32) void {
        self.x += @cos(math.pi / 2.0 - self.angle) * speed;
        self.y -= @sin(math.pi / 2.0 - self.angle) * speed;
        self.normalizePos();
    }

    pub fn right(self: *Player, speed: f32) void {
        self.x -= @cos(math.pi / 2.0 - self.angle) * speed;
        self.y += @sin(math.pi / 2.0 - self.angle) * speed;
        self.normalizePos();
    }

    fn normalizePos(self: *Player) void {
        if (self.x < 0) self.x = 0;
        if (self.y < 0) self.y = 0;
    }

    pub fn move(self: *Player, moveDirection: Direction, delta_time_perc: f32) void {
        const move_speed = self.speed * delta_time_perc;
        switch (moveDirection) {
            Direction.front => {
                self.front(move_speed);
            },
            Direction.back => {
                self.back(move_speed);
            },
            Direction.left => {
                self.left(move_speed);
            },
            Direction.right => {
                self.right(move_speed);
            },
            Direction.lfront => {
                self.front(move_speed);
                self.left(move_speed);
            },
            Direction.rfront => {
                self.front(move_speed);
                self.right(move_speed);
            },
            Direction.lback => {
                self.back(move_speed);
                self.left(move_speed);
            },
            Direction.rback => {
                self.back(move_speed);
                self.right(move_speed);
            },
            else => {},
        }
    }

    pub fn look(self: *Player, amount: f32, delta_time_perc: f32) void {
        self.angle += self.a_speed * delta_time_perc * amount;
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
