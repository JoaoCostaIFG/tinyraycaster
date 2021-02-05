const math = @import("std").math;

pub const Player = struct {
    x: f32 = 0.0,
    y: f32 = 0.0,
    angle: f32 = 0.0, // player view direction
    fov: f32 = math.pi / 3.0, // field of view
};
