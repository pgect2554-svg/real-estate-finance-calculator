import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/providers/calculator_provider.dart';
import '../../../application/providers/scenario_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../calculator/calculator_screen.dart';
import '../results/results_screen.dart';

class ScenariosScreen extends ConsumerWidget {
  const ScenariosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scenarios = ref.watch(scenarioProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('السيناريوهات المحفوظة')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CalculatorScreen()),
        ),
        icon: const Icon(Icons.add_rounded),
        label: const Text('سيناريو جديد'),
      ),
      body: scenarios.isEmpty
          ? const Center(child: Text('لا توجد سيناريوهات محفوظة بعد'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: scenarios.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final s = scenarios[index];
                return Card(
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.bookmark_rounded, color: Colors.white),
                    ),
                    title: Text(s.name,
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                    subtitle: Text(
                        '${AppFormatters.date(s.createdAt)} • ${s.input.financingYears} سنة'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline_rounded,
                          color: AppColors.danger),
                      onPressed: () => ref
                          .read(scenarioProvider.notifier)
                          .deleteScenario(s.id),
                    ),
                    onTap: () {
                      ref.read(calculatorProvider.notifier).loadInput(s.input);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ResultsScreen()),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
