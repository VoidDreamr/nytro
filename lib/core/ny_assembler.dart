import 'package:nytro/core/instructions/ny_instr_set.g.dart';
import 'package:nytro/core/instructions/ny_operand.dart';
import 'package:nytro/core/ny_program.dart';
import 'package:nytro/core/ny_assembler_exception.dart';
import 'package:nytro/core/utils/char.dart';
import 'package:nytro/core/utils/string_reader.dart';

abstract final class NyAssembler {
  static NyProgram parse(String src) {
    src = src.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
    final read = StringReader(source: src);

    final program = NyProgram();
    final ops = <NyOperand>[];
    while (!read.isEnd) {
      // Leading whitespace and blank lines.
      if (_isEndOfLine(read)) {
        continue;
      }

      // Comments
      if (read.peek() == Char.hashtag) {
        _consumeLine(read);
        continue;
      }

      ops.clear();
      NyInstrSet code = _parseOpcode(read);

      while (!_isEndOfLine(read)) {
        ops.add(_parseOperand(read));
      }

      try {
        program.instructions.add(code.create(ops));
      } catch (e) {
        throw NyAssemblerException(message: '$e', cursor: read.cursor);
      }
    }

    return program;
  }

  static bool _isEndOfLine(StringReader read) {
    read.skipWhitespace();
    final c = read.peek();
    if (Char.isNewline(c)) {
      read.next();
      return true;
    } else {
      return c == Char.eof;
    }
  }

  static void _consumeLine(StringReader read) {
    while (!read.isEnd) {
      if (Char.isNewline(read.next())) {
        break;
      }
    }
  }

  static NyInstrSet _parseOpcode(StringReader read) {
    final token = StringBuffer();
    while (true) {
      final c = read.peek();
      if (Char.isAlphaDigit(c) || c == Char.underscore) {
        token.writeCharCode(read.next());
      } else if (c == Char.eof || Char.isWhitespace(c) || Char.isNewline(c)) {
        break;
      } else {
        throw NyAssemblerException.reject(c, read.cursor);
      }
    }

    final code = NyInstrSet.fromMnemonic(token.toString());
    if (code == null) {
      throw NyAssemblerException(
        message: 'Unknown opcode $token',
        cursor: read.cursor,
      );
    }

    return code;
  }

  static NyOperand _parseOperand(StringReader read) {
    return _tryParseConstant(read) ??
        _tryParseInteger(read) ??
        _tryParseRegisterRef(read) ??
        _tryParseMemoryRef(read) ??
        (throw NyAssemblerException(
          message: 'Invalid operand',
          cursor: read.cursor,
        ));
  }

  static bool _isOperandEscape(int c) {
    return Char.isWhitespace(c) || Char.isNewline(c) || c == Char.eof;
  }

  static NyConstant? _tryParseConstant(StringReader read) {
    final start = read.cursor;
    final token = StringBuffer();

    if (read.peek() == Char.minus) {
      token.writeCharCode(read.next());
    }

    bool foundDigit = false;
    bool foundPeriod = false;
    while (true) {
      final c = read.peek();
      if (Char.isDigit(c)) {
        token.writeCharCode(read.next());
        foundDigit = true;
      } else if (c == Char.period && !foundPeriod && foundDigit) {
        foundPeriod = true;
        token.writeCharCode(read.next());
      } else if (c == Char.f && foundDigit) {
        read.next();
        break;
      } else {
        read.cursor = start;
        return null;
      }
    }

    if (!_isOperandEscape(read.peek())) {
      read.cursor = start;
      return null;
    } else {
      double? value = double.tryParse(token.toString());
      if (value == null) {
        read.cursor = start;
        return null;
      } else {
        return NyConstant(value: value);
      }
    }
  }

  static NyInteger? _tryParseInteger(StringReader read) {
    final start = read.cursor;
    final token = StringBuffer();

    while (true) {
      final c = read.peek();
      if (Char.isDigit(c)) {
        token.writeCharCode(read.next());
      } else if (_isOperandEscape(c)) {
        break;
      } else {
        read.cursor = start;
        return null;
      }
    }

    int? value = int.tryParse(token.toString());
    if (value == null) {
      read.cursor = start;
      return null;
    } else {
      return NyInteger(value: value);
    }
  }

  static T? _tryParseRef<T extends NyOperand>(
    StringReader read,
    int prefixCode,
    T Function(int index, int offset) builder,
  ) {
    final start = read.cursor;
    if (read.peek() != prefixCode) {
      return null;
    } else {
      read.next();
    }

    final indexToken = StringBuffer();
    final offsetToken = StringBuffer();
    bool foundColon = false;
    bool foundDigit = false;
    while (true) {
      final c = read.peek();
      if (Char.isDigit(c)) {
        (foundColon ? offsetToken : indexToken).writeCharCode(read.next());
        foundDigit = true;
      } else if (foundDigit && !foundColon && c == Char.colon) {
        foundColon = true;
        foundDigit = false;
        read.next();
      } else if (foundDigit && _isOperandEscape(c)) {
        break;
      } else {
        read.cursor = start;
        return null;
      }
    }

    int? index = int.tryParse(indexToken.toString());
    int? offset = offsetToken.isEmpty
        ? 0
        : int.tryParse(offsetToken.toString());

    if (index == null || offset == null) {
      read.cursor = start;
      return null;
    } else {
      return builder(index, offset);
    }
  }

  static NyMemoryRef? _tryParseMemoryRef(StringReader read) => _tryParseRef(
    read,
    Char.m,
    (index, offset) => NyMemoryRef(index: index, offset: offset),
  );

  static NyRegisterRef? _tryParseRegisterRef(StringReader read) => _tryParseRef(
    read,
    Char.r,
    (slot, offset) => NyRegisterRef(slot: slot, offset: offset),
  );
}
