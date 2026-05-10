import 'package:nytro/core/instructions/ny_instr.dart';
import 'package:nytro/core/instructions/ny_operand.dart';
import 'package:nytro/core/ny_program.dart';

class NyLoadInstr extends NyInstr {
  final NyMemoryRef src;
  final NyInteger count;
  final NyRegisterRef dest;

  NyLoadInstr({required this.src, required this.count, required this.dest});

  @override
  void execute(NyProgram program) {
    program.register.setRange(
      dest.slot,
      dest.offset,
      program.memory[src.index]!,
      src.offset,
      count.value,
    );
    program.pc++;
  }

  static NyLoadInstr fromOperands(List<NyOperand> operands) {
    if (operands.length != 3) {
      throw ArgumentError('This instruction takes 3 arguments.');
    }

    late final NyMemoryRef src;
    if (operands[0] is NyMemoryRef) {
      src = operands[0] as NyMemoryRef;
    } else {
      throw ArgumentError('Argument 0 should be a memory reference.');
    }
    late final NyInteger count;
    if (operands[1] is NyInteger) {
      count = operands[1] as NyInteger;
    } else {
      throw ArgumentError('Argument 1 should be an integer.');
    }
    late final NyRegisterRef dest;
    if (operands[2] is NyRegisterRef) {
      dest = operands[2] as NyRegisterRef;
    } else {
      throw ArgumentError('Argument 2 should be a register reference.');
    }

    return NyLoadInstr(src: src, count: count, dest: dest);
  }
}
