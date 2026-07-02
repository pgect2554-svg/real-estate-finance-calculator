import 'package:hive/hive.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/finance_input.dart';
import '../../domain/entities/scenario.dart';

/// نموذج التخزين الفعلي داخل Hive.
/// تم كتابة الـ TypeAdapter يدويًا لتفادي الحاجة إلى build_runner،
/// حتى يعمل المشروع مباشرة بدون خطوات توليد كود إضافية.
class ScenarioHiveModel {
  final String id;
  final String name;
  final DateTime createdAt;
  final Map<dynamic, dynamic> inputMap;

  ScenarioHiveModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.inputMap,
  });

  factory ScenarioHiveModel.fromEntity(Scenario scenario) {
    return ScenarioHiveModel(
      id: scenario.id,
      name: scenario.name,
      createdAt: scenario.createdAt,
      inputMap: scenario.input.toMap(),
    );
  }

  Scenario toEntity() {
    return Scenario(
      id: id,
      name: name,
      createdAt: createdAt,
      input: FinanceInput.fromMap(inputMap),
    );
  }
}

class ScenarioHiveAdapter extends TypeAdapter<ScenarioHiveModel> {
  @override
  final int typeId = AppConstants.scenarioTypeId;

  @override
  ScenarioHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScenarioHiveModel(
      id: fields[0] as String,
      name: fields[1] as String,
      createdAt: fields[2] as DateTime,
      inputMap: Map<dynamic, dynamic>.from(fields[3] as Map),
    );
  }

  @override
  void write(BinaryWriter writer, ScenarioHiveModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.inputMap);
  }
}
