import 'package:nytro/core/instructions/ny_operand.dart';
import 'package:nytro/core/ny_program.dart';

abstract class NyInstr {
  void execute(NyProgram program);

  static T expect<T>(NyOperand op, int argIndex) {
    if (op is T) {
      return op as T;
    }
    throw ArgumentError('Argument $argIndex should be a $T.');
  }
}
