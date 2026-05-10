import 'package:vector_math/vector_math.dart';

abstract final class NyLayout {
  static List<double> pack(dynamic value) {
    if (value is double) {
      return [value];
    } else if (value is Vector2) {
      return [value.x, value.y];
    } else if (value is Vector3) {
      return [value.x, value.y, value.z];
    } else if (value is Vector4) {
      return [value.x, value.y, value.z, value.w];
    } else {
      throw ArgumentError('Cannot pack value of type ${value.runtimeType}.');
    }
  }

  static T unpack<T>(List<double> buffer, int offset) {
    if (T == double) {
      return buffer[offset] as T;
    } else if (T == Vector2) {
      return Vector2(buffer[offset], buffer[offset + 1]) as T;
    } else if (T == Vector3) {
      return Vector3(buffer[offset], buffer[offset + 1], buffer[offset + 2])
          as T;
    } else if (T == Vector4) {
      return Vector4(
            buffer[offset],
            buffer[offset + 1],
            buffer[offset + 2],
            buffer[offset + 3],
          )
          as T;
    } else {
      throw ArgumentError('Cannot unpack type $T.');
    }
  }
}
