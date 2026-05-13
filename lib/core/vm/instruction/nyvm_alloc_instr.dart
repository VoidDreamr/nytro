import 'package:nytro/core/vm/instruction/nyvm_instr.dart';
import 'package:nytro/core/vm/instruction/nyvm_operand.dart';
import 'package:nytro/core/vm/nyvm_program.dart';

class NyvmAllocInstr extends NyvmInstr {
  final NyvmInteger count;
  final NyvmMemoryRef dest;

  NyvmAllocInstr({required this.count, required this.dest});

  @override
  void execute(NyvmProgram program) {
    program.alloc(dest.index, count.value);
    program.pc++;
  }

  static NyvmAllocInstr fromOperands(List<NyvmOperand> operands) {
    if (operands.length != 2) {
      throw ArgumentError('This instruction takes 2 arguments.');
    }

    return NyvmAllocInstr(
      count: NyvmInstr.expect<NyvmInteger>(operands[0], 0),
      dest: NyvmInstr.expect<NyvmMemoryRef>(operands[1], 1),
    );
  }
}
