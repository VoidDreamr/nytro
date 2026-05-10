import 'package:nytro/core/instructions/ny_binary_instr.dart';
import 'package:nytro/core/instructions/ny_operand.dart';
import 'package:nytro/core/ny_math.dart';

class NySubInstr<T> extends NyBinaryInstr<T> {
  NySubInstr({required super.a, required super.b, required super.dest});

  @override
  T eval(T a, T b) {
    return NyMath.sub(a, b);
  }

  static NySubInstr fromOperands<T>(List<NyOperand> operands) {
    NyBinaryOperands biops = NyBinaryInstr.validateFor<T>(operands);
    return NySubInstr<T>(a: biops.a, b: biops.b, dest: biops.dest);
  }
}
