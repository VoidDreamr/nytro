import 'package:nytro/core/utils/char.dart';

class StringReader {
  final String source;

  Cursor cursor = (index: 0, line: 0, column: 0);
  bool get isEnd => cursor.index >= source.length;

  StringReader({required this.source});

  void skipWhitespace() {
    while (!isEnd && (Char.isWhitespace(peek()))) {
      next();
    }
  }

  int next() {
    final c = peek();
    if (c == Char.eof) return c;

    int index = cursor.index + 1;
    int line = cursor.line;
    int column = cursor.column;
    if (Char.isNewline(c)) {
      line++;
      column = 0;
    } else {
      column++;
    }

    cursor = (index: index, line: line, column: column);
    return c;
  }

  int peek() => isEnd ? Char.eof : source.codeUnitAt(cursor.index);
}

typedef Cursor = ({int index, int line, int column});
