import 'package:nytro/core/utils/string_reader.dart';

class NyAssemblerException implements Exception {
  final String message;
  final Cursor cursor;

  NyAssemblerException({required this.message, required this.cursor});

  @override
  String toString() {
    return 'Compile Error (${cursor.line + 1}:${cursor.column + 1}): $message';
  }

  static NyAssemblerException reject(int c, Cursor cursor) {
    return NyAssemblerException(
      message: 'Unexpected token \'${String.fromCharCode(c)}\'',
      cursor: cursor,
    );
  }
}
