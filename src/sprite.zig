pub const Sprite = struct {
    x: f32,
    y: f32,
    tex_id: usize,
    player_dist: f32 = 0.0,

    pub fn isCloser(self: *Sprite, o: *Sprite) bool {
        return self.player_dist < o.player_dist;
    }
};
