import 'package:nytro/core/instructions/ny_instr.dart';
import 'package:nytro/core/instructions/ny_operand.dart';
import 'package:nytro/core/ny_program.dart';

class NyAllocInstr extends NyInstr {
  final NyInteger count;
  final NyMemoryRef dest;

  NyAllocInstr({required this.count, required this.dest});

  @override
  void execute(NyProgram program) {
    program.alloc(dest.index, count.value);
    program.pc++;
  }

  static NyAllocInstr fromOperands(List<NyOperand> operands) {
    if (operands.length != 2) {
      throw ArgumentError('This instruction takes 2 arguments.');
    }

    return NyAllocInstr(
      count: NyInstr.expect<NyInteger>(operands[0], 0),
      dest: NyInstr.expect<NyMemoryRef>(operands[1], 1),
    );
  }
}
