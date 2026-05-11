import 'dart:core';
import 'dart:io';
import 'package:nytro/core/instructions/ny_add_instr.dart';
import 'package:nytro/core/instructions/ny_alloc_instr.dart';
import 'package:nytro/core/instructions/ny_del_instr.dart';
import 'package:nytro/core/instructions/ny_div_instr.dart';
import 'package:nytro/core/instructions/ny_load_instr.dart';
import 'package:nytro/core/instructions/ny_mul_instr.dart';
import 'package:nytro/core/instructions/ny_sample_instr.dart';
import 'package:nytro/core/instructions/ny_store_instr.dart';
import 'package:nytro/core/instructions/ny_sub_instr.dart';
import 'package:nytro/core/instructions/ny_write_instr.dart';
import 'package:nytro/core/ny_type.dart';
import 'package:path/path.dart' as p;

void main() async {
  final src = _generateSource([
    NyInstrData(type: NyWriteInstr, mnemonic: 'WRITE'),
    NyInstrData(type: NyLoadInstr, mnemonic: 'LOAD'),
    NyInstrData(type: NyStoreInstr, mnemonic: 'STORE'),
    NyInstrData(type: NyAllocInstr, mnemonic: 'ALLOC'),
    NyInstrData(type: NyDelInstr, mnemonic: 'DEL'),
    NyInstrData(type: NyAddInstr, mnemonic: 'ADD', subTypes: NyTypes.all),
    NyInstrData(type: NySubInstr, mnemonic: 'SUB', subTypes: NyTypes.all),
    NyInstrData(type: NyMulInstr, mnemonic: 'MUL', subTypes: NyTypes.all),
    NyInstrData(type: NyDivInstr, mnemonic: 'DIV', subTypes: NyTypes.all),
    NyInstrData(type: NySampleInstr, mnemonic: 'SAMPLE_TEX2'),
  ]);

  await File(
    p.join(
      Directory.current.path,
      'lib',
      'core',
      'instructions',
      'ny_instr_set.g.dart',
    ),
  ).writeAsString(src);
  print('Successfully generated ny_instr_set.g.dart');
}

String _generateSource(List<NyInstrData> instrs) {
  final out = StringBuffer();

  out.writeln('// GENERATED CODE - DO NOT MODIFY');
  out.writeln();

  /// Imports
  out.writeln('''
import 'package:nytro/core/instructions/ny_instr.dart';
import 'package:nytro/core/instructions/ny_operand.dart';
import 'package:vector_math/vector_math.dart';
  ''');
  _writeImports(out, instrs);
  out.writeln();

  // Enum
  out.writeln('enum NyInstrSet {');

  _writeValues(out, instrs);
  out.writeln();

  _writeFactories(out, instrs);
  out.writeln();

  out.writeln('''
  static final Map<String, NyInstrSet> _mnemonics = {
    for (final code in NyInstrSet.values) code.mnemonic: code,
  };

  final String mnemonic;

  const NyInstrSet({required this.mnemonic});

  NyInstr create(List<NyOperand> ops) => _factories[this]!(ops);

  static NyInstrSet? fromMnemonic(String mnemonic) =>
      _mnemonics[mnemonic.toUpperCase()];
}
  ''');

  return out.toString();
}

void _writeImports(StringBuffer out, List<NyInstrData> instrs) {
  for (NyInstrData instr in instrs) {
    out.writeln('import \'package:${instr.import}\';');
  }
}

void _writeValues(StringBuffer out, List<NyInstrData> instrs) {
  final entries = <String>[];
  for (NyInstrData instr in instrs) {
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

void _writeFactories(StringBuffer out, List<NyInstrData> instrs) {
  out.writeln(
    '  static final Map<NyInstrSet, NyInstr Function(List<NyOperand>)> _factories = {',
  );

  final entries = <String>[];
  for (NyInstrData instr in instrs) {
    if (instr.subTypes == null) {
      entries.add('NyInstrSet.${instr.symbol}: ${instr.typeName}.fromOperands');
    } else {
      for (int i = 0; i < instr.subTypes!.length; i++) {
        entries.add(
          'NyInstrSet.${instr.getSymbol(i)}: ${instr.typeName}.fromOperands<${instr.subTypes![i].type}>',
        );
      }
    }
  }

  out.writeln('    ${entries.join(',\n    ')},');
  out.writeln('  };');
}

class NyInstrData {
  final Type type;
  final String mnemonic;
  final List<NyType>? subTypes;
  final String? importPath;

  String get symbol => getSymbol();
  String get typeName => type.toString().replaceAll('<dynamic>', '');
  String get filename => typeName
      .replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (m) => '${m[1]}_${m[2]}')
      .toLowerCase();
  String get import => importPath ?? "nytro/core/instructions/$filename.dart";

  NyInstrData({
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
