import 'dart:core';
import 'dart:io';
import 'package:nytro/core/vm/instruction/nyvm_add_instr.dart';
import 'package:nytro/core/vm/instruction/nyvm_alloc_instr.dart';
import 'package:nytro/core/vm/instruction/nyvm_del_instr.dart';
import 'package:nytro/core/vm/instruction/nyvm_div_instr.dart';
import 'package:nytro/core/vm/instruction/nyvm_load_instr.dart';
import 'package:nytro/core/vm/instruction/nyvm_mul_instr.dart';
import 'package:nytro/core/vm/instruction/nyvm_sample_instr.dart';
import 'package:nytro/core/vm/instruction/nyvm_store_instr.dart';
import 'package:nytro/core/vm/instruction/nyvm_sub_instr.dart';
import 'package:nytro/core/vm/instruction/nyvm_write_instr.dart';
import 'package:nytro/core/vm/nyvm_type.dart';
import 'package:path/path.dart' as p;

void main() async {
  final src = _generateSource([
    NyvmInstrData(type: NyvmWriteInstr, mnemonic: 'WRITE'),
    NyvmInstrData(type: NyvmLoadInstr, mnemonic: 'LOAD'),
    NyvmInstrData(type: NyvmStoreInstr, mnemonic: 'STORE'),
    NyvmInstrData(type: NyvmAllocInstr, mnemonic: 'ALLOC'),
    NyvmInstrData(type: NyvmDelInstr, mnemonic: 'DEL'),
    NyvmInstrData(type: NyvmAddInstr, mnemonic: 'ADD', subTypes: NyvmTypes.all),
    NyvmInstrData(type: NyvmSubInstr, mnemonic: 'SUB', subTypes: NyvmTypes.all),
    NyvmInstrData(type: NyvmMulInstr, mnemonic: 'MUL', subTypes: NyvmTypes.all),
    NyvmInstrData(type: NyvmDivInstr, mnemonic: 'DIV', subTypes: NyvmTypes.all),
    NyvmInstrData(type: NyvmSampleInstr, mnemonic: 'SAMPLE_TEX2'),
  ]);

  await File(
    p.join(
      Directory.current.path,
      'lib',
      'core',
      'vm',
      'instruction',
      'nyvm_instr_code.g.dart',
    ),
  ).writeAsString(src);
  print('Successfully generated ny_instr_code.g.dart');
}

String _generateSource(List<NyvmInstrData> instrs) {
  final out = StringBuffer();

  out.writeln('// GENERATED CODE - DO NOT MODIFY');
  out.writeln();

  /// Imports
  out.writeln('''
import 'package:nytro/core/vm/instruction/nyvm_instr.dart';
import 'package:nytro/core/vm/instruction/nyvm_operand.dart';
import 'package:vector_math/vector_math.dart';
  ''');
  _writeImports(out, instrs);
  out.writeln();

  // Enum
  out.writeln('enum NyvmInstrCode {');

  _writeValues(out, instrs);
  out.writeln();

  _writeFactories(out, instrs);
  out.writeln();

  out.writeln('''
  static final Map<String, NyvmInstrCode> _mnemonics = {
    for (final code in NyvmInstrCode.values) code.mnemonic: code,
  };

  final String mnemonic;

  const NyvmInstrCode({required this.mnemonic});

  NyvmInstr create(List<NyvmOperand> ops) => _factories[this]!(ops);

  static NyvmInstrCode? fromMnemonic(String mnemonic) =>
      _mnemonics[mnemonic.toUpperCase()];
}
  ''');

  return out.toString();
}

void _writeImports(StringBuffer out, List<NyvmInstrData> instrs) {
  for (NyvmInstrData instr in instrs) {
    out.writeln('import \'package:${instr.import}\';');
  }
}

void _writeValues(StringBuffer out, List<NyvmInstrData> instrs) {
  final entries = <String>[];
  for (NyvmInstrData instr in instrs) {
    if (instr.subTypes == null) {
      entries.add('${instr.symbol}(mnemonic: \'${instr.mnemonic}\')');
    } else {
      for (int i = 0; i < instr.subTypes!.length; i++) {
        entries.add(
          '${instr.getSymbol(i)}(mnemonic: \'${instr.getMnemonic(i)}\')',
        );
      }
    }
  }
  out.writeln('  ${entries.join(',\n  ')};');
}

void _writeFactories(StringBuffer out, List<NyvmInstrData> instrs) {
  out.writeln(
    '  static final Map<NyvmInstrCode, NyvmInstr Function(List<NyvmOperand>)> _factories = {',
  );

  final entries = <String>[];
  for (NyvmInstrData instr in instrs) {
    if (instr.subTypes == null) {
      entries.add(
        'NyvmInstrCode.${instr.symbol}: ${instr.typeName}.fromOperands',
      );
    } else {
      for (int i = 0; i < instr.subTypes!.length; i++) {
        entries.add(
          'NyvmInstrCode.${instr.getSymbol(i)}: ${instr.typeName}.fromOperands<${instr.subTypes![i].type}>',
        );
      }
    }
  }

  out.writeln('    ${entries.join(',\n    ')},');
  out.writeln('  };');
}

class NyvmInstrData {
  final Type type;
  final String mnemonic;
  final List<NyvmType>? subTypes;
  final String? importPath;

  String get symbol => getSymbol();
  String get typeName => type.toString().replaceAll('<dynamic>', '');
  String get filename => typeName
      .replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (m) => '${m[1]}_${m[2]}')
      .toLowerCase();
  String get import => importPath ?? "nytro/core/vm/instruction/$filename.dart";

  NyvmInstrData({
    required this.type,
    required this.mnemonic,
    this.importPath,
    this.subTypes,
  });

  String getMnemonic([int? index]) {
    if (index == null) {
      return mnemonic;
    } else {
      return '${mnemonic}_${subTypes![index].suffix}';
    }
  }

  String getSymbol([int? index]) {
    final parts = getMnemonic(index).toLowerCase().split('_');
    return parts.first +
        parts.skip(1).map((p) => p[0].toUpperCase() + p.substring(1)).join();
  }
}
