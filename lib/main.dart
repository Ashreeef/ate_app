import 'package:flutter/material.dart';
import 'utils/theme.dart';
import 'screens/home/navigation_shell.dart';
import 'screens/profile/my_profile_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/profile/edit_profile_screen.dart';

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
      home: SettingsPage(),
    );
  }
}
