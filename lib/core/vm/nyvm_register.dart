import 'dart:typed_data';

import 'package:nytro/core/vm/instruction/nyvm_operand.dart';
import 'package:nytro/core/vm/nyvm_type.dart';

class NyvmRegister {
  static const int slotCount = 16;
  static const int laneCount = 16;

  final Float32List buffer = Float32List(slotCount * laneCount);

  int index(int slot, int offset) {
    return slot * laneCount + offset;
  }

  /// Gets the current value at `slot:offset`.
  double get(int slot, int offset) {
    return buffer[index(slot, offset)];
  }

  /// Sets the current value at `slot:offset`.
  void set(int slot, int offset, double value) {
    buffer[index(slot, offset)] = value;
  }

  void setRange(
    int slot,
    int offset,
    Iterable<double> values,
    int vOffset,
    int count,
  ) {
    buffer.setRange(
      index(slot, offset),
      index(slot, offset) + count,
      values,
      vOffset,
    );
  }

  /// Writes a list of values at `slot:offset`.
  void write(int slot, int offset, List<double> values) {
    for (int i = 0; i < laneCount - offset && i < values.length; i++) {
      set(slot, offset + i, values[i]);
    }
  }

  /// Sets all values to 0.
  void reset() {
    buffer.fillRange(0, buffer.length, 0);
  }

  T resolve<T>(NyvmFloatLike op, T? out) {
    return resolveTyped(op, NyvmTypes.find<T>(), out);
  }

  T resolveTyped<T>(NyvmFloatLike op, NyvmType<T> type, T? out) {
    if (op is NyvmConstant && T == double) {
      return op.value as T;
    } else if (op is NyvmRegisterRef) {
      return type.unpack(buffer, index(op.slot, op.offset), out);
    }
    throw ArgumentError('Type/operand mismatch: $T, ${op.runtimeType}');
  }

  String dump() {
    var dump = '';
    var line = 'r0  ';
    for (int i = 0; i < buffer.length; i++) {
      if (i != 0 && i % 16 == 0) {
        dump = '$dump${line.substring(0, line.length - 2)}\n';
        line = 'r${(i / 16).toStringAsFixed(0)}  ';
      }
      line = '$line${buffer[i]}, ';
    }
    return '$dump${line.substring(0, line.length - 2)}';
  }
}
