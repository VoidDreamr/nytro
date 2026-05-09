import 'dart:typed_data';

import 'package:nytro/core/instructions/ny_instr.dart';
import 'package:nytro/core/instructions/ny_operand.dart';
import 'package:nytro/core/ny_program.dart';

class NyWriteInstr extends NyInstr {
  late final Float32List _values;

  final List<NyFloatLike> operands;
  final NyRegisterRef dest;

  NyWriteInstr({required this.operands, required this.dest}) {
    _values = Float32List(operands.length);
  }

  @override
  void execute(NyProgram program) {
    for (int i = 0; i < operands.length; i++) {
      final op = operands[i];
      if (op is NyConstant) {
        _values[i] = op.value;
      } else if (op is NyRegisterRef) {
        _values[i] = program.register.get(op.slot, op.offset);
      }
    }
    program.register.write(dest.slot, dest.offset, _values);
    program.pc++;
  }

  static NyWriteInstr fromOperands(List<NyOperand> operands) {
    if (operands.isEmpty || operands.length > 17) {
      throw ArgumentError('Operands cannot be empty or have more than 17.');
    }

    late final NyRegisterRef dest;
    if (operands.last is NyRegisterRef) {
      dest = operands.last as NyRegisterRef;
    } else {
      throw ArgumentError('The last operand must be a register reference.');
    }

    final writeOperands = <NyFloatLike>[];
    for (int i = 0; i < operands.length - 1; i++) {
      final op = operands[i];
      if (op is NyFloatLike) {
        writeOperands.add(op);
      } else {
        throw ArgumentError('Value operands must be floaty.');
      }
    }

    return NyWriteInstr(operands: writeOperands, dest: dest);
  }
}
