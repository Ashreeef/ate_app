import 'dart:async';
import 'dart:io' show Platform;

// Flutter imports
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Third-party imports
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

// Local imports
import 'blocs/auth/auth_bloc.dart';
import 'blocs/challenge/challenge_bloc.dart';
import 'blocs/feed/feed_bloc.dart';
import 'blocs/notification/notification_bloc.dart';
import 'blocs/post/post_bloc.dart';
import 'blocs/profile/profile_cubit.dart';
import 'blocs/restaurant/restaurant_bloc.dart';
import 'blocs/search/search_bloc.dart';
import 'blocs/settings/settings_cubit.dart';
import 'blocs/settings/settings_state.dart';
import 'blocs/user/user_bloc.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'repositories/auth_repository.dart';
import 'repositories/challenge_repository.dart';
import 'repositories/comment_repository.dart';
import 'repositories/follow_repository.dart';
import 'repositories/like_repository.dart';
import 'repositories/notification_repository.dart';
import 'repositories/post_repository.dart';
import 'repositories/profile_repository.dart';
import 'repositories/restaurant_repository.dart';
import 'repositories/review_repository.dart';
import 'repositories/saved_post_repository.dart';
import 'repositories/search_history_repository.dart';
import 'repositories/user_repository.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/home/navigation_shell.dart';
import 'screens/notifications/notifications_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'services/firebase_auth_service.dart';
import 'services/notification_service.dart';
import 'services/restaurant_conversion_service.dart';
import 'utils/notification_navigation_helper.dart';
import 'utils/theme.dart';

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
final AuthRepository _authRepository = AuthRepository();
final NotificationRepository _notificationRepository = NotificationRepository();
final ChallengeRepository _challengeRepository = ChallengeRepository();
final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

// Global navigator key for notification handling
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Firebase Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Initialize notification service
  await NotificationService.instance.initialize(
    onNotificationTap: _handleNotificationTap,
  );

  runApp(const MyApp());
}

/// Handle notification tap - navigate to appropriate screen
void _handleNotificationTap(Map<String, dynamic> data) {
  final context = navigatorKey.currentContext;
  if (context == null) {
    // Fallback: just open notifications screen
    navigatorKey.currentState?.pushNamed('/notifications');
    return;
  }

  // Use the notification navigation helper
  NotificationNavigationHelper.handleNotificationTap(context, data);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
        RepositoryProvider<ReviewRepository>(
          create: (context) => ReviewRepository(
            restaurantRepository: _restaurantRepository,
          ),
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
        RepositoryProvider<AuthRepository>(
          create: (context) => _authRepository,
        ),
        RepositoryProvider<FollowRepository>(
          create: (context) => FollowRepository(),
        ),
        RepositoryProvider<NotificationRepository>(
          create: (context) => _notificationRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(authRepository: _authRepository),
          ),
          BlocProvider<UserBloc>(
            create: (context) => UserBloc(
              userRepository: _userRepository,
              authRepository: _authRepository,
            ),
          ),
          BlocProvider<FeedBloc>(
            create: (context) => FeedBloc(
              repo: _postRepository,
              followRepo: context.read<FollowRepository>(),
              authRepo: _authRepository,
            ),
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
              authRepository: _authRepository,
            ),
          ),
          BlocProvider<RestaurantBloc>(
            create: (context) => RestaurantBloc(
              restaurantRepository: _restaurantRepository,
              postRepository: _postRepository,
              conversionService: RestaurantConversionService(
                userRepository: _userRepository,
                restaurantRepository: _restaurantRepository,
              ),
            ),
          ),
          BlocProvider<ProfileCubit>(
            create: (context) => ProfileCubit(_profileRepository),
          ),
          BlocProvider<SettingsCubit>(
            create: (context) => SettingsCubit()..loadSettings(),
          ),
          BlocProvider<NotificationBloc>(
            create: (context) => NotificationBloc(
              notificationRepository: _notificationRepository,
              authService: _firebaseAuthService,
            ),
          ),
          BlocProvider<ChallengeBloc>(
            create: (context) => ChallengeBloc(
              challengeRepository: _challengeRepository,
            ),
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
                  // Route guard: check if user is authenticated with Firebase
                  if (_authRepository.isAuthenticated) {
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
