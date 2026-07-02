import '../../domain/entities/scenario.dart';
import '../local/hive_boxes.dart';
import '../models/scenario_hive_model.dart';
import 'scenario_repository.dart';

class ScenarioRepositoryImpl implements ScenarioRepository {
  @override
  List<Scenario> getAll() {
    final box = HiveBoxes.scenarios;
    return box.values
        .map((model) => model.toEntity())
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<void> save(Scenario scenario) async {
    final box = HiveBoxes.scenarios;
    await box.put(scenario.id, ScenarioHiveModel.fromEntity(scenario));
  }

  @override
  Future<void> delete(String id) async {
    final box = HiveBoxes.scenarios;
    await box.delete(id);
  }

  @override
  Scenario? getById(String id) {
    final box = HiveBoxes.scenarios;
    return box.get(id)?.toEntity();
  }
}
