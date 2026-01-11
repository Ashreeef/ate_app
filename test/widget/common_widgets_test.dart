import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  group('Common Widget Tests', () {
    group('Loading Indicator', () {
      testWidgets('should display CircularProgressIndicator', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('Error Display', () {
      testWidgets('should display error message with icon', (
        WidgetTester tester,
      ) async {
        const errorMessage = 'Something went wrong';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 48),
                    SizedBox(height: 16),
                    Text(
                      errorMessage,
                      key: Key('error_message'),
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      key: Key('retry_button'),
                      onPressed: () {},
                      child: Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text(errorMessage), findsOneWidget);
        expect(find.byKey(Key('retry_button')), findsOneWidget);
      });
    });

    group('Empty State', () {
      testWidgets('should display empty state message', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No items found',
                      key: Key('empty_message'),
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
        expect(find.text('No items found'), findsOneWidget);
      });
    });

    group('Snackbar', () {
      testWidgets('should display snackbar message', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  key: Key('show_snackbar'),
                  onPressed: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Test message')));
                  },
                  child: Text('Show Snackbar'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.byKey(Key('show_snackbar')));
        await tester.pump();
        await tester.pump(Duration(milliseconds: 750));

        expect(find.text('Test message'), findsOneWidget);
      });
    });

    group('Dialog', () {
      testWidgets('should display alert dialog', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  key: Key('show_dialog'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Confirm Action'),
                        content: Text('Are you sure?'),
                        actions: [
                          TextButton(
                            key: Key('cancel_button'),
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                          ElevatedButton(
                            key: Key('confirm_button'),
                            onPressed: () => Navigator.pop(context),
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text('Show Dialog'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.byKey(Key('show_dialog')));
        await tester.pumpAndSettle();

        expect(find.text('Confirm Action'), findsOneWidget);
        expect(find.text('Are you sure?'), findsOneWidget);
        expect(find.byKey(Key('cancel_button')), findsOneWidget);
        expect(find.byKey(Key('confirm_button')), findsOneWidget);
      });

      testWidgets('dialog should close on cancel', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  key: Key('show_dialog'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Test Dialog'),
                        actions: [
                          TextButton(
                            key: Key('cancel_button'),
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text('Show'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.byKey(Key('show_dialog')));
        await tester.pumpAndSettle();

        expect(find.text('Test Dialog'), findsOneWidget);

        await tester.tap(find.byKey(Key('cancel_button')));
        await tester.pumpAndSettle();

        expect(find.text('Test Dialog'), findsNothing);
      });
    });

    group('Bottom Navigation', () {
      testWidgets('should display bottom navigation bar', (
        WidgetTester tester,
      ) async {
        int selectedIndex = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: StatefulBuilder(
              builder: (context, setState) {
                return Scaffold(
                  body: Center(child: Text('Tab $selectedIndex')),
                  bottomNavigationBar: BottomNavigationBar(
                    key: Key('bottom_nav'),
                    currentIndex: selectedIndex,
                    onTap: (index) => setState(() => selectedIndex = index),
                    type: BottomNavigationBarType.fixed,
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.search),
                        label: 'Search',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.add_box_outlined),
                        label: 'Create',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.notifications),
                        label: 'Notifications',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'Profile',
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );

        expect(find.byKey(Key('bottom_nav')), findsOneWidget);
        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Search'), findsOneWidget);
        expect(find.text('Create'), findsOneWidget);
        expect(find.text('Notifications'), findsOneWidget);
        expect(find.text('Profile'), findsOneWidget);
      });

      testWidgets('should navigate between tabs', (WidgetTester tester) async {
        int selectedIndex = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: StatefulBuilder(
              builder: (context, setState) {
                return Scaffold(
                  body: Center(
                    child: Text(
                      'Current Tab: $selectedIndex',
                      key: Key('current_tab'),
                    ),
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                    currentIndex: selectedIndex,
                    onTap: (index) => setState(() => selectedIndex = index),
                    type: BottomNavigationBarType.fixed,
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.search),
                        label: 'Search',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'Profile',
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );

        expect(find.text('Current Tab: 0'), findsOneWidget);

        await tester.tap(find.text('Search'));
        await tester.pump();

        expect(find.text('Current Tab: 1'), findsOneWidget);

        await tester.tap(find.text('Profile'));
        await tester.pump();

        expect(find.text('Current Tab: 2'), findsOneWidget);
      });
    });

    group('Pull to Refresh', () {
      testWidgets('should handle pull to refresh', (WidgetTester tester) async {
        bool refreshed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RefreshIndicator(
                key: Key('refresh_indicator'),
                onRefresh: () async {
                  refreshed = true;
                  await Future.delayed(Duration(milliseconds: 100));
                },
                child: ListView(
                  children: [
                    ListTile(title: Text('Item 1')),
                    ListTile(title: Text('Item 2')),
                    ListTile(title: Text('Item 3')),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.byKey(Key('refresh_indicator')), findsOneWidget);

        // Simulate pull to refresh
        await tester.fling(find.byType(ListView), Offset(0, 300), 1000);
        await tester.pump();
        await tester.pump(Duration(milliseconds: 100));
        await tester.pumpAndSettle();

        expect(refreshed, isTrue);
      });
    });

    group('Avatar', () {
      testWidgets('should display user avatar with initials', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircleAvatar(
                  key: Key('avatar'),
                  radius: 30,
                  child: Text('TU'),
                ),
              ),
            ),
          ),
        );

        expect(find.byKey(Key('avatar')), findsOneWidget);
        expect(find.text('TU'), findsOneWidget);
      });
    });

    group('Image Placeholder', () {
      testWidgets('should display placeholder when image loading', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Container(
                key: Key('image_placeholder'),
                width: 100,
                height: 100,
                color: Colors.grey[300],
                child: Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
        );

        expect(find.byKey(Key('image_placeholder')), findsOneWidget);
        expect(find.byIcon(Icons.image), findsOneWidget);
      });
    });
  });
}
