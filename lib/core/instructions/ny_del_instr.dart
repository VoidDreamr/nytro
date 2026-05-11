import 'package:nytro/core/instructions/ny_instr.dart';
import 'package:nytro/core/instructions/ny_operand.dart';
import 'package:nytro/core/ny_program.dart';

class NyDelInstr extends NyInstr {
  final NyMemoryRef dest;

  NyDelInstr({required this.dest});

  @override
  void execute(NyProgram program) {
    program.del(dest.index);
    program.pc++;
  }

  static NyDelInstr fromOperands(List<NyOperand> operands) {
    if (operands.length != 1) {
      throw ArgumentError('This instruction takes 1 argument.');
    }

    return NyDelInstr(dest: NyInstr.expect<NyMemoryRef>(operands[0], 0));
  }
}
