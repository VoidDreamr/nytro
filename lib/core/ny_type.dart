import 'package:vector_math/vector_math.dart';

sealed class NyType<T> {
  final Type type;
  final String suffix;

  const NyType({required this.type, required this.suffix});

  List<double> pack(T value);
  T unpack(List<double> buffer, int offset);
}

class NyFloatType extends NyType<double> {
  const NyFloatType() : super(type: double, suffix: 'FLOAT');

  @override
  List<double> pack(double value) {
    return [value];
  }

  @override
  double unpack(List<double> buffer, int offset) {
    return buffer[offset];
  }
}

class NyVec2Type extends NyType<Vector2> {
  const NyVec2Type() : super(type: Vector2, suffix: 'VEC2');

  @override
  List<double> pack(Vector2 value) {
    return [value.x, value.y];
  }

  @override
  Vector2 unpack(List<double> buffer, int offset) {
    return Vector2(buffer[offset], buffer[offset + 1]);
  }
}

class NyVec3Type extends NyType<Vector3> {
  const NyVec3Type() : super(type: Vector3, suffix: 'VEC3');

  @override
  List<double> pack(Vector3 value) {
    return [value.x, value.y, value.z];
  }

  @override
  Vector3 unpack(List<double> buffer, int offset) {
    return Vector3(buffer[offset], buffer[offset + 1], buffer[offset + 2]);
  }
}

class NyVec4Type extends NyType<Vector4> {
  const NyVec4Type() : super(type: Vector4, suffix: 'VEC4');

  @override
  List<double> pack(Vector4 value) {
    return [value.x, value.y, value.z, value.w];
  }

  @override
  Vector4 unpack(List<double> buffer, int offset) {
    return Vector4(
      buffer[offset],
      buffer[offset + 1],
      buffer[offset + 2],
      buffer[offset + 3],
    );
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

  static NyType<T>? find<T>() => _mapped[T] as NyType<T>;
  static NyType? findDynamic(Type type) => _mapped[type];

  static List<double> pack(dynamic value) {
    NyType? type = findDynamic(value.runtimeType);
    if (type != null) {
      return type.pack(value);
    } else {
      throw ArgumentError('Cannot pack value of type: ${value.runtimeType}');
    }
  }

  static T unpack<T>(List<double> buffer, int offset) {
    NyType<T>? type = find<T>();
    if (type != null) {
      return type.unpack(buffer, offset);
    } else {
      throw ArgumentError('Cannot unpack value of type: $T');
    }
  }
}
