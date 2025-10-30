import 'package:flutter/material.dart';
import '../../widgets/navigation/bottom_nav_bar.dart';
import '../../utils/constants.dart';
import '../home/feed_screen.dart';
import '../search/search_screen.dart';
import '../post/post_creation_step1_screen.dart';
import '../challenges/challenges_screen.dart';
import '../profile/my_profile_screen.dart';

class NavigationShell extends StatefulWidget {
  const NavigationShell({Key? key}) : super(key: key);

  @override
  State<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
  int _currentIndex = 0;

  // List of screens for each tab
  final List<Widget> _screens = const [
    FeedScreen(),
    SearchScreen(),
    PostCreationStep1Screen(),
    ChallengesScreen(),
    MyProfileScreen(),
  ];

  // AppBar configurations for each tab
  PreferredSizeWidget? _buildAppBar() {
    switch (_currentIndex) {
      case 0: // Feed/Home
        return null; // Feed has its own custom header
      case 1: // Search
        return AppBar(title: Text('Rechercher'));
      case 2: // Post Creation
        return AppBar(
          leading: TextButton(
            onPressed: () {
              setState(() => _currentIndex = 0); // Go back to feed
            },
            child: Text('Annuler', style: AppTextStyles.bodySmall),
          ),
          leadingWidth: 80,
          title: Text('Nouveau Post'),
          actions: [
            TextButton(
              onPressed: () {
                // TODO: Navigate to step 2
              },
              child: Text('Next', style: AppTextStyles.link),
            ),
          ],
        );
      case 3: // Challenges
        return AppBar(title: Text('Challenges'));
      case 4: // Profile
        return AppBar(
          title: Text('Profile'),
          actions: [
            IconButton(
              icon: Icon(Icons.settings_outlined),
              onPressed: () {
                // TODO: Navigate to settings
              },
            ),
          ],
        );
      default:
        return null;
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
