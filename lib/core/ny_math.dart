abstract final class NyMath {
  static T add<T>(T a, T b) {
    return ((a as dynamic) + (b as dynamic)) as T;
  }
}
