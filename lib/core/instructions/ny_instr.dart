import 'package:nytro/core/instructions/ny_operand.dart';
import 'package:nytro/core/instructions/ny_write_instr.dart';
import 'package:nytro/core/ny_program.dart';

abstract class NyInstr {
  void execute(NyProgram program);

  static void build(NyInstrCode code, List<NyOperand> operands) {}
}

enum NyInstrCode {
  write(mnemonic: 'WRITE');

  static final Map<NyInstrCode, NyInstr Function(List<NyOperand>)> _factories =
      {NyInstrCode.write: NyWriteInstr.fromOperands};

  final String mnemonic;

  const NyInstrCode({required this.mnemonic});

  NyInstr create(List<NyOperand> ops) => _factories[this]!(ops);
}
