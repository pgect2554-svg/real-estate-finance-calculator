import 'dart:math' as math;

import '../entities/enums.dart';
import '../entities/finance_input.dart';
import '../entities/finance_result.dart';
import '../entities/year_row.dart';

/// خدمة مركزية تحتوي على كل المعادلات المالية الخاصة بحاسبة التمويل العقاري.
/// أي منطق حسابي جديد يجب أن يُضاف هنا فقط، حتى تظل الشاشات (Presentation)
/// خالية تمامًا من أي منطق أعمال.
class CalculatorService {
  const CalculatorService();

  /// يحسب قيمة القسط الشهري لسنة معينة بناءً على مدخلات التمويل.
  double installmentForYear(FinanceInput input, int year) {
    if (input.installmentType == InstallmentType.fixed) {
      return input.firstInstallmentValue;
    }

    final increaseEvery =
        input.increaseEveryYears <= 0 ? 1 : input.increaseEveryYears;

    // السنة "الفعالة" لحساب عدد مرات الزيادة، مع مراعاة توقف الزيادة إن وُجد
    int effectiveYear = year;
    if (input.doesIncreaseStop && input.stopAfterYears > 0) {
      effectiveYear = math.min(year, input.stopAfterYears);
    }

    final int steps = ((effectiveYear - 1) / increaseEvery).floor();

    if (steps <= 0) return input.firstInstallmentValue;

    switch (input.calculationMethod) {
      case CalculationMethod.simple:
        // زيادة بسيطة: نسبة مئوية من القسط الأول تُضاف في كل مرة
        final increaseValue =
            input.firstInstallmentValue * (input.increaseRate / 100);
        return input.firstInstallmentValue + (increaseValue * steps);
      case CalculationMethod.compound:
        // زيادة مركبة: النسبة تُطبق على آخر قيمة تراكميًا
        final factor = math.pow(1 + (input.increaseRate / 100), steps);
        return input.firstInstallmentValue * factor;
    }
  }

  /// يبني الجدول السنوي الكامل لخطة التمويل
  List<YearRow> buildYearlySchedule(FinanceInput input) {
    final List<YearRow> rows = [];
    double previousInstallment = 0;
    double cumulative =
        input.firstDownPayment + input.bankDownPayment +
            (input.previousInstallmentValue * input.previousInstallmentsCount);

    for (int year = 1; year <= input.financingYears; year++) {
      final monthly = installmentForYear(input, year);
      final yearTotal = monthly * 12;
      final increaseAmount = year == 1 ? 0.0 : (monthly - previousInstallment);
      cumulative += yearTotal;

      rows.add(
        YearRow(
          year: year,
          monthlyInstallment: monthly,
          yearTotal: yearTotal,
          increaseAmount: increaseAmount,
          cumulativeTotal: cumulative,
        ),
      );

      previousInstallment = monthly;
    }

    return rows;
  }

  /// يحسب النتيجة الكاملة (الملخص + الجدول السنوي) لعملية تمويل واحدة
  FinanceResult calculate(FinanceInput input) {
    final schedule = buildYearlySchedule(input);

    final totalDownPayments = input.firstDownPayment + input.bankDownPayment;
    final totalPreviousInstallments =
        input.previousInstallmentValue * input.previousInstallmentsCount;
    final totalFutureInstallments =
        schedule.fold<double>(0, (sum, row) => sum + row.yearTotal);
    final totalFinalCost = totalDownPayments +
        totalPreviousInstallments +
        totalFutureInstallments;

    final monthlyValues = schedule.map((r) => r.monthlyInstallment).toList();
    final averageInstallment = monthlyValues.isEmpty
        ? 0.0
        : monthlyValues.reduce((a, b) => a + b) / monthlyValues.length;
    final maxInstallment =
        monthlyValues.isEmpty ? 0.0 : monthlyValues.reduce(math.max);
    final minInstallment =
        monthlyValues.isEmpty ? 0.0 : monthlyValues.reduce(math.min);

    return FinanceResult(
      input: input,
      yearlySchedule: schedule,
      totalDownPayments: totalDownPayments,
      totalPreviousInstallments: totalPreviousInstallments,
      totalFutureInstallments: totalFutureInstallments,
      totalFinalCost: totalFinalCost,
      averageInstallment: averageInstallment,
      maxInstallment: maxInstallment,
      minInstallment: minInstallment,
    );
  }

  /// يقارن بين عدة نتائج تمويل ويعيد ترتيبها من الأرخص إلى الأغلى
  List<FinanceResult> rankByTotalCost(List<FinanceResult> results) {
    final sorted = [...results];
    sorted.sort((a, b) => a.totalFinalCost.compareTo(b.totalFinalCost));
    return sorted;
  }
}
