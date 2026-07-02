import 'dart:io';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {
  const ShareService();

  Future<void> shareFile(File file, {String? text}) async {
    await Share.shareXFiles(
      [XFile(file.path)],
      text: text ?? 'تقرير حاسبة التمويل العقاري',
    );
  }

  Future<void> printPdf(File file) async {
    final bytes = await file.readAsBytes();
    await Printing.layoutPdf(onLayout: (_) async => bytes);
  }
}
