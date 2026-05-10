abstract final class NyLayout {
  static List<double> pack(dynamic value) {
    if (value is double) {
      return [value];
    } else {
      throw ArgumentError('Cannot pack value of type ${value.runtimeType}.');
    }
  }
}
