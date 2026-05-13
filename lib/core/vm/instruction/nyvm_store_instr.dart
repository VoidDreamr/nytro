import 'package:nytro/core/vm/instruction/nyvm_instr.dart';
import 'package:nytro/core/vm/instruction/nyvm_operand.dart';
import 'package:nytro/core/vm/nyvm_program.dart';

class NyvmStoreInstr extends NyvmInstr {
  final NyvmRegisterRef src;
  final NyvmInteger count;
  final NyvmMemoryRef dest;

  NyvmStoreInstr.NyvmStoreInstr({
    required this.src,
    required this.count,
    required this.dest,
  });

  @override
  void execute(NyvmProgram program) {
    program.memory[dest.index]!.setRange(
      dest.offset,
      dest.offset + count.value,
      program.register.buffer,
      program.register.index(src.slot, src.offset),
    );
    program.pc++;
  }

  static NyvmStoreInstr fromOperands(List<NyvmOperand> operands) {
    if (operands.length != 3) {
      throw ArgumentError('This instruction takes 3 arguments.');
    }

    return NyvmStoreInstr.NyvmStoreInstr(
      src: NyvmInstr.expect<NyvmRegisterRef>(operands[0], 0),
      count: NyvmInstr.expect<NyvmInteger>(operands[1], 1),
      dest: NyvmInstr.expect<NyvmMemoryRef>(operands[2], 2),
    );
  }
}
