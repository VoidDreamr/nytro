import 'package:nytro/core/vm/instruction/nyvm_binary_instr.dart';
import 'package:nytro/core/vm/instruction/nyvm_operand.dart';
import 'package:nytro/core/utils/dynamic_math.dart';

class NyvmDivInstr<T> extends NyvmBinaryInstr<T> {
  NyvmDivInstr({required super.a, required super.b, required super.dest});

  @override
  T eval(T a, T b) {
    return DynamicMath.div(a, b);
  }

  static NyvmDivInstr fromOperands<T>(List<NyvmOperand> operands) {
    NyBinaryOperands biops = NyvmBinaryInstr.validateFor<T>(operands);
    return NyvmDivInstr<T>(a: biops.a, b: biops.b, dest: biops.dest);
  }
}
