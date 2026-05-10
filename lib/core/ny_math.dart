import 'package:vector_math/vector_math.dart';

abstract final class NyMath {
  static T add<T>(T a, T b) {
    return ((a as dynamic) + (b as dynamic)) as T;
  }

  static T sub<T>(T a, T b) {
    return ((a as dynamic) - (b as dynamic)) as T;
  }

  static T mul<T>(T a, T b) {
    if (a is Vector && b is Vector) {
      return mulVector<Vector>(a, b) as T;
    } else {
      return ((a as dynamic) * (b as dynamic)) as T;
    }
  }

  static T mulVector<T extends Vector>(T a, T b) {
    final storage = <double>[];
    for (int i = 0; i < a.storage.length; i++) {
      storage.add(a.storage[i] * b.storage[i]);
    }

    if (storage.length == 2) {
      return Vector2(storage[0], storage[1]) as T;
    } else if (storage.length == 3) {
      return Vector3(storage[0], storage[1], storage[2]) as T;
    } else {
      return Vector4(storage[0], storage[1], storage[2], storage[3]) as T;
    }
  }

  static T div<T>(T a, T b) {
    if (a is Vector && b is Vector) {
      return divVector<Vector>(a, b) as T;
    } else {
      return ((a as dynamic) / (b as dynamic)) as T;
    }
  }

  static T divVector<T extends Vector>(T a, T b) {
    final storage = <double>[];
    for (int i = 0; i < a.storage.length; i++) {
      storage.add(a.storage[i] / b.storage[i]);
    }

    if (storage.length == 2) {
      return Vector2(storage[0], storage[1]) as T;
    } else if (storage.length == 3) {
      return Vector3(storage[0], storage[1], storage[2]) as T;
    } else {
      return Vector4(storage[0], storage[1], storage[2], storage[3]) as T;
    }
  }
}
