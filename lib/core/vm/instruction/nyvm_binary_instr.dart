import 'package:nytro/core/vm/instruction/nyvm_instr.dart';
import 'package:nytro/core/vm/instruction/nyvm_operand.dart';
import 'package:nytro/core/vm/nyvm_program.dart';
import 'package:nytro/core/vm/nyvm_type.dart';

abstract class NyvmBinaryInstr<T> extends NyvmInstr {
  T? _aValue;
  T? _bValue;
  late final NyvmType<T> _type;

  final NyvmFloatLike a;
  final NyvmFloatLike b;
  final NyvmRegisterRef dest;

  NyvmBinaryInstr({required this.a, required this.b, required this.dest}) {
    _type = NyvmTypes.find<T>();
  }

  @override
  void execute(NyvmProgram program) {
    _aValue = program.register.resolveTyped<T>(a, _type, _aValue);
    _bValue = program.register.resolveTyped<T>(b, _type, _bValue);
    final result = eval(_aValue as T, _bValue as T);

    _type.pack(
      result,
      program.register.buffer,
      program.register.index(dest.slot, dest.offset),
    );

    program.pc++;
  }

  T eval(T a, T b);

  static NyBinaryOperands validateFor<T>(List<NyvmOperand> operands) {
    if (operands.length != 3) {
      throw ArgumentError('This instruction takes 3 arguments.');
    }

    late final NyvmFloatLike a;
    late final NyvmFloatLike b;

    if (T == double) {
      a = NyvmInstr.expect<NyvmFloatLike>(operands[0], 0);
      b = NyvmInstr.expect<NyvmFloatLike>(operands[1], 1);
    } else {
      a = NyvmInstr.expect<NyvmRegisterRef>(operands[0], 0);
      b = NyvmInstr.expect<NyvmRegisterRef>(operands[1], 1);
    }

    return (
      a: a,
      b: b,
      dest: NyvmInstr.expect<NyvmRegisterRef>(operands[2], 2),
    );
  }
}

typedef NyBinaryOperands = ({
  NyvmFloatLike a,
  NyvmFloatLike b,
  NyvmRegisterRef dest,
});
