import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/providers/calculator_provider.dart';
import '../../../application/providers/scenario_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../services/export_excel_service.dart';
import '../../services/export_pdf_service.dart';
import '../../services/share_service.dart';
import '../../widgets/stat_card.dart';
import '../charts/charts_screen.dart';
import '../schedule/schedule_screen.dart';

class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({super.key});

  Future<void> _saveScenario(BuildContext context, WidgetRef ref) async {
    final input = ref.read(calculatorProvider).input;
    final controller = TextEditingController(text: input.label);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حفظ السيناريو'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'اسم السيناريو'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
    if (name != null && name.trim().isNotEmpty) {
      await ref
          .read(scenarioProvider.notifier)
          .saveScenario(name.trim(), input);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ السيناريو بنجاح')),
        );
      }
    }
  }

  Future<void> _exportPdf(BuildContext context, WidgetRef ref) async {
    final result = ref.read(calculatorProvider).result;
    if (result == null) return;
    final file = await const ExportPdfService().generate(result);
    if (context.mounted) {
      await const ShareService().shareFile(file, text: 'تقرير PDF للتمويل');
    }
  }

  Future<void> _exportExcel(BuildContext context, WidgetRef ref) async {
    final result = ref.read(calculatorProvider).result;
    if (result == null) return;
    final file = await const ExportExcelService().generate(result);
    if (context.mounted) {
      await const ShareService().shareFile(file, text: 'تقرير Excel للتمويل');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calculatorProvider);
    final result = state.result;

    if (result == null) {
      return const Scaffold(
        body: Center(child: Text('لا توجد نتائج بعد')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('نتائج - ${result.input.label}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_add_rounded),
            onPressed: () => _saveScenario(context, ref),
            tooltip: 'حفظ السيناريو',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.35,
            children: [
              StatCard(
                title: 'إجمالي المقدمات',
                value: AppFormatters.currency(result.totalDownPayments),
                icon: Icons.account_balance_wallet_rounded,
                color: AppColors.primary,
              ),
              StatCard(
                title: 'إجمالي الأقساط السابقة',
                value:
                    AppFormatters.currency(result.totalPreviousInstallments),
                icon: Icons.history_rounded,
                color: AppColors.secondary,
              ),
              StatCard(
                title: 'إجمالي الأقساط المستقبلية',
                value: AppFormatters.currency(result.totalFutureInstallments),
                icon: Icons.upcoming_rounded,
                color: AppColors.warning,
              ),
              StatCard(
                title: 'إجمالي التكلفة النهائية',
                value: AppFormatters.currency(result.totalFinalCost),
                icon: Icons.summarize_rounded,
                color: AppColors.danger,
              ),
              StatCard(
                title: 'متوسط القسط',
                value: AppFormatters.currency(result.averageInstallment),
                icon: Icons.equalizer_rounded,
                color: AppColors.accentGold,
              ),
              StatCard(
                title: 'أعلى / أقل قسط',
                value:
                    '${AppFormatters.currency(result.maxInstallment)} / ${AppFormatters.currency(result.minInstallment)}',
                icon: Icons.swap_vert_rounded,
                color: AppColors.primaryLight,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ScheduleScreen(result: result)),
                  ),
                  icon: const Icon(Icons.table_chart_rounded),
                  label: const Text('الجدول السنوي'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ChartsScreen(result: result)),
                  ),
                  icon: const Icon(Icons.insert_chart_rounded),
                  label: const Text('الرسوم البيانية'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _exportPdf(context, ref),
                  icon: const Icon(Icons.picture_as_pdf_rounded),
                  label: const Text('تصدير PDF'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _exportExcel(context, ref),
                  icon: const Icon(Icons.table_view_rounded),
                  label: const Text('تصدير Excel'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
