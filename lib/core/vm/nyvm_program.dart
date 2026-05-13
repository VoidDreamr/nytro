import 'dart:typed_data';

import 'package:nytro/core/vm/instruction/nyvm_instr.dart';
import 'package:nytro/core/vm/nyvm_binding.dart';
import 'package:nytro/core/vm/nyvm_register.dart';
import 'package:nytro/core/ny_texture_2.dart';
import 'package:nytro/core/vm/nyvm_type.dart';

class NyvmProgram {
  final NyvmRegister register = NyvmRegister();
  final Map<int, Float32List> memory = {};
  final List<NyvmInstr> instructions = [];
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

  NyvmBinding<T> bind<T>(int index, [int offset = 0]) {
    NyvmType<T> type = NyvmTypes.find<T>();
    if (!memory.containsKey(index)) {
      alloc(index, type.sizeof + offset);
    } else if (memory[index]!.length - offset < type.sizeof) {
      throw StateError(
        'm$index:$offset does not have enough space for type $T',
      );
    }

    return NyvmBinding<T>(
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
