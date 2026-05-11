import 'package:image/image.dart';
import 'package:vector_math/vector_math.dart';

extension PixelExt on Pixel {
  Vector4 get colorNormalized => Vector4(
    rNormalized.toDouble(),
    gNormalized.toDouble(),
    bNormalized.toDouble(),
    aNormalized.toDouble(),
  );
  Vector2 get uv => Vector2(xNormalized.toDouble(), yNormalized.toDouble());
}
