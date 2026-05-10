import 'package:nytro/core/instructions/ny_instr.dart';
import 'package:nytro/core/instructions/ny_operand.dart';
import 'package:nytro/core/ny_program.dart';

class NyStoreInstr extends NyInstr {
  final NyRegisterRef src;
  final NyInteger count;
  final NyMemoryRef dest;

  NyStoreInstr({required this.src, required this.count, required this.dest});

  @override
  void execute(NyProgram program) {
    program.memory[dest.index]!.setRange(
      dest.offset,
      dest.offset + count.value,
      program.register.buffer,
      program.register.index(src.slot, src.offset),
    );
    program.pc++;
  }

  static NyStoreInstr fromOperands(List<NyOperand> operands) {
    if (operands.length != 3) {
      throw ArgumentError('This instruction takes 3 arguments.');
    }

    return NyStoreInstr(
      src: NyInstr.expect<NyRegisterRef>(operands[0], 0),
      count: NyInstr.expect<NyInteger>(operands[1], 1),
      dest: NyInstr.expect<NyMemoryRef>(operands[2], 2),
    );
  }
}
