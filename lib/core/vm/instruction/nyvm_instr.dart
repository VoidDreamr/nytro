import 'package:nytro/core/vm/instruction/nyvm_operand.dart';
import 'package:nytro/core/vm/nyvm_program.dart';

abstract class NyvmInstr {
  void execute(NyvmProgram program);

  static T expect<T>(NyvmOperand op, int argIndex) {
    if (op is T) {
      return op as T;
    }
    throw ArgumentError('Argument $argIndex should be a $T.');
  }
}
