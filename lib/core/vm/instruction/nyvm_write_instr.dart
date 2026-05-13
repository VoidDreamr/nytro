import 'dart:typed_data';

import 'package:nytro/core/vm/instruction/nyvm_instr.dart';
import 'package:nytro/core/vm/instruction/nyvm_operand.dart';
import 'package:nytro/core/vm/nyvm_program.dart';

class NyvmWriteInstr extends NyvmInstr {
  final Float32List _values;
  final List<int> regIndices = [];

  final List<NyvmFloatLike> operands;
  final NyvmRegisterRef dest;

  NyvmWriteInstr({required this.operands, required this.dest})
    : _values = Float32List(operands.length) {
    for (int i = 0; i < operands.length; i++) {
      final op = operands[i];
      if (op is NyvmConstant) {
        _values[i] = op.value;
      } else {
        regIndices.add(i);
      }
    }
  }

  @override
  void execute(NyvmProgram program) {
    for (final reg in regIndices) {
      final op = operands[reg] as NyvmRegisterRef;
      _values[reg] = program.register.get(op.slot, op.offset);
    }

    program.register.write(dest.slot, dest.offset, _values);
    program.pc++;
  }

  static NyvmWriteInstr fromOperands(List<NyvmOperand> operands) {
    if (operands.isEmpty || operands.length > 17) {
      throw ArgumentError('Operands cannot be empty or have more than 17.');
    }

    final writeOperands = <NyvmFloatLike>[];
    for (int i = 0; i < operands.length - 1; i++) {
      writeOperands.add(NyvmInstr.expect<NyvmFloatLike>(operands[i], i));
    }

    return NyvmWriteInstr(
      operands: writeOperands,
      dest: NyvmInstr.expect<NyvmRegisterRef>(
        operands.last,
        operands.length - 1,
      ),
    );
  }
}
