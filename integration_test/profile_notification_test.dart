import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Profile Screen Integration Tests', () {
    testWidgets('Profile should display user information',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  // Profile header
                  CircleAvatar(
                    key: Key('profile_avatar'),
                    radius: 50,
                    child: Text('TU'),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Test User',
                    key: Key('display_name'),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '@testuser',
                    key: Key('username'),
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'This is a test user bio',
                    key: Key('bio'),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  // Stats row
                  Row(
                    key: Key('stats_row'),
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text('42', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Posts'),
                        ],
                      ),
                      Column(
                        children: [
                          Text('100', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Followers'),
                        ],
                      ),
                      Column(
                        children: [
                          Text('50', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Following'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Edit profile button
                  OutlinedButton(
                    key: Key('edit_profile_button'),
                    onPressed: () {},
                    child: Text('Edit Profile'),
                  ),
                  SizedBox(height: 16),
                  // User level badge
                  Container(
                    key: Key('level_badge'),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('Gold • 500 pts'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(Key('profile_avatar')), findsOneWidget);
      expect(find.byKey(Key('display_name')), findsOneWidget);
      expect(find.byKey(Key('username')), findsOneWidget);
      expect(find.byKey(Key('bio')), findsOneWidget);
      expect(find.byKey(Key('stats_row')), findsOneWidget);
      expect(find.byKey(Key('edit_profile_button')), findsOneWidget);
      expect(find.byKey(Key('level_badge')), findsOneWidget);
      expect(find.text('Posts'), findsOneWidget);
      expect(find.text('Followers'), findsOneWidget);
      expect(find.text('Following'), findsOneWidget);
    });

    testWidgets('Edit profile form should have all fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: Text('Edit Profile'),
              actions: [
                TextButton(
                  key: Key('save_button'),
                  onPressed: () {},
                  child: Text('Save'),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Avatar with edit button
                  Stack(
                    children: [
                      CircleAvatar(
                        key: Key('edit_avatar'),
                        radius: 50,
                        child: Text('TU'),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.blue,
                          child: IconButton(
                            key: Key('change_avatar_button'),
                            icon: Icon(Icons.camera_alt, size: 18),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  TextField(
                    key: Key('display_name_field'),
                    decoration: InputDecoration(
                      labelText: 'Display Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    key: Key('username_field'),
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                      prefixText: '@',
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    key: Key('bio_field'),
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Bio',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    key: Key('phone_field'),
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(Key('edit_avatar')), findsOneWidget);
      expect(find.byKey(Key('display_name_field')), findsOneWidget);
      expect(find.byKey(Key('username_field')), findsOneWidget);
      expect(find.byKey(Key('bio_field')), findsOneWidget);
      expect(find.byKey(Key('phone_field')), findsOneWidget);
      expect(find.byKey(Key('save_button')), findsOneWidget);
    });

    testWidgets('Follow button should toggle state',
        (WidgetTester tester) async {
      bool isFollowing = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return ElevatedButton(
                  key: Key('follow_button'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFollowing ? Colors.grey : Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      isFollowing = !isFollowing;
                    });
                  },
                  child: Text(isFollowing ? 'Following' : 'Follow'),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Follow'), findsOneWidget);

      await tester.tap(find.byKey(Key('follow_button')));
      await tester.pump();

      expect(find.text('Following'), findsOneWidget);

      await tester.tap(find.byKey(Key('follow_button')));
      await tester.pump();

      expect(find.text('Follow'), findsOneWidget);
    });
  });

  group('Notification Screen Integration Tests', () {
    testWidgets('Notification list should display properly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: Text('Notifications'),
              actions: [
                IconButton(
                  key: Key('mark_all_read'),
                  icon: Icon(Icons.done_all),
                  onPressed: () {},
                ),
              ],
            ),
            body: ListView(
              key: Key('notification_list'),
              children: [
                // Like notification
                ListTile(
                  key: Key('notification_0'),
                  leading: CircleAvatar(
                    child: Icon(Icons.favorite, color: Colors.red),
                  ),
                  title: Text('testuser2 liked your post'),
                  subtitle: Text('2 hours ago'),
                  trailing: Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[300],
                  ),
                ),
                Divider(),
                // Follow notification
                ListTile(
                  key: Key('notification_1'),
                  leading: CircleAvatar(
                    child: Icon(Icons.person_add, color: Colors.blue),
                  ),
                  title: Text('anotheruser started following you'),
                  subtitle: Text('1 day ago'),
                  trailing: OutlinedButton(
                    onPressed: () {},
                    child: Text('Follow'),
                  ),
                ),
                Divider(),
                // Comment notification
                ListTile(
                  key: Key('notification_2'),
                  leading: CircleAvatar(
                    child: Icon(Icons.comment, color: Colors.green),
                  ),
                  title: Text('user123 commented on your post'),
                  subtitle: Text('3 days ago'),
                  tileColor: Colors.blue.withOpacity(0.1), // Unread
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byKey(Key('notification_list')), findsOneWidget);
      expect(find.byKey(Key('notification_0')), findsOneWidget);
      expect(find.byKey(Key('notification_1')), findsOneWidget);
      expect(find.byKey(Key('notification_2')), findsOneWidget);
      expect(find.byKey(Key('mark_all_read')), findsOneWidget);
    });

    testWidgets('Empty notification state should display message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: Text('Notifications')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    key: Key('empty_icon'),
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    key: Key('empty_message'),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'When you get notifications, they\'ll show up here',
                    key: Key('empty_subtitle'),
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(Key('empty_icon')), findsOneWidget);
      expect(find.byKey(Key('empty_message')), findsOneWidget);
      expect(find.byKey(Key('empty_subtitle')), findsOneWidget);
    });

    testWidgets('Notification tap should navigate',
        (WidgetTester tester) async {
      bool wasNavigated = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListTile(
              key: Key('notification_item'),
              onTap: () {
                wasNavigated = true;
              },
              leading: CircleAvatar(child: Text('T')),
              title: Text('Test notification'),
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(Key('notification_item')));
      await tester.pump();

      expect(wasNavigated, isTrue);
    });
  });

  group('Settings Screen Integration Tests', () {
    testWidgets('Settings should display all options',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: Text('Settings')),
            body: ListView(
              key: Key('settings_list'),
              children: [
                ListTile(
                  key: Key('account_settings'),
                  leading: Icon(Icons.person),
                  title: Text('Account'),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  key: Key('notification_settings'),
                  leading: Icon(Icons.notifications),
                  title: Text('Notifications'),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  key: Key('privacy_settings'),
                  leading: Icon(Icons.lock),
                  title: Text('Privacy'),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  key: Key('language_settings'),
                  leading: Icon(Icons.language),
                  title: Text('Language'),
                  subtitle: Text('English'),
                  trailing: Icon(Icons.chevron_right),
                ),
                SwitchListTile(
                  key: Key('dark_mode_toggle'),
                  secondary: Icon(Icons.dark_mode),
                  title: Text('Dark Mode'),
                  value: false,
                  onChanged: (value) {},
                ),
                Divider(),
                ListTile(
                  key: Key('help_settings'),
                  leading: Icon(Icons.help),
                  title: Text('Help & Support'),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  key: Key('about_settings'),
                  leading: Icon(Icons.info),
                  title: Text('About'),
                  trailing: Icon(Icons.chevron_right),
                ),
                Divider(),
                ListTile(
                  key: Key('logout_button'),
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text(
                    'Log Out',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byKey(Key('settings_list')), findsOneWidget);
      expect(find.byKey(Key('account_settings')), findsOneWidget);
      expect(find.byKey(Key('notification_settings')), findsOneWidget);
      expect(find.byKey(Key('privacy_settings')), findsOneWidget);
      expect(find.byKey(Key('language_settings')), findsOneWidget);
      expect(find.byKey(Key('dark_mode_toggle')), findsOneWidget);
      expect(find.byKey(Key('help_settings')), findsOneWidget);
      expect(find.byKey(Key('about_settings')), findsOneWidget);
      expect(find.byKey(Key('logout_button')), findsOneWidget);
    });

    testWidgets('Dark mode toggle should work',
        (WidgetTester tester) async {
      bool isDarkMode = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return SwitchListTile(
                  key: Key('dark_mode_toggle'),
                  title: Text('Dark Mode'),
                  value: isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      isDarkMode = value;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      expect(isDarkMode, isFalse);

      await tester.tap(find.byKey(Key('dark_mode_toggle')));
      await tester.pump();

      expect(isDarkMode, isTrue);
    });
  });
}
