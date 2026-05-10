import 'package:nytro/core/instructions/ny_instr_set.g.dart';
import 'package:nytro/core/instructions/ny_operand.dart';
import 'package:nytro/core/ny_program.dart';

abstract final class Ny {
  static NyProgram createAssemblyProgram(String src) {
    final program = NyProgram();

    final List<NyOperand> opBuffer = [];
    for (final line in src.split('\n').indexed) {
      final args = line.$2.trim().split(RegExp(r'\s+'));
      if (args.isEmpty || args[0].startsWith('#')) continue;

      NyInstrSet? code = NyInstrSet.fromMnemonic(args[0]);
      _assert(
        code != null,
        'Invalid instruction code: ${args[0]}',
        src,
        line.$1,
      );

      opBuffer.clear();
      for (int i = 1; i < args.length; i++) {
        String arg = args[i].trim();
        bool isReg = arg.startsWith('r');
        if (arg.isEmpty) {
          continue;
        } else if (arg.endsWith('f')) {
          final value = double.tryParse(arg.substring(0, arg.length - 1));
          _assert(value != null, 'Invalid float format: $arg', src, line.$1);
          opBuffer.add(NyConstant(value: value!));
        } else if (isReg || arg.startsWith('m')) {
          final units = arg.split(':');
          final slot = int.tryParse(units[0].substring(1));
          _assert(
            slot != null,
            'Invalid ${isReg ? 'slot' : 'index'} format: $arg',
            src,
            line.$1,
          );
          final offset = units.length > 1 ? int.tryParse(units[1]) : 0;
          _assert(offset != null, 'Invalid offset format: $arg', src, line.$1);

          if (isReg) {
            opBuffer.add(NyRegisterRef(slot: slot!, offset: offset!));
          } else {
            opBuffer.add(NyMemoryRef(index: slot!, offset: offset!));
          }
        } else {
          final nyint = int.tryParse(arg);
          _assert(nyint != null, 'Invalid integer format $arg', src, line.$1);
          opBuffer.add(NyInteger(value: nyint!));
        }
      }

      program.instructions.add(code!.create(opBuffer));
    }

    return program;
  }

  static void _assert(
    bool condition,
    String failMessage,
    String src,
    int lineIndex,
  ) {
    if (!condition) {
      throw FormatException('(${lineIndex + 1}) $failMessage', src);
    }
  }
}
