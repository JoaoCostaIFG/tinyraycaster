https://github.com/ssloy/tinyraycaster/wiki
https://github.com/nothings/stb

# TODO

- use c allocator for performance reasons ?
- @round in place of @floatToInt,
  e.g.: `@floatToInt(usize, @round(sprite.y * @intToFloat(f32, cell_h) - 3)),`
- SDL2 image load replace stb_image (load textures as SDL_Surface)
- funcs with coords recebem anytype e arrendondam inside se for float, etc..
- mapa sem paredes => olhar para o infinito
- Error unions on obj creation functions + errdefer for cleanup on error
