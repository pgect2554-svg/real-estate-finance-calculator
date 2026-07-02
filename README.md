# حاسبة التمويل العقاري 🏠💰

تطبيق Flutter احترافي لحساب وإدارة ومقارنة عروض التمويل العقاري، مبني بـ **Material 3**،
**Riverpod**، و**Clean Architecture**، بواجهة عربية كاملة (RTL) ودعم **Dark Mode**.

---

## 1) خطوات التشغيل

> المشروع يحتوي فقط على كود Dart (مجلد `lib/`) و`pubspec.yaml`. مجلدات المنصات
> (`android/`, `ios/`) لم تُنشأ هنا لأنها تحتاج أدوات Flutter SDK الفعلية لتوليدها، لذا
> نفّذ الخطوات التالية بالترتيب:

```bash
# 1. أنشئ مجلدات المنصات (Android / iOS) تلقائيًا داخل نفس المجلد
flutter create --org com.yourcompany.finance --platforms=android,ios .

# 2. اسحب الحزم
flutter pub get

# 3. شغّل التطبيق
flutter run
```

### للنشر على Google Play

```bash
flutter build appbundle --release
```

سيجد الملف الناتج (`app-release.aab`) داخل:
`build/app/outputs/bundle/release/`

قبل النشر، تأكد من:
- تعديل `applicationId` في `android/app/build.gradle`.
- توقيع التطبيق بمفتاح Keystore خاص بك (راجع توثيق Flutter الرسمي لـ "Signing the app").
- تحديث أيقونة التطبيق (`flutter_launcher_icons` يمكن إضافتها لاحقًا).
- تحديث اسم التطبيق `android:label` في `AndroidManifest.xml`.

---

## 2) بنية المشروع (Clean Architecture)

```
lib/
├── main.dart                     # نقطة الانطلاق: تهيئة Hive + Riverpod + الثيم + RTL
│
├── core/                         # عناصر مشتركة لا تعتمد على منطق العمل
│   ├── constants/app_constants.dart
│   ├── theme/app_colors.dart     # لوحة ألوان بنكية
│   ├── theme/app_theme.dart      # ThemeData فاتح/داكن (Material 3)
│   └── utils/formatters.dart     # تنسيق العملة والأرقام والتاريخ
│
├── domain/                       # منطق الأعمال الصِرف (Framework-independent)
│   ├── entities/
│   │   ├── enums.dart            # InstallmentType, CalculationMethod
│   │   ├── finance_input.dart    # كل مدخلات المستخدم
│   │   ├── finance_result.dart   # نتيجة الحساب الكاملة
│   │   ├── year_row.dart         # صف واحد بالجدول السنوي
│   │   └── scenario.dart         # سيناريو محفوظ
│   └── services/
│       └── calculator_service.dart   # ⭐ كل المعادلات المالية هنا فقط
│
├── data/                         # مصادر البيانات (Hive)
│   ├── local/hive_boxes.dart
│   ├── models/scenario_hive_model.dart   # TypeAdapter مكتوب يدويًا (بدون build_runner)
│   └── repositories/
│       ├── scenario_repository.dart      # Interface
│       └── scenario_repository_impl.dart # التطبيق الفعلي
│
├── application/                  # طبقة الحالة (State) بين الواجهة والمنطق
│   ├── providers/
│   │   ├── calculator_provider.dart
│   │   ├── scenario_provider.dart
│   │   └── theme_provider.dart
│   └── state/calculator_state.dart
│
└── presentation/                 # الشاشات والودجتس (UI فقط، بلا منطق حسابي)
    ├── screens/
    │   ├── home/home_screen.dart             # 1) الشاشة الرئيسية (Dashboard)
    │   ├── calculator/calculator_screen.dart # 2) نموذج إدخال بيانات التمويل
    │   ├── results/results_screen.dart       # ملخص النتائج + أزرار التصدير
    │   ├── schedule/schedule_screen.dart     # 3) الجدول السنوي الكامل
    │   ├── charts/charts_screen.dart         # 4) الرسوم البيانية (Syncfusion)
    │   ├── comparison/comparison_screen.dart # 5) مقارنة عدة تمويلات
    │   └── scenarios/scenarios_screen.dart   # 6) حفظ واسترجاع السيناريوهات
    ├── services/
    │   ├── export_pdf_service.dart    # 7) تصدير PDF
    │   ├── export_excel_service.dart  # 7) تصدير Excel
    │   └── share_service.dart         # مشاركة/طباعة الملفات
    └── widgets/                       # عناصر واجهة قابلة لإعادة الاستخدام
        ├── app_text_field.dart
        ├── section_card.dart
        └── stat_card.dart
```

**مبدأ الاعتمادية:** `presentation` ⬅ `application` ⬅ `domain` ⬅⬅ `data` (تنفذ عقود domain).
شاشات الواجهة لا تحتوي على أي معادلة رياضية؛ كل الحسابات مركزّة في
`domain/services/calculator_service.dart`.

---

## 3) منطق الحساب (CalculatorService)

- **القسط الثابت:** يبقى بنفس قيمة "أول قسط" طوال مدة التمويل.
- **القسط المتغير:**
  - تُحسب "خطوات الزيادة" بعدد السنوات مقسومة على "الزيادة كل كام سنة".
  - إن كانت طريقة الحساب **بسيطة (Simple)**: كل خطوة تضيف `نسبة الزيادة % × القسط الأول`.
  - إن كانت **مركبة (Compound)**: القيمة = `القسط الأول × (1 + النسبة)^عدد الخطوات`.
  - إذا فُعّل خيار "هل تتوقف الزيادة؟"، يتم تجميد عدد الخطوات عند الوصول للسنة المحددة
    في "تتوقف بعد كام سنة"، فلا يزيد القسط بعدها.
- **الجدول السنوي:** يبني صفًا لكل سنة يحسب فيه القسط الشهري، إجمالي السنة (×12)،
  مقدار الزيادة عن السنة السابقة، والإجمالي التراكمي منذ بداية التمويل (شاملًا
  المقدمات والأقساط السابقة).
- **الملخص:** إجمالي المقدمات، إجمالي الأقساط السابقة، إجمالي الأقساط المستقبلية،
  التكلفة النهائية، متوسط/أعلى/أقل قسط.
- **المقارنة:** `rankByTotalCost()` تُرتّب أي مجموعة نتائج تصاعديًا حسب التكلفة
  النهائية لتحديد الأرخص/الأفضل.

---

## 4) الحزم المستخدمة

| الغرض | الحزمة |
|---|---|
| إدارة الحالة | `flutter_riverpod` |
| قاعدة بيانات محلية | `hive` + `hive_flutter` |
| رسوم بيانية | `syncfusion_flutter_charts` |
| تصدير PDF | `pdf` + `printing` |
| تصدير Excel | `excel` |
| مشاركة الملفات | `share_plus` |
| خطوط عربية أنيقة | `google_fonts` (Tajawal) |

---

## 5) ملاحظات مهمة قبل الإنتاج

1. **التوقيع والنشر:** اتبع [توثيق Flutter لتوقيع تطبيقات Android](https://docs.flutter.dev/deployment/android)
   قبل رفع الـ App Bundle على Google Play Console.
2. **الأيقونة والاسم:** أضف حزمة `flutter_launcher_icons` لتوليد أيقونات جميع الأحجام،
   وحدّث `android:label` و`CFBundleName`.
3. **الاختبار:** ينصح بإضافة اختبارات وحدة (`test/`) لـ `CalculatorService` نظرًا لأنه
   يحتوي على كل المنطق المالي الحرج؛ الكلاس مصمم بدون أي اعتماد على Flutter لتسهيل ذلك.
4. **التدقيق الشرعي/القانوني:** المعادلات هنا لأغراض تقديرية؛ يُنصح بمراجعة جهة مالية
   مرخصة قبل اعتماد الأرقام في قرارات فعلية.

---

بُنيَ هذا المشروع باتباع Clean Architecture لضمان سهولة الصيانة، إضافة مصادر بيانات جديدة
(مثل ربط API لعروض بنوك حقيقية)، أو تبديل مكتبة التخزين المحلي دون التأثير على منطق
الحساب أو الواجهات.
