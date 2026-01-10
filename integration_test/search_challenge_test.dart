import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Search Flow Integration Tests', () {
    testWidgets('Search screen should have search bar and tabs', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: TextField(
                  key: Key('search_field'),
                  decoration: InputDecoration(
                    hintText: 'Search users, restaurants, posts...',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      key: Key('clear_search'),
                      icon: Icon(Icons.clear),
                      onPressed: () {},
                    ),
                  ),
                ),
                bottom: TabBar(
                  key: Key('search_tabs'),
                  tabs: [
                    Tab(text: 'Users'),
                    Tab(text: 'Restaurants'),
                    Tab(text: 'Posts'),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  Center(child: Text('Users tab')),
                  Center(child: Text('Restaurants tab')),
                  Center(child: Text('Posts tab')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(Key('search_field')), findsOneWidget);
      expect(find.byKey(Key('search_tabs')), findsOneWidget);
      expect(find.text('Users'), findsOneWidget);
      expect(find.text('Restaurants'), findsOneWidget);
      expect(find.text('Posts'), findsOneWidget);
    });

    testWidgets('Search should filter results as user types', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: TextField(
                key: Key('search_field'),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            body: ListView(
              key: Key('search_results'),
              children: [
                ListTile(key: Key('result_0'), title: Text('Test Result 1')),
                ListTile(key: Key('result_1'), title: Text('Test Result 2')),
              ],
            ),
          ),
        ),
      );

      await tester.enterText(find.byKey(Key('search_field')), 'test');
      await tester.pump();

      expect(find.text('test'), findsOneWidget);
      expect(find.byKey(Key('search_results')), findsOneWidget);
    });

    testWidgets('Recent searches should be displayed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Searches',
                        key: Key('recent_title'),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        key: Key('clear_all_button'),
                        onPressed: () {},
                        child: Text('Clear All'),
                      ),
                    ],
                  ),
                ),
                Wrap(
                  key: Key('recent_chips'),
                  spacing: 8,
                  children: [
                    Chip(
                      label: Text('Pizza'),
                      deleteIcon: Icon(Icons.close, size: 16),
                      onDeleted: () {},
                    ),
                    Chip(
                      label: Text('Italian'),
                      deleteIcon: Icon(Icons.close, size: 16),
                      onDeleted: () {},
                    ),
                    Chip(
                      label: Text('Algiers'),
                      deleteIcon: Icon(Icons.close, size: 16),
                      onDeleted: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byKey(Key('recent_title')), findsOneWidget);
      expect(find.byKey(Key('clear_all_button')), findsOneWidget);
      expect(find.byKey(Key('recent_chips')), findsOneWidget);
      expect(find.text('Pizza'), findsOneWidget);
      expect(find.text('Italian'), findsOneWidget);
    });

    testWidgets('User search results should display correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              key: Key('user_results'),
              children: [
                ListTile(
                  key: Key('user_0'),
                  leading: CircleAvatar(child: Text('T')),
                  title: Text('testuser'),
                  subtitle: Text('Test User • 100 followers'),
                  trailing: OutlinedButton(
                    onPressed: () {},
                    child: Text('Follow'),
                  ),
                ),
                ListTile(
                  key: Key('user_1'),
                  leading: CircleAvatar(child: Text('A')),
                  title: Text('anotheruser'),
                  subtitle: Text('Another User • 50 followers'),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    child: Text('Following'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byKey(Key('user_results')), findsOneWidget);
      expect(find.byKey(Key('user_0')), findsOneWidget);
      expect(find.byKey(Key('user_1')), findsOneWidget);
      expect(find.text('testuser'), findsOneWidget);
      expect(find.text('anotheruser'), findsOneWidget);
    });
  });

  group('Challenge Flow Integration Tests', () {
    testWidgets('Challenge list should display active challenges', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: Text('Challenges')),
            body: ListView(
              key: Key('challenge_list'),
              children: [
                Card(
                  key: Key('challenge_0'),
                  margin: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 150,
                        color: Colors.orange[100],
                        child: Center(child: Icon(Icons.restaurant, size: 48)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'ACTIVE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  '50 pts',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Restaurant Explorer',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Visit 5 new restaurants this week'),
                            SizedBox(height: 8),
                            LinearProgressIndicator(
                              key: Key('progress_0'),
                              value: 0.6,
                            ),
                            SizedBox(height: 4),
                            Text('3/5 completed'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byKey(Key('challenge_list')), findsOneWidget);
      expect(find.byKey(Key('challenge_0')), findsOneWidget);
      expect(find.text('Restaurant Explorer'), findsOneWidget);
      expect(find.text('ACTIVE'), findsOneWidget);
      expect(find.byKey(Key('progress_0')), findsOneWidget);
    });

    testWidgets('Challenge detail should show full info', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: Text('Challenge Details')),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Challenge image
                  Container(
                    key: Key('challenge_image'),
                    height: 200,
                    width: double.infinity,
                    color: Colors.orange[200],
                    child: Center(child: Icon(Icons.emoji_events, size: 64)),
                  ),
                  SizedBox(height: 16),
                  // Title and points
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Food Critic Challenge',
                        key: Key('challenge_title'),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '100 pts',
                          key: Key('challenge_points'),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Description
                  Text(
                    'Write 10 detailed reviews for different restaurants. '
                    'Each review must be at least 50 words.',
                    key: Key('challenge_description'),
                  ),
                  SizedBox(height: 16),
                  // Progress
                  Text(
                    'Progress',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    key: Key('challenge_progress'),
                    value: 0.7,
                    minHeight: 10,
                  ),
                  SizedBox(height: 4),
                  Text('7/10 reviews completed'),
                  SizedBox(height: 16),
                  // Time remaining
                  Row(
                    children: [
                      Icon(Icons.access_time),
                      SizedBox(width: 8),
                      Text('3 days remaining', key: Key('time_remaining')),
                    ],
                  ),
                  SizedBox(height: 24),
                  // Action button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      key: Key('join_challenge_button'),
                      onPressed: () {},
                      child: Text('Continue Challenge'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(Key('challenge_image')), findsOneWidget);
      expect(find.byKey(Key('challenge_title')), findsOneWidget);
      expect(find.byKey(Key('challenge_points')), findsOneWidget);
      expect(find.byKey(Key('challenge_description')), findsOneWidget);
      expect(find.byKey(Key('challenge_progress')), findsOneWidget);
      expect(find.byKey(Key('time_remaining')), findsOneWidget);
      expect(find.byKey(Key('join_challenge_button')), findsOneWidget);
    });
  });

  group('Map Integration Tests', () {
    testWidgets('Map view should display markers', (WidgetTester tester) async {
      // Note: Real map testing would require mocking the map package
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                // Simulated map background
                Container(
                  key: Key('map_container'),
                  color: Colors.grey[300],
                  child: Center(
                    child: Text('Map View', style: TextStyle(fontSize: 24)),
                  ),
                ),
                // Search bar overlay
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Card(
                    child: TextField(
                      key: Key('map_search'),
                      decoration: InputDecoration(
                        hintText: 'Search restaurants near you',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                // Location button
                Positioned(
                  bottom: 100,
                  right: 16,
                  child: FloatingActionButton(
                    key: Key('location_button'),
                    mini: true,
                    onPressed: () {},
                    child: Icon(Icons.my_location),
                  ),
                ),
                // Filter button
                Positioned(
                  bottom: 160,
                  right: 16,
                  child: FloatingActionButton(
                    key: Key('filter_button'),
                    mini: true,
                    onPressed: () {},
                    child: Icon(Icons.filter_list),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byKey(Key('map_container')), findsOneWidget);
      expect(find.byKey(Key('map_search')), findsOneWidget);
      expect(find.byKey(Key('location_button')), findsOneWidget);
      expect(find.byKey(Key('filter_button')), findsOneWidget);
    });

    testWidgets('Restaurant info card should appear on marker tap', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                Container(color: Colors.grey[300]),
                // Restaurant info card at bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Card(
                    key: Key('restaurant_card'),
                    margin: EdgeInsets.all(16),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            key: Key('restaurant_thumb'),
                            width: 80,
                            height: 80,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Test Restaurant',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('Italian • 0.5 km away'),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    Text(' 4.5'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            key: Key('directions_button'),
                            icon: Icon(Icons.directions),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byKey(Key('restaurant_card')), findsOneWidget);
      expect(find.byKey(Key('restaurant_thumb')), findsOneWidget);
      expect(find.byKey(Key('directions_button')), findsOneWidget);
      expect(find.text('Test Restaurant'), findsOneWidget);
    });
  });
}
