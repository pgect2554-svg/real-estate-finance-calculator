import '../../domain/entities/finance_input.dart';
import '../../domain/entities/finance_result.dart';

class CalculatorState {
  final FinanceInput input;
  final FinanceResult? result;

  const CalculatorState({
    required this.input,
    this.result,
  });

  factory CalculatorState.initial() => CalculatorState(
        input: FinanceInput.empty(),
      );

  CalculatorState copyWith({
    FinanceInput? input,
    FinanceResult? result,
  }) {
    return CalculatorState(
      input: input ?? this.input,
      result: result ?? this.result,
    );
  }
}
