import 'package:nytro/core/instructions/ny_add_instr.dart';
import 'package:nytro/core/instructions/ny_alloc_instr.dart';
import 'package:nytro/core/instructions/ny_del_instr.dart';
import 'package:nytro/core/instructions/ny_load_instr.dart';
import 'package:nytro/core/instructions/ny_operand.dart';
import 'package:nytro/core/instructions/ny_store_instr.dart';
import 'package:nytro/core/instructions/ny_write_instr.dart';
import 'package:nytro/core/ny_program.dart';
import 'package:vector_math/vector_math.dart';

abstract class NyInstr {
  void execute(NyProgram program);

  static T expect<T>(NyOperand op, int argIndex) {
    if (op is T) {
      return op as T;
    }
    throw ArgumentError('Argument $argIndex should be a $T.');
  }
}

enum NyInstrCode {
  write(mnemonic: 'WRITE'),
  load(mnemonic: 'LOAD'),
  store(mnemonic: 'STORE'),
  alloc(mnemonic: 'ALLOC'),
  del(mnemonic: 'DEL'),
  addFloat(mnemonic: 'ADD_FLOAT'),
  addVec2(mnemonic: 'ADD_VEC2'),
  addVec3(mnemonic: 'ADD_VEC3'),
  addVec4(mnemonic: 'ADD_VEC4');

  static final Map<NyInstrCode, NyInstr Function(List<NyOperand>)> _factories =
      {
        NyInstrCode.write: NyWriteInstr.fromOperands,
        NyInstrCode.load: NyLoadInstr.fromOperands,
        NyInstrCode.store: NyStoreInstr.fromOperands,
        NyInstrCode.alloc: NyAllocInstr.fromOperands,
        NyInstrCode.del: NyDelInstr.fromOperands,
        NyInstrCode.addFloat: NyAddInstr.fromOperands<double>,
        NyInstrCode.addVec2: NyAddInstr.fromOperands<Vector2>,
        NyInstrCode.addVec3: NyAddInstr.fromOperands<Vector3>,
        NyInstrCode.addVec4: NyAddInstr.fromOperands<Vector4>,
      };

  static final Map<String, NyInstrCode> _mnemonics = {
    for (final code in NyInstrCode.values) code.mnemonic: code,
  };

  final String mnemonic;

  const NyInstrCode({required this.mnemonic});

  NyInstr create(List<NyOperand> ops) => _factories[this]!(ops);

  static NyInstrCode? fromMnemonic(String mnemonic) =>
      _mnemonics[mnemonic.toUpperCase()];
}
