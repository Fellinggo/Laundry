class PinEntryModel {
  final List<
    int
  >
  digits;
  final bool isComplete;

  PinEntryModel({
    required this.digits,
    this.isComplete = false,
  });

  factory PinEntryModel.initial() {
    return PinEntryModel(
      digits: [],
      isComplete: false,
    );
  }

  String get pinString => digits
      .map(
        (
          d,
        ) => d.toString(),
      )
      .join();

  bool get isFull =>
      digits.length >=
      6;

  PinEntryModel addDigit(
    int digit,
  ) {
    if (isFull) return this;
    final newDigits =
        List<
            int
          >.from(
            digits,
          )
          ..add(
            digit,
          );
    return PinEntryModel(
      digits: newDigits,
      isComplete:
          newDigits.length ==
          6,
    );
  }

  PinEntryModel removeLastDigit() {
    if (digits.isEmpty) return this;
    final newDigits =
        List<
            int
          >.from(
            digits,
          )
          ..removeLast();
    return PinEntryModel(
      digits: newDigits,
      isComplete: false,
    );
  }

  PinEntryModel reset() {
    return PinEntryModel.initial();
  }
}
