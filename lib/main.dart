import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:io' show Platform;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Firebase imports
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';

// App imports
import 'l10n/app_localizations.dart';
import 'utils/theme.dart';
import 'blocs/profile/profile_cubit.dart';
import 'blocs/settings/settings_cubit.dart';
import 'blocs/settings/settings_state.dart';
import 'repositories/profile_repository.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/home/navigation_shell.dart';
import 'screens/notifications/notifications_screen.dart';
import 'blocs/feed/feed_bloc.dart';
import 'blocs/post/post_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/user/user_bloc.dart';
import 'repositories/user_repository.dart';
import 'repositories/restaurant_repository.dart';
import 'repositories/post_repository.dart';
import 'repositories/comment_repository.dart';
import 'repositories/like_repository.dart';
import 'repositories/saved_post_repository.dart';
import 'repositories/search_history_repository.dart';
import 'services/auth_service.dart';
import 'services/firebase_auth_service.dart';
import 'services/cloudinary_storage_service.dart';
import 'services/firestore_service.dart';
import 'services/notification_service.dart';
import 'database/seed_data.dart';
import 'database/quick_validation.dart';
import 'blocs/search/search_bloc.dart';
import 'blocs/restaurant/restaurant_bloc.dart';

// Global repository instances
final UserRepository _userRepository = UserRepository();
final RestaurantRepository _restaurantRepository = RestaurantRepository();
final PostRepository _postRepository = PostRepository();
final CommentRepository _commentRepository = CommentRepository();
final LikeRepository _likeRepository = LikeRepository();
final SavedPostRepository _savedPostRepository = SavedPostRepository();
final SearchHistoryRepository _searchHistoryRepository =
    SearchHistoryRepository();
final ProfileRepository _profileRepository = ProfileRepository();

// Track if FFI has been initialized
bool _ffiInitialized = false;

// Global navigator key for notification handling
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Firebase Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Initialize sqflite for desktop platforms (Windows, Linux, macOS) - only once
  // Note: Will be removed once fully migrated to Firebase
  if (!_ffiInitialized && (Platform.isWindows || Platform.isLinux)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    _ffiInitialized = true;
  }

  // Initialize auth service (will be migrated to Firebase)
  await AuthService.instance.initialize();

  // Initialize notification service
  await NotificationService.instance.initialize(
    onNotificationTap: _handleNotificationTap,
  );

  // Seed database with comprehensive test data (development only)
  await SeedData.seedDatabase(
    _userRepository,
    _restaurantRepository,
    _postRepository,
    _commentRepository,
    _likeRepository,
    _savedPostRepository,
    _searchHistoryRepository,
  );

  // Validate database seeding (development only)
  await QuickDatabaseValidation.validate();

  runApp(const MyApp());
}

/// Handle notification tap - navigate to appropriate screen
void _handleNotificationTap(Map<String, dynamic> data) {
  final type = data['type'] as String?;
  final postId = data['postId'] as String?;

  // Navigate based on notification type
  switch (type) {
    case 'post':
      if (postId != null) {
        navigatorKey.currentState?.pushNamed('/notifications');
      }
      break;
    case 'comment':
      if (postId != null) {
        navigatorKey.currentState?.pushNamed('/notifications');
      }
      break;
    case 'like':
      if (postId != null) {
        navigatorKey.currentState?.pushNamed('/notifications');
      }
      break;
    default:
      // Default action - open notifications screen
      navigatorKey.currentState?.pushNamed('/notifications');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService.instance;

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>(
          create: (context) => _userRepository,
        ),
        RepositoryProvider<PostRepository>(
          create: (context) => _postRepository,
        ),
        RepositoryProvider<RestaurantRepository>(
          create: (context) => _restaurantRepository,
        ),
        RepositoryProvider<SearchHistoryRepository>(
          create: (context) => _searchHistoryRepository,
        ),
        RepositoryProvider<LikeRepository>(
          create: (context) => _likeRepository,
        ),
        RepositoryProvider<SavedPostRepository>(
          create: (context) => _savedPostRepository,
        ),
        RepositoryProvider<ProfileRepository>(
          create: (context) => _profileRepository,
        ),
        RepositoryProvider<AuthService>(create: (context) => authService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              userRepository: _userRepository,
              authService: authService,
            ),
          ),
          BlocProvider<UserBloc>(
            create: (context) => UserBloc(
              userRepository: _userRepository,
              authService: authService,
            ),
          ),
          BlocProvider<FeedBloc>(
            create: (context) => FeedBloc(repo: _postRepository),
          ),
          BlocProvider<PostBloc>(
            create: (context) => PostBloc(
              repo: _postRepository,
              likeRepo: context.read<LikeRepository>(),
              savedPostRepo: context.read<SavedPostRepository>(),
              feedBloc: context.read<FeedBloc>(),
            ),
          ),
          BlocProvider<SearchBloc>(
            create: (context) => SearchBloc(
              restaurantRepository: _restaurantRepository,
              searchHistoryRepository: _searchHistoryRepository,
              authService: authService,
            ),
          ),
          BlocProvider<RestaurantBloc>(
            create: (context) =>
                RestaurantBloc(restaurantRepository: _restaurantRepository),
          ),
          BlocProvider<ProfileCubit>(
            create: (context) => ProfileCubit(_profileRepository),
          ),
          BlocProvider<SettingsCubit>(
            create: (context) => SettingsCubit()..loadSettings(),
          ),
        ],
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, settingsState) {
            return MaterialApp(
              title: 'Ate',
              debugShowCheckedModeBanner: false,
              navigatorKey: navigatorKey,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: settingsState.darkTheme
                  ? ThemeMode.dark
                  : ThemeMode.light,

              // Localization configuration
              locale: Locale(settingsState.language),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'), // English
                Locale('ar'), // Arabic
                Locale('fr'), // French
              ],

              home: const SplashScreen(),
              onGenerateRoute: (settings) {
                // Public routes (no auth required)
                final publicRoutes = {
                  '/onboarding': () => const OnboardingScreen(),
                  '/login': () => const LoginScreen(),
                  '/signup': () => const SignupScreen(),
                  '/forgot-password': () => const ForgotPasswordScreen(),
                };

                // Protected routes (auth required)
                final protectedRoutes = {
                  '/home': () => const NavigationShell(),
                  '/notifications': () => const NotificationsScreen(),
                };

                // Check if it's a public route
                if (publicRoutes.containsKey(settings.name)) {
                  return MaterialPageRoute(
                    builder: (context) => publicRoutes[settings.name]!(),
                    settings: settings,
                  );
                }

                // Check if it's a protected route
                if (protectedRoutes.containsKey(settings.name)) {
                  // Route guard: check if user is authenticated
                  if (AuthService.instance.isLoggedIn) {
                    return MaterialPageRoute(
                      builder: (context) => protectedRoutes[settings.name]!(),
                      settings: settings,
                    );
                  } else {
                    // Redirect to login if not authenticated
                    return MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                      settings: const RouteSettings(name: '/login'),
                    );
                  }
                }

                // Unknown route - redirect to splash
                return MaterialPageRoute(
                  builder: (context) => const SplashScreen(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
