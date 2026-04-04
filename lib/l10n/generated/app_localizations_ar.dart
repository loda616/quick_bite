// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'كويك بايت';

  @override
  String get appTagline => 'طعام سريع، توصيل أسرع';

  @override
  String get welcomeBack => 'مرحباً بعودتك!';

  @override
  String get signInToContinue => 'سجل دخولك للمتابعة إلى كويك بايت';

  @override
  String get emailAddress => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get rememberMe => 'تذكرني';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ ';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get or => 'أو';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get joinQuickBite => 'انضم إلى كويك بايت';

  @override
  String get createAccountToGetStarted => 'أنشئ حسابك للبدء';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get lastName => 'اسم العائلة';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ ';

  @override
  String get iAgreeToThe => 'أوافق على ';

  @override
  String get termsConditions => 'الشروط والأحكام';

  @override
  String get and => ' و ';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get required => 'مطلوب';

  @override
  String get tooShort => 'قصير جداً';

  @override
  String get pleaseEnterEmail => 'يرجى إدخال بريدك الإلكتروني';

  @override
  String get pleaseEnterValidEmail => 'يرجى إدخال بريد إلكتروني صحيح';

  @override
  String get pleaseEnterPhone => 'يرجى إدخال رقم هاتفك';

  @override
  String get pleaseEnterValidPhone => 'يرجى إدخال رقم هاتف صحيح';

  @override
  String get pleaseEnterPassword => 'يرجى إدخال كلمة المرور';

  @override
  String get passwordMinLength => 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';

  @override
  String get pleaseConfirmPassword => 'يرجى تأكيد كلمة المرور';

  @override
  String get forgotPasswordTitle => 'نسيت كلمة المرور؟';

  @override
  String get forgotPasswordDesc =>
      'أدخل عنوان بريدك الإلكتروني وسنرسل لك رابط إعادة تعيين كلمة المرور.';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get backToLogin => 'العودة إلى تسجيل الدخول';

  @override
  String get resetLinkSent => 'تم إرسال رابط الإعادة!';

  @override
  String get resetLinkSentDesc =>
      'لقد أرسلنا رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني.\\nيرجى التحقق من صندوق الوارد واتباع التعليمات.';

  @override
  String get home => 'الرئيسية';

  @override
  String get cart => 'السلة';

  @override
  String get orders => 'الطلبات';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get settings => 'الإعدادات';

  @override
  String get searchForFood => 'البحث عن الطعام...';

  @override
  String welcomeBackUser(String userName) {
    return 'مرحباً بعودتك، $userName!';
  }

  @override
  String get shoppingCart => 'سلة التسوق';

  @override
  String get clear => 'مسح';

  @override
  String itemsInCart(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'عناصر',
      one: 'عنصر',
    );
    return '$count $_temp0 في السلة';
  }

  @override
  String get swipeToRemove => 'اسحب لإزالة العناصر';

  @override
  String get yourCartIsEmpty => 'سلتك فارغة';

  @override
  String get addDeliciousItems => 'أضف بعض الأطعمة اللذيذة للبدء';

  @override
  String get browseMenu => 'تصفح القائمة';

  @override
  String subtotal(int count) {
    return 'المجموع الفرعي ($count عناصر)';
  }

  @override
  String get deliveryFee => 'رسوم التوصيل';

  @override
  String get total => 'المجموع';

  @override
  String get free => 'مجاني';

  @override
  String addMoreForFreeDelivery(String amount) {
    return 'أضف $amount أكثر للحصول على توصيل مجاني!';
  }

  @override
  String get addMore => 'إضافة المزيد';

  @override
  String get checkout => 'الدفع';

  @override
  String get clearCart => 'مسح السلة';

  @override
  String get clearCartConfirm => 'هل أنت متأكد من إزالة جميع العناصر من سلتك؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get addToCart => 'أضف إلى السلة';

  @override
  String get notAvailable => 'غير متوفر';

  @override
  String get available => 'متوفر';

  @override
  String get description => 'الوصف';

  @override
  String get customizations => 'التخصيصات';

  @override
  String get quantity => 'الكمية';

  @override
  String addedToCart(String itemName) {
    return 'تم إضافة $itemName إلى السلة';
  }

  @override
  String get viewCart => 'عرض السلة';

  @override
  String get noOrdersYet => 'لا توجد طلبات بعد';

  @override
  String get orderHistoryWillAppear => 'ستظهر هنا تاريخ طلباتك';

  @override
  String get filterOrders => 'تصفية الطلبات';

  @override
  String get allOrders => 'جميع الطلبات';

  @override
  String get recentOrders => 'الطلبات الأخيرة';

  @override
  String get completed => 'مكتمل';

  @override
  String get close => 'إغلاق';

  @override
  String orderNumber(String orderId) {
    return 'طلب رقم $orderId';
  }

  @override
  String get orderStatusPending => 'معلق';

  @override
  String get orderStatusPreparing => 'قيد التحضير';

  @override
  String get orderStatusReady => 'جاهز';

  @override
  String get orderStatusDelivered => 'تم التوصيل';

  @override
  String get orderStatusCancelled => 'ملغي';

  @override
  String get accountInformation => 'معلومات الحساب';

  @override
  String get contactInformation => 'معلومات الاتصال';

  @override
  String get appPreferences => 'تفضيلات التطبيق';

  @override
  String get accountStatus => 'حالة الحساب';

  @override
  String get userId => 'معرف المستخدم';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get role => 'الدور';

  @override
  String get phone => 'الهاتف';

  @override
  String get address => 'العنوان';

  @override
  String get notProvided => 'غير مقدم';

  @override
  String get language => 'اللغة';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get theme => 'المظهر';

  @override
  String get enabled => 'مفعل';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get status => 'الحالة';

  @override
  String get active => 'نشط';

  @override
  String get memberSince => 'عضو منذ';

  @override
  String get lastLogin => 'آخر دخول';

  @override
  String get today => 'اليوم';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get loadingProfile => 'جاري تحميل الملف الشخصي...';

  @override
  String get refreshProfile => 'تحديث الملف الشخصي';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get editContactInformation => 'تعديل معلومات الاتصال';

  @override
  String get save => 'حفظ';

  @override
  String get logoutConfirm => 'هل أنت متأكد من تسجيل الخروج؟';

  @override
  String get online => 'متصل';

  @override
  String get account => 'الحساب';

  @override
  String get appearance => 'المظهر';

  @override
  String get about => 'حول';

  @override
  String get receiveNotifications => 'استقبال الإشعارات';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get selectTheme => 'اختر المظهر';

  @override
  String get alwaysLight => 'استخدام المظهر الفاتح دائماً';

  @override
  String get alwaysDark => 'استخدام المظهر الداكن دائماً';

  @override
  String get followSystem => 'اتباع إعدادات النظام';

  @override
  String get system => 'النظام';

  @override
  String get appVersion => 'إصدار التطبيق';

  @override
  String get helpSupport => 'المساعدة والدعم';

  @override
  String get builtWithFlutter => 'مبني بـ Flutter وبالحب ❤️';

  @override
  String get error => 'خطأ';

  @override
  String get success => 'نجح';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get ok => 'موافق';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get loginSuccessful => 'تم تسجيل الدخول بنجاح! مرحباً بعودتك.';

  @override
  String get registrationSuccessful =>
      'تم التسجيل بنجاح! يرجى تسجيل الدخول للمتابعة.';

  @override
  String get passwordResetSent =>
      'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني.';

  @override
  String get invalidCredentials => 'بريد إلكتروني أو كلمة مرور غير صحيحة';

  @override
  String get networkError => 'خطأ في الشبكة. يرجى التحقق من اتصالك.';

  @override
  String get serverError => 'خطأ في الخادم. يرجى المحاولة لاحقاً.';

  @override
  String get loadingDeliciousFood => 'جاري تحميل الطعام اللذيذ...';

  @override
  String get noItemsFound => 'لم يتم العثور على عناصر';

  @override
  String get tryDifferentCategory => 'جرب اختيار فئة مختلفة';

  @override
  String shareText(String itemName) {
    return 'اكتشف هذا الطبق الشهي $itemName على كويك بايت!';
  }

  @override
  String get favorites => 'المفضلة';

  @override
  String get noFavoritesYet => 'ليس لديك مفضلات حتى الآن.';

  @override
  String get favoritesError => 'هناك خطأ ما. حاول مرة أخرى.';
}
