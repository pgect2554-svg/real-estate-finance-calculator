import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/finance_input.dart';
import '../../domain/services/calculator_service.dart';
import '../state/calculator_state.dart';

final calculatorServiceProvider = Provider<CalculatorService>((ref) {
  return const CalculatorService();
});

class CalculatorNotifier extends StateNotifier<CalculatorState> {
  final CalculatorService _service;

  CalculatorNotifier(this._service) : super(CalculatorState.initial());

  void updateInput(FinanceInput input) {
    state = state.copyWith(input: input);
  }

  void loadInput(FinanceInput input) {
    final result = _service.calculate(input);
    state = CalculatorState(input: input, result: result);
  }

  void calculate() {
    final result = _service.calculate(state.input);
    state = state.copyWith(result: result);
  }

  void reset() {
    state = CalculatorState.initial();
  }
}

final calculatorProvider =
    StateNotifierProvider<CalculatorNotifier, CalculatorState>((ref) {
  final service = ref.watch(calculatorServiceProvider);
  return CalculatorNotifier(service);
});
