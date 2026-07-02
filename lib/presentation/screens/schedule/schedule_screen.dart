import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../domain/entities/finance_result.dart';

class ScheduleScreen extends StatelessWidget {
  final FinanceResult result;

  const ScheduleScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('الجدول السنوي الكامل')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor:
                WidgetStateProperty.all(theme.colorScheme.primary.withOpacity(0.08)),
            columns: const [
              DataColumn(label: Text('السنة')),
              DataColumn(label: Text('القسط الشهري')),
              DataColumn(label: Text('إجمالي السنة')),
              DataColumn(label: Text('مقدار الزيادة')),
              DataColumn(label: Text('إجمالي متراكم')),
            ],
            rows: result.yearlySchedule
                .map(
                  (row) => DataRow(
                    cells: [
                      DataCell(Text(row.year.toString())),
                      DataCell(
                          Text(AppFormatters.currency(row.monthlyInstallment))),
                      DataCell(Text(AppFormatters.currency(row.yearTotal))),
                      DataCell(
                        Text(
                          row.increaseAmount > 0
                              ? '+${AppFormatters.currency(row.increaseAmount)}'
                              : '—',
                          style: TextStyle(
                            color: row.increaseAmount > 0
                                ? theme.colorScheme.error
                                : theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      DataCell(
                          Text(AppFormatters.currency(row.cumulativeTotal))),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
