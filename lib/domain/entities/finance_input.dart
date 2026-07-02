import 'enums.dart';

/// يمثل جميع مدخلات المستخدم اللازمة لحساب التمويل العقاري
class FinanceInput {
  final String label; // اسم العرض/التمويل (يُستخدم في المقارنة والسيناريوهات)

  final double firstDownPayment; // المقدم الأول
  final double previousInstallmentValue; // قيمة القسط السابق
  final int previousInstallmentsCount; // عدد الأقساط السابقة

  final double bankDownPayment; // مقدم البنك
  final int financingYears; // مدة التمويل بالسنوات
  final double firstInstallmentValue; // قيمة أول قسط

  final InstallmentType installmentType; // ثابت / متغير

  // تُستخدم فقط عند اختيار "متغير"
  final double increaseRate; // نسبة الزيادة %
  final int increaseEveryYears; // الزيادة كل كام سنة
  final bool doesIncreaseStop; // هل تتوقف الزيادة؟
  final int stopAfterYears; // تتوقف بعد كام سنة
  final CalculationMethod calculationMethod; // Simple / Compound

  const FinanceInput({
    this.label = 'عرض تمويل',
    required this.firstDownPayment,
    required this.previousInstallmentValue,
    required this.previousInstallmentsCount,
    required this.bankDownPayment,
    required this.financingYears,
    required this.firstInstallmentValue,
    required this.installmentType,
    this.increaseRate = 0,
    this.increaseEveryYears = 1,
    this.doesIncreaseStop = false,
    this.stopAfterYears = 0,
    this.calculationMethod = CalculationMethod.simple,
  });

  FinanceInput copyWith({
    String? label,
    double? firstDownPayment,
    double? previousInstallmentValue,
    int? previousInstallmentsCount,
    double? bankDownPayment,
    int? financingYears,
    double? firstInstallmentValue,
    InstallmentType? installmentType,
    double? increaseRate,
    int? increaseEveryYears,
    bool? doesIncreaseStop,
    int? stopAfterYears,
    CalculationMethod? calculationMethod,
  }) {
    return FinanceInput(
      label: label ?? this.label,
      firstDownPayment: firstDownPayment ?? this.firstDownPayment,
      previousInstallmentValue:
          previousInstallmentValue ?? this.previousInstallmentValue,
      previousInstallmentsCount:
          previousInstallmentsCount ?? this.previousInstallmentsCount,
      bankDownPayment: bankDownPayment ?? this.bankDownPayment,
      financingYears: financingYears ?? this.financingYears,
      firstInstallmentValue:
          firstInstallmentValue ?? this.firstInstallmentValue,
      installmentType: installmentType ?? this.installmentType,
      increaseRate: increaseRate ?? this.increaseRate,
      increaseEveryYears: increaseEveryYears ?? this.increaseEveryYears,
      doesIncreaseStop: doesIncreaseStop ?? this.doesIncreaseStop,
      stopAfterYears: stopAfterYears ?? this.stopAfterYears,
      calculationMethod: calculationMethod ?? this.calculationMethod,
    );
  }

  factory FinanceInput.empty() => const FinanceInput(
        firstDownPayment: 0,
        previousInstallmentValue: 0,
        previousInstallmentsCount: 0,
        bankDownPayment: 0,
        financingYears: 20,
        firstInstallmentValue: 0,
        installmentType: InstallmentType.fixed,
        increaseEveryYears: 2,
        increaseRate: 5,
      );

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'firstDownPayment': firstDownPayment,
      'previousInstallmentValue': previousInstallmentValue,
      'previousInstallmentsCount': previousInstallmentsCount,
      'bankDownPayment': bankDownPayment,
      'financingYears': financingYears,
      'firstInstallmentValue': firstInstallmentValue,
      'installmentType': installmentType.index,
      'increaseRate': increaseRate,
      'increaseEveryYears': increaseEveryYears,
      'doesIncreaseStop': doesIncreaseStop,
      'stopAfterYears': stopAfterYears,
      'calculationMethod': calculationMethod.index,
    };
  }

  factory FinanceInput.fromMap(Map<dynamic, dynamic> map) {
    return FinanceInput(
      label: map['label'] as String? ?? 'عرض تمويل',
      firstDownPayment: (map['firstDownPayment'] as num).toDouble(),
      previousInstallmentValue:
          (map['previousInstallmentValue'] as num).toDouble(),
      previousInstallmentsCount: map['previousInstallmentsCount'] as int,
      bankDownPayment: (map['bankDownPayment'] as num).toDouble(),
      financingYears: map['financingYears'] as int,
      firstInstallmentValue: (map['firstInstallmentValue'] as num).toDouble(),
      installmentType: InstallmentType.values[map['installmentType'] as int],
      increaseRate: (map['increaseRate'] as num).toDouble(),
      increaseEveryYears: map['increaseEveryYears'] as int,
      doesIncreaseStop: map['doesIncreaseStop'] as bool,
      stopAfterYears: map['stopAfterYears'] as int,
      calculationMethod:
          CalculationMethod.values[map['calculationMethod'] as int],
    );
  }
}
