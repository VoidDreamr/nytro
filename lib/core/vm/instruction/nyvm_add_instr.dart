import 'package:nytro/core/vm/instruction/nyvm_binary_instr.dart';
import 'package:nytro/core/vm/instruction/nyvm_operand.dart';
import 'package:nytro/core/utils/dynamic_math.dart';

class NyvmAddInstr<T> extends NyvmBinaryInstr<T> {
  NyvmAddInstr({required super.a, required super.b, required super.dest});

  @override
  T eval(T a, T b) {
    return DynamicMath.add(a, b);
  }

  static NyvmAddInstr fromOperands<T>(List<NyvmOperand> operands) {
    NyBinaryOperands biops = NyvmBinaryInstr.validateFor<T>(operands);
    return NyvmAddInstr<T>(a: biops.a, b: biops.b, dest: biops.dest);
  }
}
