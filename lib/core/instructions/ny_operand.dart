sealed class NyOperand {}

sealed class NyFloatLike implements NyOperand {}

class NyRegisterRef implements NyFloatLike {
  final int slot;
  final int offset;

  NyRegisterRef({required this.slot, required this.offset});
}

class NyMemoryRef implements NyOperand {
  final int index;
  final int offset;

  NyMemoryRef({required this.index, required this.offset});
}

class NyConstant implements NyFloatLike {
  final double value;

  NyConstant({required this.value});
}

class NyInteger implements NyOperand {
  final int value;

  NyInteger({required this.value});
}
