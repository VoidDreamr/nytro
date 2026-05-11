import 'dart:typed_data';

import 'package:nytro/core/ny_type.dart';
import 'package:vector_math/vector_math.dart';

class NyTexture2 {
  static const int headerSize = 16;

  final int channels = 4;

  Float32List buffer;
  int get width => buffer[0].toInt();
  int get height => buffer[1].toInt();

  NyTexture2({required this.buffer});

  int index(int x, int y) {
    return headerSize + ((y * width + x) * channels);
  }

  ({int x, int y}) point(int index) {
    final pixel = (index - headerSize) ~/ channels;

    final x = pixel % width;
    final y = pixel ~/ width;

    return (x: x, y: y);
  }

  Vector4 get(int x, int y, [Vector4? out]) {
    return NyTypes.vec4.unpack(buffer, index(x, y), out);
  }

  Vector4 sample(double u, double v, [Vector4? out]) {
    out ??= Vector4.zero();

    final x = u.clamp(0.0, 1.0) * (width - 1);
    final y = v.clamp(0.0, 1.0) * (height - 1);
    final x0 = x.floor();
    final x1 = x.ceil();
    final y0 = y.floor();
    final y1 = y.ceil();

    Vector4 tl = get(x0, y0);
    Vector4 tr = get(x1, y0);
    Vector4 bl = get(x0, y1);
    Vector4 br = get(x1, y1);

    Vector4 top = Vector4.zero();
    Vector4 bot = Vector4.zero();
    double xn = x - x0;

    Vector4.mix(tl, tr, xn, top);
    Vector4.mix(bl, br, xn, bot);
    Vector4.mix(top, bot, y - y0, out);

    return out;
  }

  void set(int x, int y, Vector4 color) {
    return NyTypes.vec4.pack(color, buffer, index(x, y));
  }

  static NyTexture2 create(int width, int height) {
    final buffer = Float32List(width * height * 4 + headerSize);
    buffer[0] = width.toDouble();
    buffer[1] = height.toDouble();

    return NyTexture2(buffer: buffer);
  }

  static NyTexture2 empty() {
    return NyTexture2(buffer: Float32List(headerSize));
  }
}
