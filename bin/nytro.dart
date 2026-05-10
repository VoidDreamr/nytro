import 'dart:typed_data';

import 'package:nytro/core/ny.dart';
import 'package:nytro/core/ny_program.dart';
import 'dart:io';
import 'package:image/image.dart';

void main(List<String> arguments) async {
  final src = await File('shader.nyasm').readAsString();
  NyProgram program = Ny.createAssemblyProgram(src);
  program.memory.addAll({
    0: Float32List(4),
    1: Float32List(2),
    2: Float32List(4),
  });

  final bytes = await File('input.png').readAsBytes();
  final image = decodeImage(bytes);
  if (image == null) {
    throw FormatException('Failed to decode image from input.png');
  }
  final output = Image(width: image.width, height: image.height);

  final sw = Stopwatch()..start();
  Pixel? pixel;
  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      pixel = image.getPixel(x, y, pixel);

      program.memory[0]![0] = pixel.rNormalized.toDouble();
      program.memory[0]![1] = pixel.gNormalized.toDouble();
      program.memory[0]![2] = pixel.bNormalized.toDouble();
      program.memory[0]![3] = pixel.aNormalized.toDouble();

      program.memory[1]![0] = pixel.xNormalized.toDouble();
      program.memory[1]![1] = pixel.yNormalized.toDouble();

      program.run();

      output.setPixelRgba(
        x,
        y,
        program.memory[2]![0] * 255,
        program.memory[2]![1] * 255,
        program.memory[2]![2] * 255,
        program.memory[2]![3] * 255,
      );
    }
  }
  sw.stop();

  print(
    'Elapsed: ${sw.elapsed}, Pixels: ${image.width * image.height}, Pixel Rate: ${(image.width * image.height / sw.elapsedMilliseconds).toStringAsFixed(0)} px/ms',
  );

  await File('output.png').writeAsBytes(encodePng(output));
}
