import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/finance_result.dart';
import '../../../domain/entities/year_row.dart';
import '../../widgets/section_card.dart';

class ChartsScreen extends StatelessWidget {
  final FinanceResult result;

  const ChartsScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الرسوم البيانية')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionCard(
            title: 'تطور القسط الشهري عبر السنوات',
            icon: Icons.show_chart_rounded,
            child: SizedBox(
              height: 260,
              child: SfCartesianChart(
                primaryXAxis: const CategoryAxis(),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries<YearRow, String>>[
                  LineSeries<YearRow, String>(
                    dataSource: result.yearlySchedule,
                    xValueMapper: (row, _) => 'س${row.year}',
                    yValueMapper: (row, _) => row.monthlyInstallment,
                    color: AppColors.primary,
                    markerSettings: const MarkerSettings(isVisible: true),
                    name: 'القسط الشهري',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SectionCard(
            title: 'إجمالي المدفوعات التراكمية',
            icon: Icons.stacked_line_chart_rounded,
            child: SizedBox(
              height: 260,
              child: SfCartesianChart(
                primaryXAxis: const CategoryAxis(),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries<YearRow, String>>[
                  AreaSeries<YearRow, String>(
                    dataSource: result.yearlySchedule,
                    xValueMapper: (row, _) => 'س${row.year}',
                    yValueMapper: (row, _) => row.cumulativeTotal,
                    color: AppColors.secondary.withOpacity(0.35),
                    borderColor: AppColors.secondary,
                    borderWidth: 2,
                    name: 'الإجمالي المتراكم',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SectionCard(
            title: 'إجمالي المدفوعات لكل سنة',
            icon: Icons.bar_chart_rounded,
            child: SizedBox(
              height: 260,
              child: SfCartesianChart(
                primaryXAxis: const CategoryAxis(),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries<YearRow, String>>[
                  ColumnSeries<YearRow, String>(
                    dataSource: result.yearlySchedule,
                    xValueMapper: (row, _) => 'س${row.year}',
                    yValueMapper: (row, _) => row.yearTotal,
                    color: AppColors.accentGold,
                    borderRadius: BorderRadius.circular(6),
                    name: 'إجمالي السنة',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
