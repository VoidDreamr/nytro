sealed class NyvmOperand {}

sealed class NyvmFloatLike implements NyvmOperand {}

class NyvmRegisterRef implements NyvmFloatLike {
  final int slot;
  final int offset;

  NyvmRegisterRef({required this.slot, required this.offset});
}

class NyvmMemoryRef implements NyvmOperand {
  final int index;
  final int offset;

  NyvmMemoryRef({required this.index, required this.offset});
}

class NyvmConstant implements NyvmFloatLike {
  final double value;

  NyvmConstant({required this.value});
}

class NyvmInteger implements NyvmOperand {
  final int value;

  NyvmInteger({required this.value});
}
