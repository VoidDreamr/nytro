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

    return NyLoadInstr(
      src: NyInstr.expect<NyMemoryRef>(operands[0], 0),
      count: NyInstr.expect<NyInteger>(operands[1], 1),
      dest: NyInstr.expect<NyRegisterRef>(operands[2], 2),
    );
  }
}
