import 'dart:typed_data';

import 'package:nytro/core/instructions/ny_instr.dart';
import 'package:nytro/core/ny_register.dart';

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
    if (memory.keys.contains(index)) {
      throw ArgumentError('Cannot allocate an existing memory slot.');
    }
    memory.addAll({index: Float32List(count)});
  }

  void del(int index) {
    if (!memory.keys.contains(index)) {
      throw ArgumentError('Cannot delete a non-existing memory slot.');
    }
    memory.remove(index);
  }
}
