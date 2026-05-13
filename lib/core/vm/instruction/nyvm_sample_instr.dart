import 'package:nytro/core/vm/instruction/nyvm_instr.dart';
import 'package:nytro/core/vm/instruction/nyvm_operand.dart';
import 'package:nytro/core/vm/nyvm_program.dart';
import 'package:nytro/core/ny_texture_2.dart';
import 'package:nytro/core/vm/nyvm_type.dart';
import 'package:vector_math/vector_math.dart';

class NyvmSampleInstr extends NyvmInstr {
  final _tex = NyTexture2.empty();
  final _uv = Vector2.zero();
  final _color = Vector4.zero();

  final NyvmMemoryRef src;
  final NyvmRegisterRef uv;
  final NyvmRegisterRef dest;

  NyvmSampleInstr({required this.src, required this.uv, required this.dest});

  @override
  void execute(NyvmProgram program) {
    _tex.buffer = program.memory[src.index]!;
    program.register.resolveTyped<Vector2>(uv, NyvmTypes.vec2, _uv);
    _tex.sample(_uv.x, _uv.y, _color);

    NyvmTypes.vec4.pack(
      _color,
      program.register.buffer,
      program.register.index(dest.slot, dest.offset),
    );

    program.pc++;
  }

  static NyvmSampleInstr fromOperands(List<NyvmOperand> operands) {
    if (operands.length != 3) {
      throw ArgumentError('This instruction takes 3 arguments.');
    }

    return NyvmSampleInstr(
      src: NyvmInstr.expect<NyvmMemoryRef>(operands[0], 0),
      uv: NyvmInstr.expect<NyvmRegisterRef>(operands[1], 1),
      dest: NyvmInstr.expect<NyvmRegisterRef>(operands[2], 2),
    );
  }
}
