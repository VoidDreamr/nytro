import 'dart:typed_data';

import 'package:nytro/core/instructions/ny_instr.dart';
import 'package:nytro/core/instructions/ny_operand.dart';
import 'package:nytro/core/ny_program.dart';

class NyWriteInstr extends NyInstr {
  final Float32List _values;
  final List<int> regIndices = [];

  final List<NyFloatLike> operands;
  final NyRegisterRef dest;

  NyWriteInstr({required this.operands, required this.dest})
    : _values = Float32List(operands.length) {
    for (int i = 0; i < operands.length; i++) {
      final op = operands[i];
      if (op is NyConstant) {
        _values[i] = op.value;
      } else {
        regIndices.add(i);
      }
    }
  }

  @override
  void execute(NyProgram program) {
    for (final reg in regIndices) {
      final op = operands[reg] as NyRegisterRef;
      _values[reg] = program.register.get(op.slot, op.offset);
    }

    program.register.write(dest.slot, dest.offset, _values);
    program.pc++;
  }

  static NyWriteInstr fromOperands(List<NyOperand> operands) {
    if (operands.isEmpty || operands.length > 17) {
      throw ArgumentError('Operands cannot be empty or have more than 17.');
    }

    final writeOperands = <NyFloatLike>[];
    for (int i = 0; i < operands.length - 1; i++) {
      writeOperands.add(NyInstr.expect<NyFloatLike>(operands[i], i));
    }

    return NyWriteInstr(
      operands: writeOperands,
      dest: NyInstr.expect<NyRegisterRef>(operands.last, operands.length - 1),
    );
  }
}
