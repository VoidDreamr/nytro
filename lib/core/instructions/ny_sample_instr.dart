import 'package:nytro/core/instructions/ny_instr.dart';
import 'package:nytro/core/instructions/ny_operand.dart';
import 'package:nytro/core/ny_program.dart';
import 'package:nytro/core/ny_texture_2.dart';
import 'package:nytro/core/ny_type.dart';
import 'package:vector_math/vector_math.dart';

class NySampleInstr extends NyInstr {
  final _tex = NyTexture2.empty();
  final _uv = Vector2.zero();
  final _color = Vector4.zero();

  final NyMemoryRef src;
  final NyRegisterRef uv;
  final NyRegisterRef dest;

  NySampleInstr({required this.src, required this.uv, required this.dest});

  @override
  void execute(NyProgram program) {
    _tex.buffer = program.memory[src.index]!;
    program.register.resolveTyped<Vector2>(uv, NyTypes.vec2, _uv);
    _tex.sample(_uv.x, _uv.y, _color);

    NyTypes.vec4.pack(
      _color,
      program.register.buffer,
      program.register.index(dest.slot, dest.offset),
    );

    program.pc++;
  }

  static NySampleInstr fromOperands(List<NyOperand> operands) {
    if (operands.length != 3) {
      throw ArgumentError('This instruction takes 3 arguments.');
    }

    return NySampleInstr(
      src: NyInstr.expect<NyMemoryRef>(operands[0], 0),
      uv: NyInstr.expect<NyRegisterRef>(operands[1], 1),
      dest: NyInstr.expect<NyRegisterRef>(operands[2], 2),
    );
  }
}
