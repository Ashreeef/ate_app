import 'package:flutter/material.dart';
import '../../widgets/navigation/bottom_nav_bar.dart';
import '../../utils/constants.dart';
import '../home/feed_screen.dart';
import '../search/search_screen.dart';
import '../post/post_creation_step1_screen.dart';
import '../challenges/challenges_screen.dart';
import '../profile/my_profile_screen.dart';
import '../../l10n/app_localizations.dart';

class NavigationShell extends StatefulWidget {
  const NavigationShell({super.key});

  /// Static method to switch tabs from anywhere via context
  static void selectTab(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<_NavigationShellState>();
    if (state != null) {
      state.selectTab(index);
    }
  }

  @override
  State<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
  int _currentIndex = 0;

  void selectTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // List of screens for each tab
  final List<Widget> _screens = [
    // REMOVED const HERE
    const FeedScreen(),
    const SearchScreen(),
    PostCreationStep1Screen(), // NO const here
    const ChallengesScreen(),
    const MyProfileScreen(),
  ];

  // AppBar configurations for each tab
  PreferredSizeWidget? _buildAppBar() {
    final l10n = AppLocalizations.of(context)!;

    switch (_currentIndex) {
      case 0: // Feed/Home
        return null; // Feed has its own custom header

      case 1: // Search
        return AppBar(title: Text(l10n.search));

      case 2: // Post Creation
        return AppBar(
          leading: TextButton(
            onPressed: () {
              setState(() => _currentIndex = 0);
            },
            child: Text(l10n.cancel, style: AppTextStyles.bodySmall),
          ),
          leadingWidth: 80,
          title: Text(l10n.newPost),
          actions: [
            TextButton(
              onPressed: () {
                // Call your screen's navigation method
                final state = PostCreationStep1Screen.globalKey.currentState;
                if (state != null && state.hasSelectedImages) {
                  state.navigateToNextStep();
                }
              },
              child: Text(l10n.next, style: AppTextStyles.link),
            ),
          ],
        );

      case 3: // Challenges
        return AppBar(title: Text(l10n.challengesTitle));

      case 4: // Profile
        return null; // Profile screen has its own app bar
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
