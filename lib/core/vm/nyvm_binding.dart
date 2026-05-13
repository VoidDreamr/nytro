import 'package:nytro/core/vm/nyvm_program.dart';
import 'package:nytro/core/vm/nyvm_type.dart';

class NyvmBinding<T> {
  final NyvmType<T> type;
  final NyvmProgram program;
  final int index;
  final int offset;

  NyvmBinding({
    required this.type,
    required this.program,
    required this.index,
    required this.offset,
  });

  void write(T value) {
    type.pack(value, program.memory[index]!, offset);
  }

  T read([T? out]) {
    return type.unpack(program.memory[index]!, offset, out);
  }
}
