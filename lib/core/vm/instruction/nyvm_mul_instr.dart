import 'package:nytro/core/vm/instruction/nyvm_binary_instr.dart';
import 'package:nytro/core/vm/instruction/nyvm_operand.dart';
import 'package:nytro/core/utils/dynamic_math.dart';

class NyvmMulInstr<T> extends NyvmBinaryInstr<T> {
  NyvmMulInstr({required super.a, required super.b, required super.dest});

  @override
  T eval(T a, T b) {
    return DynamicMath.mul(a, b);
  }

  static NyvmMulInstr fromOperands<T>(List<NyvmOperand> operands) {
    NyBinaryOperands biops = NyvmBinaryInstr.validateFor<T>(operands);
    return NyvmMulInstr<T>(a: biops.a, b: biops.b, dest: biops.dest);
  }
}
