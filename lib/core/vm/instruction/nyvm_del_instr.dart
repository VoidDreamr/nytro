import 'package:nytro/core/vm/instruction/nyvm_instr.dart';
import 'package:nytro/core/vm/instruction/nyvm_operand.dart';
import 'package:nytro/core/vm/nyvm_program.dart';

class NyvmDelInstr extends NyvmInstr {
  final NyvmMemoryRef dest;

  NyvmDelInstr({required this.dest});

  @override
  void execute(NyvmProgram program) {
    program.del(dest.index);
    program.pc++;
  }

  static NyvmDelInstr fromOperands(List<NyvmOperand> operands) {
    if (operands.length != 1) {
      throw ArgumentError('This instruction takes 1 argument.');
    }

    return NyvmDelInstr(dest: NyvmInstr.expect<NyvmMemoryRef>(operands[0], 0));
  }
}
