import 'dart:typed_data';

import 'package:vector_math/vector_math.dart';

extension Float32ListExt on Float32List {
  Vector2 getVector2(int offset) {
    return Vector2(this[offset], this[offset + 1]);
  }

  Vector3 getVector3(int offset) {
    return Vector3(this[offset], this[offset + 1], this[offset + 2]);
  }

  Vector4 getVector4(int offset) {
    return Vector4(
      this[offset],
      this[offset + 1],
      this[offset + 2],
      this[offset + 3],
    );
  }
}
