abstract final class Char {
  static const int eof = -1;

  static const int tab = 9;
  static const int newline = 10;
  static const int ret = 13;
  static const int space = 32;
  static const int hashtag = 35;
  static const int asterisk = 42;
  static const int plus = 43;
  static const int minus = 45;
  static const int period = 46;
  static const int slash = 47;
  static const int colon = 58;
  static const int semicolon = 59;
  static const int equals = 61;
  static const int underscore = 95;
  static const int f = 102;
  static const int m = 109;
  static const int r = 114;

  static bool isWhitespace(int c) {
    return c == space || c == tab;
  }

  static bool isNewline(int c) {
    return c == newline || c == ret;
  }

  static bool isWhitespaceOrNewline(int c) {
    return isWhitespace(c) || isNewline(c);
  }

  static bool isDigit(int c) {
    return c >= 48 && c <= 57;
  }

  static bool isAlpha(int c) {
    return (c >= 65 && c <= 90) || (c >= 97 && c <= 122);
  }

  static bool isAlphaDigit(int c) {
    return isDigit(c) || isAlpha(c);
  }
}
