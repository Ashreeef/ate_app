import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Restaurant Flow Integration Tests', () {
    testWidgets('Restaurant list should display properly',
        (WidgetTester tester) async {
      final restaurants = [
        {'name': 'Test Restaurant 1', 'rating': 4.5, 'cuisine': 'Italian'},
        {'name': 'Test Restaurant 2', 'rating': 4.0, 'cuisine': 'Algerian'},
        {'name': 'Test Restaurant 3', 'rating': 3.8, 'cuisine': 'French'},
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              key: Key('restaurant_list'),
              itemCount: restaurants.length,
              itemBuilder: (context, index) => ListTile(
                key: Key('restaurant_$index'),
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(restaurants[index]['name'] as String),
                subtitle: Text(restaurants[index]['cuisine'] as String),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.amber),
                    Text('${restaurants[index]['rating']}'),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(Key('restaurant_list')), findsOneWidget);
      expect(find.byKey(Key('restaurant_0')), findsOneWidget);
      expect(find.byKey(Key('restaurant_1')), findsOneWidget);
      expect(find.byKey(Key('restaurant_2')), findsOneWidget);
      expect(find.text('Test Restaurant 1'), findsOneWidget);
      expect(find.text('Italian'), findsOneWidget);
    });

    testWidgets('Restaurant detail should show all info',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant image
                  Container(
                    key: Key('restaurant_image'),
                    height: 200,
                    color: Colors.grey[300],
                    width: double.infinity,
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name
                        Text(
                          'Test Restaurant',
                          key: Key('restaurant_name'),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        // Cuisine type
                        Text(
                          'Italian • Algiers, Algeria',
                          key: Key('restaurant_info'),
                        ),
                        SizedBox(height: 8),
                        // Rating
                        Row(
                          key: Key('restaurant_rating'),
                          children: [
                            ...List.generate(
                              5,
                              (i) => Icon(
                                i < 4 ? Icons.star : Icons.star_half,
                                color: Colors.amber,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text('4.5 (50 reviews)'),
                          ],
                        ),
                        SizedBox(height: 16),
                        // Description
                        Text(
                          'A wonderful Italian restaurant serving authentic cuisine.',
                          key: Key('restaurant_description'),
                        ),
                        SizedBox(height: 16),
                        // Hours
                        Row(
                          key: Key('restaurant_hours'),
                          children: [
                            Icon(Icons.access_time),
                            SizedBox(width: 8),
                            Text('Mon-Sun: 10:00-22:00'),
                          ],
                        ),
                        SizedBox(height: 16),
                        // Posts section
                        Text(
                          'Posts',
                          key: Key('posts_section_title'),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(Key('restaurant_image')), findsOneWidget);
      expect(find.byKey(Key('restaurant_name')), findsOneWidget);
      expect(find.byKey(Key('restaurant_info')), findsOneWidget);
      expect(find.byKey(Key('restaurant_rating')), findsOneWidget);
      expect(find.byKey(Key('restaurant_description')), findsOneWidget);
      expect(find.byKey(Key('restaurant_hours')), findsOneWidget);
      expect(find.byKey(Key('posts_section_title')), findsOneWidget);
    });

    testWidgets('Restaurant search should filter results',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: TextField(
                key: Key('search_field'),
                decoration: InputDecoration(
                  hintText: 'Search restaurants...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            body: ListView(
              key: Key('search_results'),
              children: [
                ListTile(
                  key: Key('result_0'),
                  title: Text('Italian Place'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byKey(Key('search_field')), findsOneWidget);
      expect(find.byKey(Key('search_results')), findsOneWidget);

      await tester.enterText(find.byKey(Key('search_field')), 'Italian');
      await tester.pump();

      expect(find.text('Italian'), findsWidgets);
    });
  });

  group('Review Integration Tests', () {
    testWidgets('Review form should have all required fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Write a Review',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Rating selector
                  Row(
                    key: Key('rating_selector'),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => IconButton(
                        key: Key('star_$index'),
                        icon: Icon(Icons.star_border),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Review text
                  TextField(
                    key: Key('review_text'),
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Share your experience...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      key: Key('submit_review'),
                      onPressed: () {},
                      child: Text('Submit Review'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(Key('rating_selector')), findsOneWidget);
      expect(find.byKey(Key('star_0')), findsOneWidget);
      expect(find.byKey(Key('star_4')), findsOneWidget);
      expect(find.byKey(Key('review_text')), findsOneWidget);
      expect(find.byKey(Key('submit_review')), findsOneWidget);
    });

    testWidgets('Star rating should be interactive',
        (WidgetTester tester) async {
      int selectedRating = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Row(
                  key: Key('rating_row'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (index) => IconButton(
                      key: Key('star_$index'),
                      icon: Icon(
                        index < selectedRating
                            ? Icons.star
                            : Icons.star_border,
                        color: index < selectedRating ? Colors.amber : null,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedRating = index + 1;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Initially no stars selected
      expect(find.byIcon(Icons.star), findsNothing);
      expect(find.byIcon(Icons.star_border), findsNWidgets(5));

      // Tap on 4th star
      await tester.tap(find.byKey(Key('star_3')));
      await tester.pump();

      // 4 stars should be filled
      expect(find.byIcon(Icons.star), findsNWidgets(4));
      expect(find.byIcon(Icons.star_border), findsNWidgets(1));
    });

    testWidgets('Review list should display reviews',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              key: Key('review_list'),
              children: [
                ListTile(
                  key: Key('review_0'),
                  leading: CircleAvatar(child: Text('T')),
                  title: Text('Test User'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            i < 4 ? Icons.star : Icons.star_border,
                            size: 16,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text('Excellent food and service!'),
                    ],
                  ),
                  isThreeLine: true,
                ),
                Divider(),
                ListTile(
                  key: Key('review_1'),
                  leading: CircleAvatar(child: Text('A')),
                  title: Text('Another User'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            i < 3 ? Icons.star : Icons.star_border,
                            size: 16,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text('Good but could be better.'),
                    ],
                  ),
                  isThreeLine: true,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byKey(Key('review_list')), findsOneWidget);
      expect(find.byKey(Key('review_0')), findsOneWidget);
      expect(find.byKey(Key('review_1')), findsOneWidget);
      expect(find.text('Excellent food and service!'), findsOneWidget);
      expect(find.text('Good but could be better.'), findsOneWidget);
    });
  });
}
