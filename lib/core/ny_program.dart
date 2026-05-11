import 'dart:typed_data';

import 'package:nytro/core/instructions/ny_instr.dart';
import 'package:nytro/core/ny_binding.dart';
import 'package:nytro/core/ny_register.dart';
import 'package:nytro/core/ny_texture_2.dart';
import 'package:nytro/core/ny_type.dart';

class NyProgram {
  final NyRegister register = NyRegister();
  final Map<int, Float32List> memory = {};
  final List<NyInstr> instructions = [];
  int pc = 0;

  void run() {
    pc = 0;
    register.reset();

    while (pc < instructions.length) {
      instructions[pc].execute(this);
    }
  }

  void alloc(int index, int count) {
    if (memory.containsKey(index)) {
      throw ArgumentError('Cannot allocate an existing memory index.');
    }
    memory[index] = Float32List(count);
  }

  NyBinding<T> bind<T>(int index, [int offset = 0]) {
    NyType<T> type = NyTypes.find<T>();
    if (!memory.containsKey(index)) {
      alloc(index, type.sizeof + offset);
    } else if (memory[index]!.length - offset < type.sizeof) {
      throw StateError(
        'm$index:$offset does not have enough space for type $T',
      );
    }

    return NyBinding<T>(
      type: type,
      program: this,
      index: index,
      offset: offset,
    );
  }

  void bindTexture2(int index, NyTexture2 tex) {
    if (!memory.containsKey(index)) {
      memory[index] = tex.buffer;
    } else {
      throw StateError('Cannot bind a texture to an existing memory index.');
    }
  }

  void del(int index) {
    if (!memory.containsKey(index)) {
      throw ArgumentError('Cannot delete a non-existing memory index.');
    }
    memory.remove(index);
  }
}
