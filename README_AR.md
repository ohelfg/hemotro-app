# تطبيق Hemo Tro - تطبيق بث المسلسلات والحلقات

## نظرة عامة

**Hemo Tro** هو تطبيق Flutter عالي الأداء لبث المسلسلات والحلقات بأمان عالي. يوفر التطبيق حماية متقدمة للمحتوى ومنع النسخ غير المصرح.

## الميزات الرئيسية

### 🎬 بث الفيديو
- ✅ دعم جودات متعددة (1080p, 720p, 480p, 360p)
- ✅ اختيار الجودة حسب سرعة الإنترنت
- ✅ معالجة فيديو احترافية
- ✅ تشغيل سلس بدون تقطع

### 🔒 الحماية والأمان
- ✅ تشفير روابط الفيديو (AES-256)
- ✅ منع تسجيل الشاشة (Screen Recording Protection)
- ✅ حماية من النسخ غير المصرح
- ✅ توثيق الجهاز (Device Fingerprinting)
- ✅ رموز الترخيص (License Tokens)

### 👤 إدارة المستخدمين
- ✅ تسجيل دخول آمن
- ✅ إنشاء حساب جديد
- ✅ استعادة كلمة المرور
- ✅ التحقق من البريد الإلكتروني

### 📊 لوحة التحكم الإدارية
- ✅ إدارة المسلسلات
- ✅ إدارة الحلقات
- ✅ إدارة المستخدمين
- ✅ عرض الإحصائيات

## المتطلبات

- **Flutter SDK**: 3.0 أو أعلى
- **Dart**: 3.0 أو أعلى
- **Android SDK**: 21 أو أعلى
- **Java**: 11 أو أعلى

## التثبيت

### 1. استنساخ المستودع
```bash
git clone https://github.com/yourusername/hemo_tro_app.git
cd hemo_tro_app
```

### 2. تثبيت المكتبات
```bash
flutter pub get
```

### 3. تشغيل التطبيق (في وضع التطوير)
```bash
flutter run
```

## بناء APK

### بناء APK في وضع الإطلاق (Release)
```bash
flutter build apk --release
```

### بناء APK موقع (Signed)
```bash
flutter build apk --release --split-per-abi
```

سيتم حفظ ملفات APK في:
```
build/app/outputs/flutter-apk/app-release.apk
```

## بناء App Bundle (لـ Google Play)
```bash
flutter build appbundle --release
```

سيتم حفظ App Bundle في:
```
build/app/outputs/bundle/release/app-release.aab
```

## الإعدادات

### متغيرات البيئة
أنشئ ملف `.env` في جذر المشروع:
```
API_BASE_URL=https://your-api.com
API_KEY=your_api_key
ENCRYPTION_KEY=your_encryption_key
```

### إعدادات Firebase (اختياري)
1. أنشئ مشروع Firebase
2. حمل ملف `google-services.json`
3. ضعه في `android/app/`

## الاختبار

### تشغيل جميع الاختبارات
```bash
flutter test
```

### تشغيل اختبار معين
```bash
flutter test test/encryption_service_test.dart
```

### تشغيل الاختبارات مع التغطية
```bash
flutter test --coverage
```

## البنية

```
lib/
├── main.dart                 # نقطة الدخول
├── constants/               # الثوابت والألوان
├── models/                  # نماذج البيانات
├── providers/               # إدارة الحالة
├── screens/                 # الواجهات الرئيسية
├── widgets/                 # المكونات المخصصة
├── services/                # الخدمات (API, Encryption, etc.)
└── router/                  # نظام الملاحة

android/
├── app/
│   └── src/
│       └── main/
│           ├── AndroidManifest.xml
│           └── kotlin/
│               └── MainActivity.kt

test/
└── encryption_service_test.dart
```

## الخدمات الرئيسية

### ApiService
الاتصال بـ Backend API
```dart
final apiService = ApiService();
final series = await apiService.getSeries();
```

### EncryptionService
تشفير وفك تشفير البيانات
```dart
final encryptionService = EncryptionService();
final encrypted = encryptionService.encryptVideoUrl(url);
```

### StorageService
التخزين المحلي للبيانات
```dart
final storageService = StorageService();
await storageService.saveUser(user);
```

### ScreenRecordingProtection
منع تسجيل الشاشة
```dart
await ScreenRecordingProtection.enableProtection();
```

## المشاكل الشائعة والحلول

### مشكلة: "Flutter SDK not found"
**الحل**: تأكد من تثبيت Flutter SDK وإضافته إلى PATH
```bash
export PATH="$PATH:/path/to/flutter/bin"
```

### مشكلة: "Gradle build failed"
**الحل**: امسح ملفات البناء وأعد المحاولة
```bash
flutter clean
flutter pub get
flutter build apk
```

### مشكلة: "Permission denied"
**الحل**: تأكد من الصلاحيات في `AndroidManifest.xml`

## النشر على Google Play

1. **إنشاء حساب Google Play Developer**
   - انتقل إلى https://play.google.com/console
   - ادفع رسوم التسجيل ($25)

2. **إنشاء تطبيق جديد**
   - اختر "Create app"
   - أدخل اسم التطبيق واللغة

3. **إعداد التوقيع**
   ```bash
   keytool -genkey -v -keystore ~/my-release-key.jks \
     -keyalg RSA -keysize 2048 -validity 10000 \
     -alias my-key-alias
   ```

4. **بناء App Bundle موقع**
   ```bash
   flutter build appbundle --release
   ```

5. **رفع App Bundle**
   - انتقل إلى Google Play Console
   - اختر Release > Production
   - ارفع App Bundle

## المساهمة

نرحب بالمساهمات! يرجى:
1. Fork المستودع
2. أنشئ فرع جديد (`git checkout -b feature/amazing-feature`)
3. أرسل Pull Request

## الترخيص

هذا المشروع مرخص تحت MIT License - انظر ملف LICENSE للتفاصيل.

## الدعم

للحصول على الدعم:
- 📧 البريد الإلكتروني: support@hemotro.com
- 🐛 الإبلاغ عن الأخطاء: https://github.com/yourusername/hemo_tro_app/issues
- 💬 المنتدى: https://forum.hemotro.com

## الشكر والتقدير

شكراً لاستخدامك Hemo Tro! نأمل أن تستمتع بالتطبيق.

---

**الإصدار**: 1.0.0  
**آخر تحديث**: 2024  
**الحالة**: قيد التطوير النشط
