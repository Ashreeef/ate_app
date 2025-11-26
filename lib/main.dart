import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:io' show Platform;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'l10n/app_localizations.dart';
import 'utils/theme.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/home/navigation_shell.dart';
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
import 'database/seed_data.dart';
import 'database/quick_validation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize sqflite for desktop platforms (Windows, Linux, macOS)
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Initialize auth service
  await AuthService.instance.initialize();

  // Seed database with comprehensive test data (development only)
  final userRepository = UserRepository();
  final restaurantRepository = RestaurantRepository();
  final postRepository = PostRepository();
  final commentRepository = CommentRepository();
  final likeRepository = LikeRepository();
  final savedPostRepository = SavedPostRepository();
  final searchHistoryRepository = SearchHistoryRepository();

  await SeedData.seedDatabase(
    userRepository,
    restaurantRepository,
    postRepository,
    commentRepository,
    likeRepository,
    savedPostRepository,
    searchHistoryRepository,
  );

  // Validate database seeding (development only)
  await QuickDatabaseValidation.validate();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create repositories
    final userRepository = UserRepository();
    final authService = AuthService.instance;

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>(create: (context) => userRepository),
        RepositoryProvider<AuthService>(create: (context) => authService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              userRepository: userRepository,
              authService: authService,
            ),
          ),
          BlocProvider<UserBloc>(
            create: (context) => UserBloc(
              userRepository: userRepository,
              authService: authService,
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Ate',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,

          // Localization configuration
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
          routes: {
            '/onboarding': (context) => const OnboardingScreen(),
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignupScreen(),
            '/forgot-password': (context) => const ForgotPasswordScreen(),
            '/home': (context) => const NavigationShell(),
          },
        ),
      ),
    );
  }
}
