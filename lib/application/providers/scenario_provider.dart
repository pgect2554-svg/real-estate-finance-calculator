import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/repositories/scenario_repository.dart';
import '../../data/repositories/scenario_repository_impl.dart';
import '../../domain/entities/finance_input.dart';
import '../../domain/entities/scenario.dart';

final scenarioRepositoryProvider = Provider<ScenarioRepository>((ref) {
  return ScenarioRepositoryImpl();
});

class ScenarioNotifier extends StateNotifier<List<Scenario>> {
  final ScenarioRepository _repository;
  final _uuid = const Uuid();

  ScenarioNotifier(this._repository) : super(const []) {
    refresh();
  }

  void refresh() {
    state = _repository.getAll();
  }

  Future<void> saveScenario(String name, FinanceInput input) async {
    final scenario = Scenario(
      id: _uuid.v4(),
      name: name,
      createdAt: DateTime.now(),
      input: input,
    );
    await _repository.save(scenario);
    refresh();
  }

  Future<void> deleteScenario(String id) async {
    await _repository.delete(id);
    refresh();
  }
}

final scenarioProvider =
    StateNotifierProvider<ScenarioNotifier, List<Scenario>>((ref) {
  final repository = ref.watch(scenarioRepositoryProvider);
  return ScenarioNotifier(repository);
});

/// قائمة السيناريوهات المُختارة حاليًا لأغراض المقارنة
final comparisonListProvider =
    StateNotifierProvider<ComparisonNotifier, List<FinanceInput>>((ref) {
  return ComparisonNotifier();
});

class ComparisonNotifier extends StateNotifier<List<FinanceInput>> {
  ComparisonNotifier() : super(const []);

  void add(FinanceInput input) {
    state = [...state, input];
  }

  void removeAt(int index) {
    final updated = [...state]..removeAt(index);
    state = updated;
  }

  void clear() => state = const [];
}
