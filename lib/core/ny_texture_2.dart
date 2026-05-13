import 'dart:typed_data';

import 'package:nytro/core/ny_type.dart';
import 'package:vector_math/vector_math.dart';

class NyTexture2 {
  final Vector4 _top = Vector4.zero();
  final Vector4 _bot = Vector4.zero();
  final Vector4 _tl = Vector4.zero();
  final Vector4 _tr = Vector4.zero();
  final Vector4 _bl = Vector4.zero();
  final Vector4 _br = Vector4.zero();

  static const int headerSize = 16;

  final int channels = 4;

  Float32List buffer;
  int get width => buffer[0].truncate();
  int get height => buffer[1].truncate();

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

  void sample(double u, double v, Vector4 out) {
    final x = u % 1.0 * (width - 1);
    final y = v % 1.0 * (height - 1);
    final x0 = x.floor();
    final x1 = x.ceil();
    final y0 = y.floor();
    final y1 = y.ceil();
    final xn = x - x0;

    NyTypes.vec4.unpack(buffer, index(x0, y0), _tl);
    NyTypes.vec4.unpack(buffer, index(x1, y0), _tr);
    NyTypes.vec4.unpack(buffer, index(x0, y1), _bl);
    NyTypes.vec4.unpack(buffer, index(x1, y1), _br);

    Vector4.mix(_tl, _tr, xn, _top);
    Vector4.mix(_bl, _br, xn, _bot);
    Vector4.mix(_top, _bot, y - y0, out);
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
