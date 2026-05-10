import 'package:nytro/core/instructions/ny_binary_instr.dart';
import 'package:nytro/core/instructions/ny_operand.dart';
import 'package:nytro/core/ny_math.dart';

class NyDivInstr<T> extends NyBinaryInstr<T> {
  NyDivInstr({required super.a, required super.b, required super.dest});

  @override
  T eval(T a, T b) {
    return NyMath.div(a, b);
  }

  static NyDivInstr fromOperands<T>(List<NyOperand> operands) {
    NyBinaryOperands biops = NyBinaryInstr.validateFor<T>(operands);
    return NyDivInstr<T>(a: biops.a, b: biops.b, dest: biops.dest);
  }
}
