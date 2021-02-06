pub const Sprite = struct {
    x: f32,
    y: f32,
    tex_id: usize,
    player_dist: f32 = 0.0,

    pub fn isCloser(self: *const Sprite, o: *const Sprite) bool {
        return self.player_dist < o.player_dist;
    }
};

pub fn desc(constext: void, l: Sprite, r: Sprite) bool {
    return !l.isCloser(&r);
}
