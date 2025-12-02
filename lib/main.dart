import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'utils/theme.dart';
import 'utils/seed_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Seed test data
  await DatabaseSeeder.seedTestData();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProfileCubit(ProfileRepository())),
        BlocProvider(create: (_) => SettingsCubit()..loadSettings()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          return MaterialApp(
            title: 'Ate',
            debugShowCheckedModeBanner: false,
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
            routes: {
              '/onboarding': (context) => const OnboardingScreen(),
              '/login': (context) => const LoginScreen(),
              '/signup': (context) => const SignupScreen(),
              '/forgot-password': (context) => const ForgotPasswordScreen(),
              '/home': (context) => const NavigationShell(),
            },
          );
        },
      ),
    );
  }
}
