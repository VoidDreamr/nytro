import 'dart:typed_data';

class NyProgram {
  final Register register = Register();
  final List<NyInstruction> instructions = [];

  void Run() {}
}

abstract class NyInstruction {
  void execute(NyProgram program);
}

class Register {
  static const int registerCount = 16;
  static const int laneCount = 16;

  final Float32List buffer = Float32List(registerCount * laneCount);

  double operator [](int index) {
    return buffer[index];
  }

  void operator []=(int index, double value) {
    buffer[index] = value;
  }

  void mov(int src, int dest) {
    buffer.setRange(dest * 16, dest * 16 + 16, buffer, src * 16);
  }

  void movFloat(int src, int srcOffset, int dest, int destOffset) {
    buffer[dest * 16 + destOffset] = buffer[src * 16 + srcOffset];
  }

  void reset() {
    buffer.fillRange(0, buffer.length, 0);
  }
}
