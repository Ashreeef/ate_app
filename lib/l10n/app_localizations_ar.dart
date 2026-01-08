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
  String viewAllComments(Object count) {
    return 'عرض كل $count تعليقات';
  }

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
  String get profile => 'الملف الشخصي';

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
  String get points => 'نقاط';

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
  String get error => 'خطأ';

  @override
  String get comingSoon => 'قريباً!';

  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get logoutSuccess => 'تم تسجيل الخروج بنجاح';

  @override
  String get shareProfile => 'مشاركة الملف الشخصي';

  @override
  String shareProfileMessage(Object url, Object username) {
    return 'شاهد @$username على Ate! اكتشف رحلته في عالم الطبخ هنا: $url';
  }

  @override
  String get linkCopied => 'تم نسخ الرابط!';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get currentPassword => 'كلمة المرور الحالية';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور الجديدة';

  @override
  String get passwordsDoNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String get passwordTooShort =>
      'يجب أن تحتوي كلمة المرور على 6 أحرف على الأقل';

  @override
  String get passwordChangedSuccess => 'تم تغيير كلمة المرور بنجاح';

  @override
  String get passwordChangeError => 'خطأ في تغيير كلمة المرور';

  @override
  String get incorrectPassword => 'كلمة المرور الحالية غير صحيحة';

  @override
  String get chooseLanguage => 'اختر اللغة';

  @override
  String get helpSupport => 'المساعدة والدعم';

  @override
  String get contactUs => '📞 تواصل معنا';

  @override
  String get emailSupport => ' البريد الإلكتروني: Contact.ate.app@gmail.com';

  @override
  String get phoneSupport => '';

  @override
  String get liveChat => '';

  @override
  String get supportHours => ' وقت الاستجابة: عادةً خلال 24 ساعة';

  @override
  String get frequentlyAsked => ' الأسئلة الشائعة';

  @override
  String get howToEditProfile => 'كيف أعدل ملفي الشخصي؟';

  @override
  String get howToEditProfileAnswer =>
      'اذهب إلى الإعدادات > تعديل الملف الشخصي لتغيير معلوماتك الشخصية.';

  @override
  String get howToFollowUsers => 'كيف أتابع المستخدمين الآخرين؟';

  @override
  String get howToFollowUsersAnswer =>
      'قم بزيارة ملفهم الشخصي واضغط على زر \'متابعة\'.';

  @override
  String get howToPostPhoto => 'كيف أنشر صورة؟';

  @override
  String get howToPostPhotoAnswer =>
      'اضغط على زر \'+\' في أسفل الشاشة، اختر صورة وأضف وصفاً.';

  @override
  String get howToReportContent => 'كيف أبلغ عن محتوى؟';

  @override
  String get howToReportContentAnswer =>
      'اضغط على النقاط الثلاث على المنشور واختر \'إبلاغ\'.';

  @override
  String get forgotPasswordHelp => 'نسيت كلمة المرور؟';

  @override
  String get forgotPasswordHelpAnswer =>
      'استخدم رابط \'نسيت كلمة المرور\' في شاشة تسجيل الدخول.';

  @override
  String get mainFeatures => 'الميزات الرئيسية';

  @override
  String get shareculinaryMoments => '•  شارك لحظاتك الطبخية';

  @override
  String get followFriends => '•  تابع أصدقائك واكتشف ملفات جديدة';

  @override
  String get likeComment => '•  أعجب وعلق على المنشورات';

  @override
  String get savePosts => '•  احفظ منشوراتك المفضلة';

  @override
  String get pointsSystem => '•  نظام النقاط والمستويات';

  @override
  String get discoverRestaurants => '•  اكتشف مطاعم جديدة';

  @override
  String get darkMode => '•  الوضع المظلم متوفر';

  @override
  String get troubleshooting => ' حل المشاكل';

  @override
  String get restartApp => '• أعد تشغيل التطبيق إذا تصرف بشكل غريب';

  @override
  String get checkInternet => '• تحقق من اتصال الإنترنت';

  @override
  String get updateApp => '• حدث إلى أحدث إصدار';

  @override
  String get clearCache => '• امسح التخزين المؤقت في الإعدادات';

  @override
  String get contactSupport => '• تواصل مع الدعم إذا استمرت المشكلة';

  @override
  String get closeDialog => 'إغلاق';

  @override
  String get aboutAte => ' حول Ate';

  @override
  String get appDescription =>
      'Ate هو رفيقك الطبخي النهائي! شارك تجاربك الغذائية، اكتشف مطاعم جديدة وتواصل مع عشاق الطعام الآخرين.';

  @override
  String get ourMission => ' مهمتنا';

  @override
  String get missionDescription =>
      'ربط محبي الطعام وجعل كل وجبة لا تُنسى من خلال إنشاء مجتمع محب حول شغف الطبخ.';

  @override
  String get whatWeOffer => ' ما نقدمه';

  @override
  String get shareFoodPhotos => '• مشاركة صور أطباقك المفضلة';

  @override
  String get discoverNewRestaurants => '• اكتشاف مطاعم جديدة';

  @override
  String get personalizedRecommendations => '• نظام توصيات شخصية';

  @override
  String get activeCommunity => '• مجتمع نشط من محبي الطعام';

  @override
  String get intuitiveInterface => '• واجهة بديهية وحديثة';

  @override
  String get privacyRespect => '• احترام خصوصيتك';

  @override
  String get theTeam => ' الفريق';

  @override
  String get teamDescription =>
      'تم التطوير بـ ❤️ من قبل فريق شغوف بالتكنولوجيا والطبخ، مقره في الجزائر.';

  @override
  String get versionInfo => 'الإصدار 1.0.0';

  @override
  String get buildInfo => 'البناء: 2026.01.01';

  @override
  String get allRightsReserved => '© 2026 Ate App. جميع الحقوق محفوظة.';

  @override
  String get madeInAlgeria => 'صُنع في الجزائر 🇩🇿';

  @override
  String get privacySecurity => 'الخصوصية والأمان';

  @override
  String get privateAccount => 'حساب خاص';

  @override
  String get privateAccountDesc => 'سيكون ملفك الشخصي مرئيًا فقط لمتابعيك';

  @override
  String get showOnlineStatus => 'إظهار حالة الاتصال';

  @override
  String get showOnlineStatusDesc => 'يمكن للآخرين رؤية متى تكون متصلاً';

  @override
  String get close => 'إغلاق';

  @override
  String get needHelp => 'هل تحتاج إلى مساعدة؟';

  @override
  String get phone => 'الهاتف';

  @override
  String get about => 'حول';

  @override
  String get version => 'الإصدار 1.0.0';

  @override
  String get termsPrivacy => 'الشروط والخصوصية';

  @override
  String get termsOfUse => 'شروط الاستخدام';

  @override
  String get termsOfUseDesc =>
      'باستخدام أكل، فإنك توافق على شروط الاستخدام وسياسة الخصوصية الخاصة بنا.';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get privacyPolicyDesc =>
      'بياناتك الشخصية محمية ولن يتم مشاركتها مع أطراف ثالثة دون موافقتك.';

  @override
  String get dataCollection => 'جمع البيانات';

  @override
  String get dataCollectionDesc =>
      '• معلومات الملف الشخصي\n• الصور والمنشورات\n• بيانات التفاعل';

  @override
  String get accountDeleted => 'تم حذف الحساب بنجاح';

  @override
  String get logoutConfirm => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get deleteAccountConfirm =>
      'هذا الإجراء لا رجعة فيه. سيتم حذف جميع بياناتك نهائيًا.';

  @override
  String get account => 'الحساب';

  @override
  String get updateYourInfo => 'تحديث معلوماتك';

  @override
  String get manageAccountSecurity => 'إدارة أمان حسابك';

  @override
  String get updateYourPassword => 'تحديث كلمة المرور';

  @override
  String get preferences => 'التفضيلات';

  @override
  String get manageNotifications => 'إدارة تفضيلات الإشعارات';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get language => 'اللغة';

  @override
  String get theme => 'المظهر';

  @override
  String get support => 'الدعم';

  @override
  String get getHelpWithApp => 'احصل على المساعدة مع أكل';

  @override
  String get learnMoreAboutApp => 'معرفة المزيد عن أكل';

  @override
  String get legalInfo => 'المعلومات القانونية';

  @override
  String get dangerZone => 'منطقة الخطر';

  @override
  String get logoutFromAccount => 'تسجيل الخروج من حسابك';

  @override
  String get deleteAccountPermanently => 'حذف حسابك نهائيًا';

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
  String get retry => 'إعادة المحاولة';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(Object count) {
    return 'منذ $count دقيقة';
  }

  @override
  String hoursAgo(Object count) {
    return 'منذ $count ساعة';
  }

  @override
  String daysAgo(Object count) {
    return 'منذ $count يوم';
  }

  @override
  String get copyLink => 'نسخ الرابط';

  @override
  String get report => 'إبلاغ';

  @override
  String get convertToRestaurant => 'تحويل إلى مطعم';

  @override
  String get viewRestaurant => 'عرض مطعمي';

  @override
  String get createChallenge => 'إنشاء تحدي';

  @override
  String get challengeTitle => 'عنوان التحدي';

  @override
  String get challengeDescription => 'وصف التحدي';

  @override
  String get targetCount => 'الهدف المطلوب';

  @override
  String get rewardBadge => 'شارة المكافأة';

  @override
  String get joinChallenge => 'الانضمام للتحدي';

  @override
  String get leaveChallenge => 'مغادرة التحدي';

  @override
  String get yourProgress => 'تقدمك';

  @override
  String get daysRemaining => 'الأيام المتبقية';

  @override
  String get challengeEnded => 'انتهى التحدي';

  @override
  String get reward => 'المكافأة';

  @override
  String get dateRange => 'الفترة الزمنية';

  @override
  String get startDate => 'تاريخ البدء';

  @override
  String get endDate => 'تاريخ الانتهاء';

  @override
  String get conversionWarning =>
      'هذا الإجراء لا رجعة فيه. بمجرد التحويل إلى حساب مطعم، لن تتمكن من العودة.';

  @override
  String get confirmConversion => 'تأكيد التحويل';

  @override
  String get conversionSuccessful => 'تم تحويل الحساب إلى مطعم بنجاح!';

  @override
  String get becomeARestaurant => 'أصبح مطعماً';

  @override
  String get fillInRestaurantDetails => 'املأ تفاصيل مطعمك أدناه';

  @override
  String get restaurantName => 'اسم المطعم';

  @override
  String get cuisineType => 'نوع المطبخ';

  @override
  String get location => 'الموقع';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get website => 'Website';

  @override
  String get openingHours => 'ساعات العمل';

  @override
  String get description => 'الوصف';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get restaurantCreated => 'Restaurant profile created';

  @override
  String get myFeed => 'اخر التحديثات';

  @override
  String get friendsFeed => 'الاصدقاء';

  @override
  String get noFollowing => 'لا تتابع أي شخص بعد';

  @override
  String get search => 'بحث';

  @override
  String get postDeleted => 'تم حذف المنشور';

  @override
  String failedToDeletePost(Object error) {
    return 'فشل حذف المنشور: $error';
  }

  @override
  String failedToAddComment(Object error) {
    return 'فشل إضافة التعليق: $error';
  }

  @override
  String get failedToUpdateLike => 'فشل تحديث الإعجاب';

  @override
  String get failedToUpdateSave => 'فشل تحديث الحفظ';

  @override
  String get cannotAddComment => 'لا يمكن إضافة تعليق لهذا المنشور';

  @override
  String get noCommentsYet => 'لا توجد تعليقات بعد. كن أول من يعلق!';

  @override
  String likesCountText(Object count) {
    return '$count إعجاب';
  }

  @override
  String get imageNotFound => 'الصورة غير موجودة';

  @override
  String get user => 'مستخدم';

  @override
  String get deleteAction => 'حذف';

  @override
  String get unknown => 'غير معروف';

  @override
  String postsCount(Object count) {
    return '$count منشورات';
  }

  @override
  String followersCount(Object count) {
    return '$count متابعين';
  }

  @override
  String followingCount(Object count) {
    return '$count يتابعهم';
  }

  @override
  String pointsCount(Object count) {
    return '$count نقاط';
  }

  @override
  String get likes => 'تسجيلات الإعجاب';

  @override
  String get noDishes => 'لم يتم العثور على أطباق';

  @override
  String get noPostsYet => 'لا توجد منشورات حتى الآن';

  @override
  String get newFollowerTitle => 'متابع جديد';

  @override
  String startedFollowingYou(Object username) {
    return '$username بدأ في متابعتك';
  }

  @override
  String get newLikeTitle => 'إعجاب جديد';

  @override
  String likedYourPost(Object username) {
    return '$username أعجب بمنشورك';
  }

  @override
  String get newCommentTitle => 'تعليق جديد';

  @override
  String commentedOnYourPost(Object username) {
    return '$username علق على منشورك';
  }

  @override
  String get allCaughtUp => 'لقد شاهدت كل شيء!';

  @override
  String get challengeTypeGeneral => 'عام';

  @override
  String get challengeTypeRestaurant => 'خاص بالمطعم';

  @override
  String get challengeTypeDish => 'خاص بالطبق';

  @override
  String get challengeTypeLocation => 'حسب الموقع';

  @override
  String get pleaseLoginFirst => 'يرجى تسجيل الدخول أولاً';

  @override
  String get selectStartEndDates => 'يرجى اختيار تاريخ البدء والانتهاء';

  @override
  String get selectChallenge => 'اختر تحدياً للمساهمة فيه';

  @override
  String get none => 'لا يوجد';

  @override
  String get pleaseLoginToJoinChallenges =>
      'يرجى تسجيل الدخول للانضمام إلى التحديات';

  @override
  String get writeReview => 'اكتب تقييمًا';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get reviews => 'التقييمات';

  @override
  String get restaurantNotFound => 'المطعم غير موجود';

  @override
  String get restaurantHint => 'ابحث عن مطعم...';

  @override
  String get reviewSuccess => 'تم إرسال التقييم بنجاح!';

  @override
  String get rateExperience => 'يرجى تقييم تجربتك';

  @override
  String get yourReview => 'تقييمك';

  @override
  String get writeReviewHint => 'شارك تفاصيل تجربتك...';

  @override
  String get noReviewsRow => 'لا توجد تقييمات بعد. كن أول من يقيم!';

  @override
  String get failedToLoadReviews => 'فشل تحميل التقييمات';

  @override
  String get onboardingDiscover => 'اكتشف ';

  @override
  String get onboardingFlavor => 'النكهة';

  @override
  String get onboardingOf => ' الحقيقية لـ ';

  @override
  String get onboardingSharing => 'المشاركة';

  @override
  String get onboardingWith => ' مع ';

  @override
  String get onboardingDescription =>
      'أكل هو رفيقك في الطعام، مصمم لعشاق الأكل الجيد. كل يوم، استكشف أطباقاً جديدة بفضل توصيات أصدقائك، وشارك اكتشافاتك، وخُض تحديات الطعام واكسب الجوائز.';

  @override
  String get closeButton => 'إغلاق';

  @override
  String memberLevel(Object level) {
    return 'عضو $level ⭐';
  }

  @override
  String get rank => 'الرتبة';

  @override
  String get userPoints => 'نقاط المستخدم';

  @override
  String followedUser(Object username) {
    return 'أنت تتبع $username الآن';
  }

  @override
  String unfollowedUser(Object username) {
    return 'لقد ألغيت متابعة $username';
  }

  @override
  String get conversionWarningCompact => 'لا يمكن التراجع عن هذا الإجراء!';

  @override
  String get followed => 'تتم المتابعة !';

  @override
  String get manageMenu => 'إدارة القائمة';

  @override
  String get editRestaurant => 'تعديل المطعم';

  @override
  String get menu => 'القائمة';

  @override
  String get restaurant => 'المطعم';

  @override
  String get rating => 'التقييم';

  @override
  String get deleteAccountWarning =>
      'هذا الإجراء لا رجعة فيه. سيتم حذف جميع بياناتك نهائيًا.';

  @override
  String get writeCaption => 'يرجى كتابة تعليق';

  @override
  String get enterRestaurant => 'يرجى إدخال اسم المطعم';

  @override
  String get newPost => 'منشور جديد';

  @override
  String get caption => 'التعليق';

  @override
  String get captionPlaceholder => 'شارك تجربتك الطهي...';

  @override
  String get dishName => 'اسم الطبق';

  @override
  String get dishNameOptional => '(اختياري)';

  @override
  String get dishNamePlaceholder => 'مثال: كسكس ملكي، سمك مشوي...';

  @override
  String get yourRating => 'تقييمك';

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
  String get createNewChallenge => 'إنشاء تحدي جديد';

  @override
  String get enterChallengeTitle => 'مثال: \"جرب 5 أطباق\"';

  @override
  String get titleRequired => 'العنوان مطلوب';

  @override
  String get titleTooShort => 'يجب أن يحتوي العنوان على 5 أحرف على الأقل';

  @override
  String get enterDescription => 'أخبرنا عن مطعمك';

  @override
  String get descriptionRequired => 'الوصف مطلوب';

  @override
  String get challengeType => 'نوع التحدي';

  @override
  String get enterTargetCount => 'مثال: 5 (عدد المنشورات المطلوبة)';

  @override
  String get targetCountRequired => 'الهدف مطلوب';

  @override
  String get invalidTargetCount => 'يجب أن يكون على الأقل 1';

  @override
  String get targetCountTooHigh => 'يجب أن يكون 100 أو أقل';

  @override
  String get enterRewardBadge => 'مثال: \"مستكشف الطعام 🍕\"';

  @override
  String get rewardBadgeRequired => 'شارة المكافأة مطلوبة';

  @override
  String get challengeInfo => 'سيكسب المستخدمون نقاطاً عند النشر عن مطعمك';

  @override
  String get challengeDetails => 'تفاصيل التحدي';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get bio => 'نبذة';

  @override
  String get confirm => 'تأكيد';

  @override
  String get errorOccurred => 'حدث خطأ';

  @override
  String get enterRestaurantName => 'أدخل اسم المطعم';

  @override
  String get restaurantNameRequired => 'اسم المطعم مطلوب';

  @override
  String get restaurantNameTooShort =>
      'يجب أن يحتوي اسم المطعم على 3 أحرف على الأقل';

  @override
  String get enterCuisineType => 'مثال: إيطالي، صيني، فرنسي';

  @override
  String get cuisineTypeRequired => 'نوع المطبخ مطلوب';

  @override
  String get enterLocation => 'أدخل موقع المطعم';

  @override
  String get locationRequired => 'الموقع مطلوب';

  @override
  String get hours => 'ساعات العمل';

  @override
  String get enterHours => 'مثال: الإثنين-الجمعة: 9ص-10م';

  @override
  String get convertNow => 'تحويل الآن';

  @override
  String get mentions => 'الإشارات';

  @override
  String get locationNotSpecified => 'الموقع غير محدد';

  @override
  String get restaurantUpdatedSuccess => 'تم تحديث المطعم بنجاح';

  @override
  String get addCoverPhoto => 'إضافة صورة غلاف';

  @override
  String get deleteDish => 'حذف الطبق؟';

  @override
  String deleteDishConfirm(Object name) {
    return 'هل أنت متأكد من حذف \"$name\"؟';
  }

  @override
  String get delete => 'حذف';

  @override
  String get menuEmpty => 'لا توجد أطباق بعد';

  @override
  String get addFirstDish => 'إضافة أول طبق';

  @override
  String get couldNotLoadMenu => 'تعذر تحميل القائمة';

  @override
  String uploadImageFail(Object error) {
    return 'فشل رفع الصورة: $error';
  }

  @override
  String get editDish => 'تعديل الطبق';

  @override
  String get addDish => 'إضافة طبق';

  @override
  String get addDishPhoto => 'إضافة صورة للطبق';

  @override
  String get price => 'السعر';

  @override
  String get category => 'الفئة (مثال: مقبلات، رئيسي)';

  @override
  String get dishDescription => 'الوصف';

  @override
  String get doYouWantToContinue => 'هل تريد المتابعة؟';

  @override
  String get trending => 'رائج';

  @override
  String get allRestaurants => 'جميع المطاعم';

  @override
  String get results => 'النتائج';

  @override
  String resultsFor(Object query) {
    return 'نتائج لـ \"$query\"';
  }

  @override
  String get noRestaurantsAvailable => 'لا توجد مطاعم متاحة';

  @override
  String get noResultsFound => 'لم يتم العثور على نتائج';

  @override
  String get tryOtherKeywords => 'جرب كلمات مفتاحية أخرى';

  @override
  String get noFollowers => 'لا يوجد متابعون بعد';

  @override
  String get resetPassword => 'إعادة تعيين';

  @override
  String get forgotPasswordTitle => 'نسيت كلمة المرور؟';

  @override
  String get forgotPasswordSubtitle =>
      'لا تقلق! أدخل عنوان بريدك الإلكتروني وسنرسل لك رابطًا لإعادة تعيين كلمة المرور الخاصة بك.';

  @override
  String get rememberPasswordQuestion => 'تتذكر كلمة المرور الخاصة بك؟ ';

  @override
  String get signInLink => 'تسجيل الدخول';

  @override
  String get loggingIn => 'جاري تسجيل الدخول...';

  @override
  String get signInButton => 'تسجيل الدخول';

  @override
  String get timeToEat => 'حان وقت الأكل!';

  @override
  String get loginSubtitle =>
      'قم بتسجيل الدخول للعثور على أصدقائك واكتشاف أطباق جديدة ومشاركة لحظاتك اللذيذة.';

  @override
  String get rememberMe => 'تذكرني';

  @override
  String get continueWithSocial => 'المتابعة عبر';

  @override
  String get noAccount => 'ليس لديك حساب؟';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get registeringAccount => 'جاري التسجيل...';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get welcomeToCommunity => 'مرحبًا بك في مجتمع Ate!';

  @override
  String get signupSubtitle =>
      'أنشئ ملفك الشخصي وابدأ في استكشاف أطباق أصدقائك المفضلة — اكتشف وشارك واستمتع بكل لحظة.';

  @override
  String get password => 'كلمة المرور';

  @override
  String get forgotPasswordQuestion => 'نسيت كلمة المرور؟';

  @override
  String get continueWith => 'المتابعة مع';

  @override
  String get alreadyHaveAccountQuestion => 'هل لديك حساب بالفعل؟ ';

  @override
  String get signInNow => 'تسجيل الدخول';

  @override
  String get next => 'التالي';

  @override
  String get markAllAsRead => 'تعليم الكل كمقروء';

  @override
  String get noNotifications => 'لا توجد إشعارات بعد';

  @override
  String get searchRestaurants => 'ابحث عن المطاعم...';

  @override
  String get trendingNearYou => 'الرائج بالقرب منك';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get recentSearches => 'عمليات البحث الأخيرة';

  @override
  String maxImagesMessage(Object maxImages) {
    return 'يمكنك اختيار ما يصل إلى $maxImages صور';
  }

  @override
  String imageSelectionError(Object error) {
    return 'فشل اختيار الصورة: $error';
  }

  @override
  String get selectAtLeastOne => 'يرجى اختيار صورة واحدة على الأقل';

  @override
  String get choosePhoto => 'اختر صورة';

  @override
  String get gallery => 'المعرض';

  @override
  String get takePhoto => 'التقط صورة';

  @override
  String get addPhotos => 'إضافة صور';

  @override
  String get shareYourCulinaryExperience => 'شارك تجربتك الطهوية\nمع صور جميلة';

  @override
  String get selectPhotos => 'اختر الصور';

  @override
  String get add => 'إضافة';

  @override
  String get activeChallengesLabel => 'التحديات النشطة';

  @override
  String get allChallengesLabel => 'جميع التحديات';

  @override
  String get noChallengesAvailable => 'لا توجد تحديات متاحة';

  @override
  String get newChallengesWillAppear => 'ستظهر التحديات الجديدة هنا';

  @override
  String get post => 'منشور';

  @override
  String get imageLoadFailed => 'فشل تحميل الصورة';

  @override
  String get comments => 'التعليقات';

  @override
  String get addComment => 'أضف تعليقاً...';

  @override
  String get deletePost => 'حذف المنشور؟';

  @override
  String get deletePostConfirm => 'هذا الإجراء لا يمكن التراجع عنه.';

  @override
  String get publish => 'نشر';

  @override
  String get postPublished => 'تم نشر المنشور بنجاح!';

  @override
  String get follow => 'متابعة';

  @override
  String get noSavedPosts => 'لا توجد منشورات محفوظة';

  @override
  String get progress => 'Progress';

  @override
  String get joined => 'تم الانضمام!';

  @override
  String get percentCompleted => '% completed';

  @override
  String get join => 'Join';
}
