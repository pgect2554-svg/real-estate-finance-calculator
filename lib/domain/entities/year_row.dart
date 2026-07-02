/// يمثل صف واحد في الجدول السنوي لخطة التمويل
class YearRow {
  final int year; // السنة
  final double monthlyInstallment; // القسط الشهري لهذه السنة
  final double yearTotal; // إجمالي السنة (القسط × 12)
  final double increaseAmount; // مقدار الزيادة عن السنة السابقة
  final double cumulativeTotal; // إجمالي ما تم دفعه حتى تلك السنة (تراكمي)

  const YearRow({
    required this.year,
    required this.monthlyInstallment,
    required this.yearTotal,
    required this.increaseAmount,
    required this.cumulativeTotal,
  });
}
