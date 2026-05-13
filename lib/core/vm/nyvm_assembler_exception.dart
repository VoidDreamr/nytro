import 'package:nytro/core/utils/string_reader.dart';

class NyvmAssemblerException implements Exception {
  final String message;
  final Cursor cursor;

  NyvmAssemblerException({required this.message, required this.cursor});

  @override
  String toString() {
    return 'Compile Error (${cursor.line + 1}:${cursor.column + 1}): $message';
  }

  static NyvmAssemblerException reject(int c, Cursor cursor) {
    return NyvmAssemblerException(
      message: 'Unexpected token \'${String.fromCharCode(c)}\'',
      cursor: cursor,
    );
  }
}
