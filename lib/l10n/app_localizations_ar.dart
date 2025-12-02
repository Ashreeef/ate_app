// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'أكل';

  @override
  String get loginTitle => 'مرحباً بعودتك';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get signupButton => 'إنشاء حساب';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get usernameLabel => 'اسم المستخدم';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get feedTitle => 'اكتشف';

  @override
  String get searchPlaceholder => 'ابحث عن المطاعم والأطباق...';

  @override
  String get createPostTitle => 'شارك تجربتك';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get challengesTitle => 'التحديات';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get posts => 'المنشورات';

  @override
  String get followers => 'المتابعون';

  @override
  String get following => 'المتابَعون';

  @override
  String get saved => 'المحفوظات';

  @override
  String get myPosts => 'منشوراتي';

  @override
  String get savedPosts => 'المنشورات المحفوظة';

  @override
  String get like => 'إعجاب';

  @override
  String get comment => 'تعليق';

  @override
  String get share => 'مشاركة';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get submit => 'إرسال';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get error => 'حدث خطأ';

  @override
  String get pickImages => 'اختر الصور (بحد أقصى 3)';

  @override
  String get noPosts => 'لا توجد منشورات حتى الآن';

  @override
  String get noPostsDescription => 'كن أول من يشارك تجربتك الطهي!';

  @override
  String get selectAtLeastOneImage => 'حدد صورة واحدة على الأقل';

  @override
  String imageSelectionFailed(Object error) {
    return 'فشل اختيار الصورة: $error';
  }

  @override
  String get postPublished => 'تم نشر المنشور بنجاح!';

  @override
  String postPublishError(Object error) {
    return 'خطأ في نشر المنشور: $error';
  }

  @override
  String get writeCaption => 'يرجى كتابة تعليق';

  @override
  String get enterRestaurant => 'يرجى إدخال اسم المطعم';

  @override
  String get rateExperience => 'يرجى تقييم تجربتك';

  @override
  String get caption => 'التعليق';

  @override
  String get captionPlaceholder => 'شارك تجربتك الطهي...';

  @override
  String get restaurant => 'المطعم';

  @override
  String get restaurantPlaceholder => 'اسم المطعم...';

  @override
  String get restaurantHint => 'اكتب اسم المطعم';

  @override
  String get dishName => 'اسم الطبق';

  @override
  String get dishNamePlaceholder => 'مثال: كسكس ملكي، سمك مشوي...';

  @override
  String get dishNameOptional => '(اختياري)';

  @override
  String get yourRating => 'تقييمك';

  @override
  String get newPost => 'منشور جديد';

  @override
  String get publish => 'نشر';

  @override
  String get disappointing => 'مخيب للآمال';

  @override
  String get fair => 'متوسط';

  @override
  String get good => 'جيد';

  @override
  String get veryGood => 'جيد جداً';

  @override
  String get excellent => 'ممتاز!';

  @override
  String get myFeed => 'خيطي';

  @override
  String get friendsFeed => 'خيط الأصدقاء';

  @override
  String get loadMore => 'تحميل المزيد';
}
