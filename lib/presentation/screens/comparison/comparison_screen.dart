import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/providers/calculator_provider.dart';
import '../../../application/providers/scenario_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../domain/entities/finance_result.dart';
import '../../widgets/section_card.dart';

class ComparisonScreen extends ConsumerWidget {
  const ComparisonScreen({super.key});

  void _showAddSheet(BuildContext context, WidgetRef ref) {
    final scenarios = ref.read(scenarioProvider);
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            Text('اختر سيناريو لإضافته للمقارنة',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            if (scenarios.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text('لا توجد سيناريوهات محفوظة بعد. قم بحفظ عملية حساب أولًا.'),
              ),
            for (final s in scenarios)
              ListTile(
                leading: const Icon(Icons.bookmark_rounded,
                    color: AppColors.primary),
                title: Text(s.name),
                subtitle: Text(AppFormatters.date(s.createdAt)),
                onTap: () {
                  ref.read(comparisonListProvider.notifier).add(s.input);
                  Navigator.pop(context);
                },
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inputs = ref.watch(comparisonListProvider);
    final service = ref.watch(calculatorServiceProvider);
    final results = inputs.map((i) => service.calculate(i)).toList();
    final ranked = service.rankByTotalCost(results);

    return Scaffold(
      appBar: AppBar(
        title: const Text('مقارنة التمويلات'),
        actions: [
          if (inputs.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_rounded),
              onPressed: () =>
                  ref.read(comparisonListProvider.notifier).clear(),
              tooltip: 'مسح الكل',
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSheet(context, ref),
        icon: const Icon(Icons.add_rounded),
        label: const Text('إضافة عرض'),
      ),
      body: results.isEmpty
          ? const _EmptyComparison()
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (ranked.isNotEmpty)
                  SectionCard(
                    title: 'أفضل عرض من حيث التكلفة الإجمالية',
                    icon: Icons.emoji_events_rounded,
                    child: _BestOfferTile(result: ranked.first),
                  ),
                const SizedBox(height: 16),
                Text('كل العروض (${results.length})',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                for (int i = 0; i < inputs.length; i++) ...[
                  _ComparisonCard(
                    result: results[i],
                    isBest: ranked.isNotEmpty &&
                        results[i].totalFinalCost ==
                            ranked.first.totalFinalCost,
                    onRemove: () =>
                        ref.read(comparisonListProvider.notifier).removeAt(i),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
    );
  }
}

class _BestOfferTile extends StatelessWidget {
  final FinanceResult result;

  const _BestOfferTile({required this.result});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          backgroundColor: AppColors.success,
          child: Icon(Icons.check_rounded, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(result.input.label,
                  style: const TextStyle(fontWeight: FontWeight.w800)),
              Text('إجمالي التكلفة: ${AppFormatters.currency(result.totalFinalCost)}'),
            ],
          ),
        ),
      ],
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  final FinanceResult result;
  final bool isBest;
  final VoidCallback onRemove;

  const _ComparisonCard({
    required this.result,
    required this.isBest,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isBest ? AppColors.success : AppColors.lightBorder,
          width: isBest ? 1.6 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(result.input.label,
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                ),
                if (isBest)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('الأفضل',
                        style: TextStyle(
                            color: AppColors.success,
                            fontWeight: FontWeight.w700,
                            fontSize: 12)),
                  ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18),
                  onPressed: onRemove,
                ),
              ],
            ),
            const Divider(height: 20),
            _row('إجمالي المقدمات', AppFormatters.currency(result.totalDownPayments)),
            _row('إجمالي الأقساط المستقبلية',
                AppFormatters.currency(result.totalFutureInstallments)),
            _row('متوسط القسط', AppFormatters.currency(result.averageInstallment)),
            _row('إجمالي التكلفة النهائية',
                AppFormatters.currency(result.totalFinalCost),
                bold: true),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(
              color: bold ? null : Colors.grey.shade600,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w500)),
          Text(value,
              style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w600)),
        ],
      ),
    );
  }
}

class _EmptyComparison extends StatelessWidget {
  const _EmptyComparison();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.compare_arrows_rounded,
              size: 56, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 12),
          const Text('أضف عروضًا للمقارنة بينها'),
        ],
      ),
    );
  }
}
