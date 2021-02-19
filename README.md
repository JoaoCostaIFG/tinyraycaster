# Tinyraycaster

I wrote this to learn the Zig programming language and play around with SDL2
and computer graphics.

[Here](https://github.com/ssloy/tinyraycaster/wiki) is the tutorial I followed.

![Game screenshot](/screenshot.png)

## Build && Run

`zig build run`

### Controls

- W, A, S, D for moving.
- Mouse for camera movement.

## Cool stuff used in this project

- [SDL2](https://www.libsdl.org/index.php)
- [stb_image](https://github.com/nothings/stb)
- [Zig](https://ziglang.org/)

## TODO

- use c allocator for performance reasons ?
- @round in place of @floatToInt,
  e.g.: `@floatToInt(usize, @round(sprite.y * @intToFloat(f32, cell_h) - 3)),`
- SDL2 image load replace stb_image (load textures as SDL_Surface)
- funcs with coords recebem anytype e arrendondam inside se for float, etc..
- mapa sem paredes => olhar para o infinito
- Error unions on obj creation functions + errdefer for cleanup on error
- use SDL for print screens
- Map for input
