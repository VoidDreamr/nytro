import 'package:nytro/core/vm/instruction/nyvm_instr.dart';
import 'package:nytro/core/vm/instruction/nyvm_operand.dart';
import 'package:nytro/core/vm/nyvm_program.dart';

class NyvmLoadInstr extends NyvmInstr {
  final NyvmMemoryRef src;
  final NyvmInteger count;
  final NyvmRegisterRef dest;

  NyvmLoadInstr({required this.src, required this.count, required this.dest});

  @override
  void execute(NyvmProgram program) {
    program.register.setRange(
      dest.slot,
      dest.offset,
      program.memory[src.index]!,
      src.offset,
      count.value,
    );
    program.pc++;
  }

  static NyvmLoadInstr fromOperands(List<NyvmOperand> operands) {
    if (operands.length != 3) {
      throw ArgumentError('This instruction takes 3 arguments.');
    }

    return NyvmLoadInstr(
      src: NyvmInstr.expect<NyvmMemoryRef>(operands[0], 0),
      count: NyvmInstr.expect<NyvmInteger>(operands[1], 1),
      dest: NyvmInstr.expect<NyvmRegisterRef>(operands[2], 2),
    );
  }
}
