import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../models/scenario_hive_model.dart';

class HiveBoxes {
  HiveBoxes._();

  static Box<ScenarioHiveModel>? _scenariosBox;

  static Box<ScenarioHiveModel> get scenarios {
    final box = _scenariosBox;
    if (box == null) {
      throw StateError('يجب استدعاء HiveBoxes.init() أولًا قبل الاستخدام');
    }
    return box;
  }

  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(AppConstants.scenarioTypeId)) {
      Hive.registerAdapter(ScenarioHiveAdapter());
    }
    _scenariosBox = await Hive.openBox<ScenarioHiveModel>(
      AppConstants.scenariosBoxName,
    );
  }
}
