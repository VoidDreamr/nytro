import 'package:nytro/core/utils/char.dart';
import 'package:nytro/core/utils/string_reader.dart';

class NyLexer {
  static final _keywords = {'in', 'out'};
  static final _operators = {
    Char.equals,
    Char.plus,
    Char.minus,
    Char.asterisk,
    Char.slash,
  };
  static final _states = <NyLexerState, NyLexerFunc>{
    NyLexerState.start: _start,
    NyLexerState.ident: _ident,
    NyLexerState.number: _number,
    NyLexerState.numberPostDot: _numberPostDot,
  };

  static NyLexerState? _start(
    StringReader read,
    StringBuffer buffer,
    List<NyToken> tokens,
  ) {
    final c = read.peek();
    if (Char.isWhitespaceOrNewline(c) || c == Char.eof) {
      read.next();
      return NyLexerState.start;
    } else if (Char.isAlpha(c) || c == Char.underscore) {
      buffer.writeCharCode(read.next());
      return NyLexerState.ident;
    } else if (Char.isDigit(c)) {
      buffer.writeCharCode(read.next());
      return NyLexerState.number;
    } else if (c == Char.semicolon) {
      tokens.add((type: NyTokenType.eol, value: ';'));
      read.next();
      return NyLexerState.start;
    } else if (_operators.contains(c)) {
      tokens.add((type: NyTokenType.operator, value: String.fromCharCode(c)));
      read.next();
      return NyLexerState.start;
    }
    return null;
  }

  static NyLexerState? _ident(
    StringReader read,
    StringBuffer buffer,
    List<NyToken> tokens,
  ) {
    final c = read.peek();
    if (Char.isAlphaDigit(c) || c == Char.underscore) {
      buffer.writeCharCode(read.next());
      return NyLexerState.ident;
    } else if (_isTokenEscape(c)) {
      final val = buffer.toString();
      buffer.clear();

      tokens.add((
        type: _keywords.contains(val.toLowerCase())
            ? NyTokenType.keyword
            : NyTokenType.ident,
        value: val,
      ));
      return NyLexerState.start;
    }
    return null;
  }

  static NyLexerState? _number(
    StringReader read,
    StringBuffer buffer,
    List<NyToken> tokens,
  ) {
    final c = read.peek();
    if (Char.isDigit(c)) {
      buffer.writeCharCode(read.next());
      return NyLexerState.number;
    } else if (c == Char.period) {
      buffer.writeCharCode(read.next());
      return NyLexerState.numberPostDot;
    } else if (_isTokenEscape(c)) {
      final val = buffer.toString();
      buffer.clear();
      tokens.add((type: NyTokenType.number, value: val));
      return NyLexerState.start;
    }
    return null;
  }

  static NyLexerState? _numberPostDot(
    StringReader read,
    StringBuffer buffer,
    List<NyToken> tokens,
  ) {
    final c = read.peek();
    if (Char.isDigit(c)) {
      buffer.writeCharCode(read.next());
      return NyLexerState.number;
    } else if (_isTokenEscape(c)) {
      final val = buffer.toString();
      buffer.clear();
      tokens.add((type: NyTokenType.number, value: val));
      return NyLexerState.start;
    }
    return null;
  }

  static bool _isTokenEscape(int c) {
    return Char.isWhitespaceOrNewline(c) ||
        c == Char.semicolon ||
        c == Char.eof ||
        _operators.contains(c);
  }

  static List<NyToken> tokenize(String source) {
    final read = StringReader(source: source.replaceAll('\r', ''));

    NyLexerState state = NyLexerState.start;
    final buffer = StringBuffer();
    final tokens = <NyToken>[];

    while (!read.isEnd) {
      state = _step(state, read, buffer, tokens);
    }
    _step(state, read, buffer, tokens);

    return tokens;
  }

  static NyLexerState _step(
    NyLexerState state,
    StringReader read,
    StringBuffer buffer,
    List<NyToken> tokens,
  ) {
    return _states[state]!(read, buffer, tokens) ??
        (throw StateError(
          'Unexpected char ${read.peek()} at ${read.cursor.line}:${read.cursor.column}',
        ));
  }
}

enum NyTokenType { keyword, ident, number, operator, eol }

typedef NyToken = ({NyTokenType type, String value});

enum NyLexerState { start, ident, number, numberPostDot }

typedef NyLexerFunc =
    NyLexerState? Function(
      StringReader read,
      StringBuffer tokenBuffer,
      List<NyToken> tokens,
    );
