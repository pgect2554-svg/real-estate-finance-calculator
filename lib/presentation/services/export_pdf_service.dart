import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/utils/formatters.dart';
import '../../domain/entities/finance_result.dart';

class ExportPdfService {
  const ExportPdfService();

  Future<File> generate(FinanceResult result) async {
    final doc = pw.Document();
    final input = result.input;

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'تقرير حاسبة التمويل العقاري - ${input.label}',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Text('ملخص النتائج',
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          _summaryTable(result),
          pw.SizedBox(height: 20),
          pw.Text('الجدول السنوي الكامل',
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          _scheduleTable(result),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File(
        '${dir.path}/finance_report_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await doc.save());
    return file;
  }

  pw.Widget _summaryTable(FinanceResult r) {
    final rows = <List<String>>[
      ['إجمالي المقدمات', AppFormatters.currency(r.totalDownPayments)],
      [
        'إجمالي الأقساط السابقة',
        AppFormatters.currency(r.totalPreviousInstallments)
      ],
      [
        'إجمالي الأقساط المستقبلية',
        AppFormatters.currency(r.totalFutureInstallments)
      ],
      ['إجمالي التكلفة النهائية', AppFormatters.currency(r.totalFinalCost)],
      ['متوسط القسط', AppFormatters.currency(r.averageInstallment)],
      ['أعلى قسط', AppFormatters.currency(r.maxInstallment)],
      ['أقل قسط', AppFormatters.currency(r.minInstallment)],
    ];

    return pw.TableHelper.fromTextArray(
      headers: ['البند', 'القيمة'],
      data: rows,
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue50),
      cellAlignment: pw.Alignment.centerRight,
      headerAlignment: pw.Alignment.centerRight,
    );
  }

  pw.Widget _scheduleTable(FinanceResult r) {
    final rows = r.yearlySchedule
        .map((row) => [
              row.year.toString(),
              AppFormatters.currency(row.monthlyInstallment),
              AppFormatters.currency(row.yearTotal),
              AppFormatters.currency(row.increaseAmount),
              AppFormatters.currency(row.cumulativeTotal),
            ])
        .toList();

    return pw.TableHelper.fromTextArray(
      headers: [
        'السنة',
        'القسط الشهري',
        'إجمالي السنة',
        'الزيادة',
        'إجمالي متراكم'
      ],
      data: rows,
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue50),
      cellAlignment: pw.Alignment.centerRight,
      headerAlignment: pw.Alignment.centerRight,
      cellStyle: const pw.TextStyle(fontSize: 9),
    );
  }
}
