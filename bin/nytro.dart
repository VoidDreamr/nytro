import 'package:nytro/core/ny.dart';
import 'dart:io';
import 'package:image/image.dart';
import 'package:vector_math/vector_math.dart';

void main(List<String> arguments) async {
  final src = await File('shader.nyasm').readAsString();
  final program = Ny.createAssemblyProgram(src);

  final colorIn = program.bind<Vector4>(0);
  final uvIn = program.bind<Vector2>(1);
  final colorOut = program.bind<Vector4>(2);

  final bytes = await File('input.png').readAsBytes();
  final image = decodeImage(bytes);
  if (image == null) {
    throw FormatException('Failed to decode image from input.png');
  }
  final output = Image(width: image.width, height: image.height);

  final sw = Stopwatch()..start();
  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      Pixel pixel = image.getPixel(x, y);
      colorIn.write(
        Vector4(
          pixel.rNormalized.toDouble(),
          pixel.gNormalized.toDouble(),
          pixel.bNormalized.toDouble(),
          pixel.aNormalized.toDouble(),
        ),
      );
      uvIn.write(
        Vector2(pixel.xNormalized.toDouble(), pixel.yNormalized.toDouble()),
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

  print(
    'Elapsed: ${sw.elapsed}, Pixels: ${image.width * image.height}, Pixel Rate: ${(image.width * image.height / sw.elapsedMilliseconds / 1000.0).toStringAsFixed(3)} Mpx/s',
  );

  await File('output.png').writeAsBytes(encodePng(output));
}
