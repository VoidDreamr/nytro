import 'dart:io';
import 'package:image/image.dart';
import 'package:nytro/core/ny_assembler.dart';
import 'package:nytro/nytro_image/ny_texture_image.dart';
import 'package:vector_math/vector_math.dart';

void main(List<String> arguments) async {
  final src = await File('shader.nyasm').readAsString();
  final program = NyAssembler.parse(src);
  final uvIn = program.bind<Vector2>(1);
  final colorOut = program.bind<Vector4>(2);

  final tex = await NyTextureImage.fromFile('input.png');
  if (tex == null) {
    throw StateError('Failed to load texture from input.png');
  }
  program.bindTexture2(0, tex);

  final output = Image(width: tex.width, height: tex.height);
  final sw = Stopwatch()..start();
  for (int y = 0; y < output.height; y++) {
    for (int x = 0; x < output.width; x++) {
      uvIn.write(
        Vector2(x / output.width.toDouble(), y / output.height.toDouble()),
      );

      program.run();

      Vector4 color = colorOut.read();
      output.setPixelRgba(
        x,
        y,
        color.r * 255,
        color.g * 255,
        color.b * 255,
        color.a * 255,
      );
    }
  }
  sw.stop();

  await File('output.png').writeAsBytes(encodePng(output));

  print(
    'Elapsed: ${sw.elapsed}, Pixels: ${output.width * output.height}, Pixel Rate: ${(output.width * output.height / sw.elapsedMilliseconds / 1000.0).toStringAsFixed(3)} Mpx/s',
  );
}
