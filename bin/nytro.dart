import 'dart:typed_data';

import 'package:nytro/core/ny.dart';
import 'package:nytro/core/ny_program.dart';
import 'dart:io';

void main(List<String> arguments) async {
  final src = await File('example.nyasm').readAsString();

  NyProgram program = Ny.createAssemblyProgram(src);
  program.memory.addAll({
    0: Float32List.fromList([9, 8, 7, 6]),
  });
  program.run();

  print(program.register.dump());
}
