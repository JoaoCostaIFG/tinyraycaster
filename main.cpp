#include <cassert>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <vector>

using namespace std;

uint32_t pack_color(const uint8_t r, const uint8_t g, const uint8_t b,
                    const uint8_t a = 255) {
  return (a << 24) + (b << 16) + (g << 8) + r;
}

void unpack_color(const uint32_t &color, uint8_t &r, uint8_t &g, uint8_t &b,
                  uint8_t &a) {
  r = (color >> 0) & 255;
  g = (color >> 8) & 255;
  b = (color >> 16) & 255;
  a = (color >> 24) & 255;
}

void drop_ppm_image(const string filename, const vector<uint32_t> &image,
                    const size_t w, const size_t h) {
  assert(image.size() == w * h);
  ofstream ofs(filename, ofstream::out | ios::binary);
  ofs << "P6\n" << w << " " << h << "\n255\n";
  for (size_t i = 0; i < h * w; ++i) {
    uint8_t r, g, b, a;
    unpack_color(image[i], r, g, b, a);
    ofs << static_cast<char>(r) << static_cast<char>(g) << static_cast<char>(b);
  }
  ofs.close();
}

int main() {
  const size_t win_w = 512; // image width
  const size_t win_h = 512; // image height
  // the image itself, initialized to red
  vector<uint32_t> framebuffer(win_w * win_h, 255);

  // fill the screen with color gradients
  for (size_t j = 0; j < win_h; j++) {
    for (size_t i = 0; i < win_w; i++) {
      uint8_t r = 255.0 * j / win_h;
      uint8_t g = 255.0 * i / win_w;
      uint8_t b = 0; // (r + g) / 2.0;
      framebuffer[i + j * win_w] = pack_color(r, g, b);
    }
  }

  drop_ppm_image("./out.ppm", framebuffer, win_w, win_h);

  return 0;
}
