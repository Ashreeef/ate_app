import 'package:flutter/material.dart';
import 'utils/theme.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/home/navigation_shell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ate',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const NavigationShell(),
        // TODO: Add auth routes
        // '/login': (context) => const LoginScreen(),
        // '/signup': (context) => const SignupScreen(),
      },
    );
  }
}
