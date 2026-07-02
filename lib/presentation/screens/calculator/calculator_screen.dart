import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/providers/calculator_provider.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/finance_input.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/section_card.dart';
import '../results/results_screen.dart';

class CalculatorScreen extends ConsumerStatefulWidget {
  final FinanceInput? initialInput;

  const CalculatorScreen({super.key, this.initialInput});

  @override
  ConsumerState<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends ConsumerState<CalculatorScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _labelCtrl;
  late final TextEditingController _firstDownPaymentCtrl;
  late final TextEditingController _previousInstallmentValueCtrl;
  late final TextEditingController _previousInstallmentsCountCtrl;
  late final TextEditingController _bankDownPaymentCtrl;
  late final TextEditingController _financingYearsCtrl;
  late final TextEditingController _firstInstallmentValueCtrl;
  late final TextEditingController _increaseRateCtrl;
  late final TextEditingController _increaseEveryYearsCtrl;
  late final TextEditingController _stopAfterYearsCtrl;

  InstallmentType _installmentType = InstallmentType.fixed;
  CalculationMethod _calculationMethod = CalculationMethod.simple;
  bool _doesIncreaseStop = false;

  @override
  void initState() {
    super.initState();
    final input = widget.initialInput ?? FinanceInput.empty();

    _labelCtrl = TextEditingController(text: input.label);
    _firstDownPaymentCtrl =
        TextEditingController(text: _fmt(input.firstDownPayment));
    _previousInstallmentValueCtrl =
        TextEditingController(text: _fmt(input.previousInstallmentValue));
    _previousInstallmentsCountCtrl =
        TextEditingController(text: input.previousInstallmentsCount.toString());
    _bankDownPaymentCtrl =
        TextEditingController(text: _fmt(input.bankDownPayment));
    _financingYearsCtrl =
        TextEditingController(text: input.financingYears.toString());
    _firstInstallmentValueCtrl =
        TextEditingController(text: _fmt(input.firstInstallmentValue));
    _increaseRateCtrl = TextEditingController(text: _fmt(input.increaseRate));
    _increaseEveryYearsCtrl =
        TextEditingController(text: input.increaseEveryYears.toString());
    _stopAfterYearsCtrl =
        TextEditingController(text: input.stopAfterYears.toString());

    _installmentType = input.installmentType;
    _calculationMethod = input.calculationMethod;
    _doesIncreaseStop = input.doesIncreaseStop;
  }

  String _fmt(double v) => v == 0 ? '' : v.toString();

  @override
  void dispose() {
    _labelCtrl.dispose();
    _firstDownPaymentCtrl.dispose();
    _previousInstallmentValueCtrl.dispose();
    _previousInstallmentsCountCtrl.dispose();
    _bankDownPaymentCtrl.dispose();
    _financingYearsCtrl.dispose();
    _firstInstallmentValueCtrl.dispose();
    _increaseRateCtrl.dispose();
    _increaseEveryYearsCtrl.dispose();
    _stopAfterYearsCtrl.dispose();
    super.dispose();
  }

  double _d(TextEditingController c) => double.tryParse(c.text.trim()) ?? 0;
  int _i(TextEditingController c) => int.tryParse(c.text.trim()) ?? 0;

  FinanceInput _buildInput() {
    return FinanceInput(
      label: _labelCtrl.text.trim().isEmpty
          ? 'عرض تمويل'
          : _labelCtrl.text.trim(),
      firstDownPayment: _d(_firstDownPaymentCtrl),
      previousInstallmentValue: _d(_previousInstallmentValueCtrl),
      previousInstallmentsCount: _i(_previousInstallmentsCountCtrl),
      bankDownPayment: _d(_bankDownPaymentCtrl),
      financingYears: _i(_financingYearsCtrl) == 0 ? 1 : _i(_financingYearsCtrl),
      firstInstallmentValue: _d(_firstInstallmentValueCtrl),
      installmentType: _installmentType,
      increaseRate: _d(_increaseRateCtrl),
      increaseEveryYears:
          _i(_increaseEveryYearsCtrl) == 0 ? 1 : _i(_increaseEveryYearsCtrl),
      doesIncreaseStop: _doesIncreaseStop,
      stopAfterYears: _i(_stopAfterYearsCtrl),
      calculationMethod: _calculationMethod,
    );
  }

  String? _required(String? v) {
    if (v == null || v.trim().isEmpty) return 'حقل مطلوب';
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final input = _buildInput();
    ref.read(calculatorProvider.notifier).loadInput(input);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ResultsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('حاسبة التمويل')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SectionCard(
              title: 'اسم العملية',
              icon: Icons.label_important_rounded,
              child: AppTextField(
                label: 'اسم التمويل / العرض',
                controller: _labelCtrl,
                isInteger: false,
              ),
            ),
            const SizedBox(height: 14),
            SectionCard(
              title: 'المقدمات والأقساط السابقة',
              icon: Icons.payments_rounded,
              child: Column(
                children: [
                  AppTextField(
                    label: 'المقدم الأول',
                    controller: _firstDownPaymentCtrl,
                    suffixText: 'ج.م',
                    validator: _required,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: 'مقدم البنك',
                    controller: _bankDownPaymentCtrl,
                    suffixText: 'ج.م',
                    validator: _required,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: 'قيمة القسط السابق',
                    controller: _previousInstallmentValueCtrl,
                    suffixText: 'ج.م',
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: 'عدد الأقساط السابقة',
                    controller: _previousInstallmentsCountCtrl,
                    isInteger: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SectionCard(
              title: 'بيانات التمويل الأساسية',
              icon: Icons.account_balance_rounded,
              child: Column(
                children: [
                  AppTextField(
                    label: 'مدة التمويل بالسنوات',
                    controller: _financingYearsCtrl,
                    isInteger: true,
                    validator: _required,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: 'قيمة أول قسط',
                    controller: _firstInstallmentValueCtrl,
                    suffixText: 'ج.م / شهريًا',
                    validator: _required,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SectionCard(
              title: 'نوع القسط',
              icon: Icons.trending_up_rounded,
              child: Column(
                children: [
                  SegmentedButton<InstallmentType>(
                    segments: const [
                      ButtonSegment(
                        value: InstallmentType.fixed,
                        label: Text('ثابت'),
                        icon: Icon(Icons.horizontal_rule_rounded),
                      ),
                      ButtonSegment(
                        value: InstallmentType.variable,
                        label: Text('متغير'),
                        icon: Icon(Icons.show_chart_rounded),
                      ),
                    ],
                    selected: {_installmentType},
                    onSelectionChanged: (v) {
                      setState(() => _installmentType = v.first);
                    },
                  ),
                  if (_installmentType == InstallmentType.variable) ...[
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'نسبة الزيادة',
                      controller: _increaseRateCtrl,
                      suffixText: '%',
                      validator: _required,
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      label: 'الزيادة كل كام سنة',
                      controller: _increaseEveryYearsCtrl,
                      isInteger: true,
                      validator: _required,
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('هل تتوقف الزيادة؟'),
                      value: _doesIncreaseStop,
                      onChanged: (v) => setState(() => _doesIncreaseStop = v),
                    ),
                    if (_doesIncreaseStop) ...[
                      const SizedBox(height: 4),
                      AppTextField(
                        label: 'تتوقف بعد كام سنة',
                        controller: _stopAfterYearsCtrl,
                        isInteger: true,
                        validator: _required,
                      ),
                    ],
                    const SizedBox(height: 16),
                    Text(
                      'طريقة الحساب',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<CalculationMethod>(
                      segments: const [
                        ButtonSegment(
                          value: CalculationMethod.simple,
                          label: Text('بسيطة'),
                        ),
                        ButtonSegment(
                          value: CalculationMethod.compound,
                          label: Text('مركبة'),
                        ),
                      ],
                      selected: {_calculationMethod},
                      onSelectionChanged: (v) {
                        setState(() => _calculationMethod = v.first);
                      },
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.calculate_rounded),
              label: const Text('احسب النتائج'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
