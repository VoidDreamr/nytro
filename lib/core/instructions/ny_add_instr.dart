import 'package:nytro/core/instructions/ny_binary_instr.dart';
import 'package:nytro/core/instructions/ny_operand.dart';
import 'package:nytro/core/ny_math.dart';

class NyAddInstr<T> extends NyBinaryInstr<T> {
  NyAddInstr({required super.a, required super.b, required super.dest});

  @override
  T eval(T a, T b) {
    return NyMath.add(a, b);
  }

  static NyAddInstr fromOperands<T>(List<NyOperand> operands) {
    NyBinaryOperands biops = NyBinaryInstr.validateFor<T>(operands);
    return NyAddInstr<T>(a: biops.a, b: biops.b, dest: biops.dest);
  }
}
