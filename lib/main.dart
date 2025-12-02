import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'utils/theme.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/home/navigation_shell.dart';
import 'repositories/post_repository.dart';
import 'blocs/feed/feed_bloc.dart';
import 'blocs/post/post_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<PostRepository>(
          create: (_) => PostRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<FeedBloc>(
            create: (context) => FeedBloc(repo: context.read<PostRepository>()),
          ),
          BlocProvider<PostBloc>(
            create: (context) => PostBloc(
              repo: context.read<PostRepository>(),
              feedBloc: context.read<FeedBloc>(),
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
