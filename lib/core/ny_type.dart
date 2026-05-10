import 'package:vector_math/vector_math.dart';

class NyType {
  final Type type;
  final String suffix;

  const NyType({required this.type, required this.suffix});
}

abstract final class NyTypes {
  static const NyType float = NyType(type: double, suffix: 'FLOAT');
  static const NyType vec2 = NyType(type: Vector2, suffix: 'VEC2');
  static const NyType vec3 = NyType(type: Vector3, suffix: 'VEC3');
  static const NyType vec4 = NyType(type: Vector4, suffix: 'VEC4');

  static final List<NyType> all = [float, ...vecs];
  static final List<NyType> vecs = [vec2, vec3, vec4];
}
