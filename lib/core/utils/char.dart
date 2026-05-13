abstract final class Char {
  static const int eof = -1;

  static const int r = 114;
  static const int m = 109;
  static const int f = 102;
  static const int colon = 58;
  static const int minus = 45;
  static const int period = 46;
  static const int underscore = 95;
  static const int hashtag = 35;

  static bool isWhitespace(int c) {
    return c == 32 || c == 9;
  }

  static bool isNewline(int c) {
    return c == 10;
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
