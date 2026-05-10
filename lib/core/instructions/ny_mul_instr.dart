import 'package:nytro/core/instructions/ny_instr.dart';
import 'package:nytro/core/instructions/ny_operand.dart';
import 'package:nytro/core/ny_layout.dart';
import 'package:nytro/core/ny_math.dart';
import 'package:nytro/core/ny_program.dart';

class NyMulInstr<T> extends NyInstr {
  final NyFloatLike a;
  final NyFloatLike b;
  final NyRegisterRef dest;

  NyMulInstr({required this.a, required this.b, required this.dest});

  @override
  void execute(NyProgram program) {
    final a = program.register.resolve<T>(this.a);
    final b = program.register.resolve<T>(this.b);
    final result = NyMath.mul(a, b);
    program.register.write(dest.slot, dest.offset, NyLayout.pack(result));

    program.pc++;
  }

  static NyMulInstr fromOperands<T>(List<NyOperand> operands) {
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

    return NyMulInstr<T>(
      a: a,
      b: b,
      dest: NyInstr.expect<NyRegisterRef>(operands[2], 2),
    );
  }
}
