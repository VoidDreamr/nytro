import 'package:nytro/core/instructions/ny_instr.dart';
import 'package:nytro/core/instructions/ny_operand.dart';
import 'package:nytro/core/ny_program.dart';
import 'package:nytro/core/ny_type.dart';

abstract class NyBinaryInstr<T> extends NyInstr {
  T? _aValue;
  T? _bValue;
  late final NyType<T> _type;

  final NyFloatLike a;
  final NyFloatLike b;
  final NyRegisterRef dest;

  NyBinaryInstr({required this.a, required this.b, required this.dest}) {
    _type = NyTypes.find<T>()!;
  }

  @override
  void execute(NyProgram program) {
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

  static NyBinaryOperands validateFor<T>(List<NyOperand> operands) {
    if (operands.length != 3) {
      throw ArgumentError('This instruction takes 3 arguments.');
    }

    late final NyFloatLike a;
    late final NyFloatLike b;

    if (T == double) {
      a = NyInstr.expect<NyFloatLike>(operands[0], 0);
      b = NyInstr.expect<NyFloatLike>(operands[1], 1);
    } else {
      a = NyInstr.expect<NyRegisterRef>(operands[0], 0);
      b = NyInstr.expect<NyRegisterRef>(operands[1], 1);
    }

    return (a: a, b: b, dest: NyInstr.expect<NyRegisterRef>(operands[2], 2));
  }
}

typedef NyBinaryOperands = ({NyFloatLike a, NyFloatLike b, NyRegisterRef dest});
