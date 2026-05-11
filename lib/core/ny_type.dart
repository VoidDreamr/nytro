import 'package:vector_math/vector_math.dart';

sealed class NyType<T> {
  final Type type;
  final String suffix;
  final int sizeof;

  const NyType({
    required this.type,
    required this.suffix,
    required this.sizeof,
  });

  void pack(T value, List<double> buffer, int offset);
  T unpack(List<double> buffer, int offset, T? out);
}

class NyFloatType extends NyType<double> {
  const NyFloatType() : super(type: double, suffix: 'FLOAT', sizeof: 1);

  @override
  void pack(double value, List<double> buffer, int offset) {
    buffer[offset] = value;
  }

  @override
  double unpack(List<double> buffer, int offset, double? out) {
    return buffer[offset];
  }
}

class NyVec2Type extends NyType<Vector2> {
  const NyVec2Type() : super(type: Vector2, suffix: 'VEC2', sizeof: 2);

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

class NyVec3Type extends NyType<Vector3> {
  const NyVec3Type() : super(type: Vector3, suffix: 'VEC3', sizeof: 3);

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

class NyVec4Type extends NyType<Vector4> {
  const NyVec4Type() : super(type: Vector4, suffix: 'VEC4', sizeof: 4);

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

abstract final class NyTypes {
  static const NyFloatType float = NyFloatType();
  static const NyVec2Type vec2 = NyVec2Type();
  static const NyVec3Type vec3 = NyVec3Type();
  static const NyVec4Type vec4 = NyVec4Type();

  static const List<NyType> all = [float, ...vecs];
  static const List<NyType> vecs = [vec2, vec3, vec4];
  static final Map<Type, NyType> _mapped = {
    for (NyType type in all) type.type: type,
  };

  static NyType<T>? tryFind<T>() => _mapped[T] as NyType<T>?;
  static NyType? tryFindDynamic(Type type) => _mapped[type];

  static NyType<T> find<T>() {
    NyType<T>? type = tryFind<T>();
    if (type != null) {
      return type;
    } else {
      throw StateError('Unsupported type $T');
    }
  }

  static void pack(dynamic value, List<double> buffer, int offset) {
    NyType? type = tryFindDynamic(value.runtimeType);
    if (type != null) {
      type.pack(value, buffer, offset);
    } else {
      throw ArgumentError('Cannot pack value of type: ${value.runtimeType}');
    }
  }

  static T unpack<T>(List<double> buffer, int offset, T? out) {
    NyType<T>? type = tryFind<T>();
    if (type != null) {
      return type.unpack(buffer, offset, out);
    } else {
      throw ArgumentError('Cannot unpack value of type: $T');
    }
  }
}
