import 'finance_input.dart';

/// سيناريو محفوظ يمثل عملية حسابية قام المستخدم بحفظها للرجوع إليها لاحقًا
class Scenario {
  final String id;
  final String name;
  final DateTime createdAt;
  final FinanceInput input;

  const Scenario({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.input,
  });
}
