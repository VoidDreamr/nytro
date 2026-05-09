import 'package:nytro/core/instructions/ny_instr.dart';
import 'package:nytro/core/instructions/ny_operand.dart';
import 'package:nytro/core/ny_program.dart';

void main(List<String> arguments) {
  final program = NyProgram();
  program.instructions.add(
    NyInstrCode.write.create([
      NyConstant(value: 1),
      NyRegisterRef(slot: 0, offset: 0),
    ]),
  );
  program.instructions.add(
    NyInstrCode.write.create([
      NyConstant(value: 2),
      NyRegisterRef(slot: 1, offset: 0),
    ]),
  );
  program.instructions.add(
    NyInstrCode.write.create([
      NyConstant(value: 3),
      NyRegisterRef(slot: 1, offset: 0),
      NyRegisterRef(slot: 1, offset: 1),
    ]),
  );

  program.run();
  print(program.register.dump());
}
