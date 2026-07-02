import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/finance_result.dart';

class ExportExcelService {
  const ExportExcelService();

  Future<File> generate(FinanceResult result) async {
    final excel = Excel.createExcel();
    final summarySheet = excel['الملخص'];
    final scheduleSheet = excel['الجدول السنوي'];
    excel.delete('Sheet1');

    // ورقة الملخص
    summarySheet.appendRow(
        [const TextCellValue('البند'), const TextCellValue('القيمة')]);
    summarySheet.appendRow([
      const TextCellValue('إجمالي المقدمات'),
      DoubleCellValue(result.totalDownPayments)
    ]);
    summarySheet.appendRow([
      const TextCellValue('إجمالي الأقساط السابقة'),
      DoubleCellValue(result.totalPreviousInstallments)
    ]);
    summarySheet.appendRow([
      const TextCellValue('إجمالي الأقساط المستقبلية'),
      DoubleCellValue(result.totalFutureInstallments)
    ]);
    summarySheet.appendRow([
      const TextCellValue('إجمالي التكلفة النهائية'),
      DoubleCellValue(result.totalFinalCost)
    ]);
    summarySheet.appendRow([
      const TextCellValue('متوسط القسط'),
      DoubleCellValue(result.averageInstallment)
    ]);
    summarySheet.appendRow([
      const TextCellValue('أعلى قسط'),
      DoubleCellValue(result.maxInstallment)
    ]);
    summarySheet.appendRow([
      const TextCellValue('أقل قسط'),
      DoubleCellValue(result.minInstallment)
    ]);

    // ورقة الجدول السنوي
    scheduleSheet.appendRow([
      const TextCellValue('السنة'),
      const TextCellValue('القسط الشهري'),
      const TextCellValue('إجمالي السنة'),
      const TextCellValue('الزيادة'),
      const TextCellValue('إجمالي متراكم'),
    ]);
    for (final row in result.yearlySchedule) {
      scheduleSheet.appendRow([
        IntCellValue(row.year),
        DoubleCellValue(row.monthlyInstallment),
        DoubleCellValue(row.yearTotal),
        DoubleCellValue(row.increaseAmount),
        DoubleCellValue(row.cumulativeTotal),
      ]);
    }

    final dir = await getApplicationDocumentsDirectory();
    final file = File(
        '${dir.path}/finance_report_${DateTime.now().millisecondsSinceEpoch}.xlsx');
    final bytes = excel.encode();
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }
    return file;
  }
}
