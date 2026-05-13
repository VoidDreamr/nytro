import 'package:vector_math/vector_math.dart';

sealed class NyvmType<T> {
  final Type type;
  final String suffix;
  final int sizeof;

  const NyvmType({
    required this.type,
    required this.suffix,
    required this.sizeof,
  });

  void pack(T value, List<double> buffer, int offset);
  T unpack(List<double> buffer, int offset, T? out);
}

class NyvmFloat extends NyvmType<double> {
  const NyvmFloat() : super(type: double, suffix: 'FLOAT', sizeof: 1);

  @override
  void pack(double value, List<double> buffer, int offset) {
    buffer[offset] = value;
  }

  @override
  double unpack(List<double> buffer, int offset, double? out) {
    return buffer[offset];
  }
}

class NyvmVec2 extends NyvmType<Vector2> {
  const NyvmVec2() : super(type: Vector2, suffix: 'VEC2', sizeof: 2);

  @override
  void pack(Vector2 value, List<double> buffer, int offset) {
    buffer.setRange(offset, offset + 2, value.storage);
  }

  @override
  Vector2 unpack(List<double> buffer, int offset, Vector2? out) {
    out ??= Vector2.zero();
    out.storage.setRange(0, 2, buffer, offset);
    return out;
  }
}

class NyvmVec3 extends NyvmType<Vector3> {
  const NyvmVec3() : super(type: Vector3, suffix: 'VEC3', sizeof: 3);

  @override
  void pack(Vector3 value, List<double> buffer, int offset) {
    buffer.setRange(offset, offset + 3, value.storage);
  }

  @override
  Vector3 unpack(List<double> buffer, int offset, Vector3? out) {
    out ??= Vector3.zero();
    out.storage.setRange(0, 3, buffer, offset);
    return out;
  }
}

class NyvmVec4 extends NyvmType<Vector4> {
  const NyvmVec4() : super(type: Vector4, suffix: 'VEC4', sizeof: 4);

  @override
  void pack(Vector4 value, List<double> buffer, int offset) {
    buffer.setRange(offset, offset + 4, value.storage);
  }

  @override
  Vector4 unpack(List<double> buffer, int offset, Vector4? out) {
    out ??= Vector4.zero();
    out.storage.setRange(0, 4, buffer, offset);
    return out;
  }
}

abstract final class NyvmTypes {
  static const NyvmFloat float = NyvmFloat();
  static const NyvmVec2 vec2 = NyvmVec2();
  static const NyvmVec3 vec3 = NyvmVec3();
  static const NyvmVec4 vec4 = NyvmVec4();

  static const List<NyvmType> all = [float, ...vecs];
  static const List<NyvmType> vecs = [vec2, vec3, vec4];
  static final Map<Type, NyvmType> _mapped = {
    for (NyvmType type in all) type.type: type,
  };

  static NyvmType<T>? tryFind<T>() => _mapped[T] as NyvmType<T>?;
  static NyvmType? tryFindDynamic(Type type) => _mapped[type];

  static NyvmType<T> find<T>() {
    NyvmType<T>? type = tryFind<T>();
    if (type != null) {
      return type;
    } else {
      throw StateError('Unsupported type $T');
    }
  }

  static void pack(dynamic value, List<double> buffer, int offset) {
    NyvmType? type = tryFindDynamic(value.runtimeType);
    if (type != null) {
      type.pack(value, buffer, offset);
    } else {
      throw ArgumentError('Cannot pack value of type: ${value.runtimeType}');
    }
  }

  static T unpack<T>(List<double> buffer, int offset, T? out) {
    NyvmType<T>? type = tryFind<T>();
    if (type != null) {
      return type.unpack(buffer, offset, out);
    } else {
      throw ArgumentError('Cannot unpack value of type: $T');
    }
  }
}
