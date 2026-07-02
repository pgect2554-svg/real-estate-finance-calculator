import 'finance_input.dart';
import 'year_row.dart';

/// نتيجة حساب كاملة لعملية تمويل واحدة
class FinanceResult {
  final FinanceInput input;
  final List<YearRow> yearlySchedule;

  final double totalDownPayments; // إجمالي المقدمات
  final double totalPreviousInstallments; // إجمالي الأقساط السابقة
  final double totalFutureInstallments; // إجمالي الأقساط المستقبلية
  final double totalFinalCost; // إجمالي التكلفة النهائية
  final double averageInstallment; // متوسط القسط
  final double maxInstallment; // أعلى قسط
  final double minInstallment; // أقل قسط

  const FinanceResult({
    required this.input,
    required this.yearlySchedule,
    required this.totalDownPayments,
    required this.totalPreviousInstallments,
    required this.totalFutureInstallments,
    required this.totalFinalCost,
    required this.averageInstallment,
    required this.maxInstallment,
    required this.minInstallment,
  });
}
