import 'package:nytro/core/ny_program.dart';
import 'package:nytro/core/ny_type.dart';

class NyBinding<T> {
  final NyType<T> type;
  final NyProgram program;
  final int index;
  final int offset;

  NyBinding({
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
