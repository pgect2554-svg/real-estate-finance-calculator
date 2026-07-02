/// نوع القسط: ثابت طوال مدة التمويل أو متغير (يزيد بمرور الوقت)
enum InstallmentType {
  fixed,
  variable;

  String get label => this == InstallmentType.fixed ? 'ثابت' : 'متغير';
}

/// طريقة حساب الزيادة على القسط عند اختيار النوع المتغير
enum CalculationMethod {
  simple,
  compound;

  String get label =>
      this == CalculationMethod.simple ? 'بسيطة (Simple)' : 'مركبة (Compound)';
}
