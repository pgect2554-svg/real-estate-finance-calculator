import '../../domain/entities/scenario.dart';

/// عقد التعامل مع بيانات السيناريوهات، بحيث تظل طبقة الـ Application
/// غير مرتبطة بتفاصيل التخزين الفعلية (Hive أو غيره)
abstract class ScenarioRepository {
  List<Scenario> getAll();
  Future<void> save(Scenario scenario);
  Future<void> delete(String id);
  Scenario? getById(String id);
}
