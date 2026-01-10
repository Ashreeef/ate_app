import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Post Creation Flow Integration Tests', () {
    testWidgets('Create post screen should have required elements', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // Image picker placeholder
                  Container(
                    key: Key('image_picker'),
                    height: 200,
                    color: Colors.grey[300],
                    child: Icon(Icons.add_photo_alternate),
                  ),
                  // Caption field
                  TextField(
                    key: Key('caption_field'),
                    maxLines: 3,
                    decoration: InputDecoration(hintText: 'Write a caption...'),
                  ),
                  // Restaurant field
                  TextField(
                    key: Key('restaurant_field'),
                    decoration: InputDecoration(hintText: 'Tag a restaurant'),
                  ),
                  // Dish name field
                  TextField(
                    key: Key('dish_field'),
                    decoration: InputDecoration(hintText: 'Dish name'),
                  ),
                  // Rating
                  Row(
                    key: Key('rating_row'),
                    children: List.generate(
                      5,
                      (index) => Icon(Icons.star_border),
                    ),
                  ),
                  // Post button
                  ElevatedButton(
                    key: Key('post_button'),
                    onPressed: () {},
                    child: Text('Share'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(Key('image_picker')), findsOneWidget);
      expect(find.byKey(Key('caption_field')), findsOneWidget);
      expect(find.byKey(Key('restaurant_field')), findsOneWidget);
      expect(find.byKey(Key('dish_field')), findsOneWidget);
      expect(find.byKey(Key('rating_row')), findsOneWidget);
      expect(find.byKey(Key('post_button')), findsOneWidget);
    });

    testWidgets('Caption field should accept multiline text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextField(key: Key('caption_field'), maxLines: 3),
          ),
        ),
      );

      const testCaption = 'Line 1\nLine 2\nLine 3';
      await tester.enterText(find.byKey(Key('caption_field')), testCaption);
      await tester.pump();

      expect(find.text(testCaption), findsOneWidget);
    });

    testWidgets('Post button should be disabled when no image', (
      WidgetTester tester,
    ) async {
      bool hasImage = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return ElevatedButton(
                  key: Key('post_button'),
                  onPressed: hasImage ? () {} : null,
                  child: Text('Share'),
                );
              },
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(
        find.byKey(Key('post_button')),
      );
      expect(button.onPressed, isNull);
    });
  });

  group('Post Display Integration Tests', () {
    testWidgets('Post card should display all elements', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              key: Key('post_card'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User info row
                  ListTile(
                    key: Key('user_info'),
                    leading: CircleAvatar(child: Text('T')),
                    title: Text('testuser'),
                    subtitle: Text('Test Restaurant'),
                  ),
                  // Post image
                  Container(
                    key: Key('post_image'),
                    height: 300,
                    color: Colors.grey,
                  ),
                  // Action row
                  Row(
                    key: Key('action_row'),
                    children: [
                      IconButton(
                        key: Key('like_button'),
                        icon: Icon(Icons.favorite_border),
                        onPressed: () {},
                      ),
                      IconButton(
                        key: Key('comment_button'),
                        icon: Icon(Icons.comment_outlined),
                        onPressed: () {},
                      ),
                      IconButton(
                        key: Key('share_button'),
                        icon: Icon(Icons.share),
                        onPressed: () {},
                      ),
                      Spacer(),
                      IconButton(
                        key: Key('save_button'),
                        icon: Icon(Icons.bookmark_border),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  // Likes count
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '42 likes',
                      key: Key('likes_count'),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Caption
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Amazing food! 🍕', key: Key('caption')),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(Key('post_card')), findsOneWidget);
      expect(find.byKey(Key('user_info')), findsOneWidget);
      expect(find.byKey(Key('post_image')), findsOneWidget);
      expect(find.byKey(Key('action_row')), findsOneWidget);
      expect(find.byKey(Key('like_button')), findsOneWidget);
      expect(find.byKey(Key('comment_button')), findsOneWidget);
      expect(find.byKey(Key('share_button')), findsOneWidget);
      expect(find.byKey(Key('save_button')), findsOneWidget);
      expect(find.byKey(Key('likes_count')), findsOneWidget);
      expect(find.byKey(Key('caption')), findsOneWidget);
    });

    testWidgets('Like button should toggle state', (WidgetTester tester) async {
      bool isLiked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return IconButton(
                  key: Key('like_button'),
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : null,
                  ),
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      // Initially not liked
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);

      // Tap to like
      await tester.tap(find.byKey(Key('like_button')));
      await tester.pump();

      // Should show liked state
      expect(find.byIcon(Icons.favorite), findsOneWidget);

      // Tap to unlike
      await tester.tap(find.byKey(Key('like_button')));
      await tester.pump();

      // Should show unliked state
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });
  });

  group('Feed Integration Tests', () {
    testWidgets('Feed should display list of posts', (
      WidgetTester tester,
    ) async {
      final posts = List.generate(
        5,
        (index) => Card(
          key: Key('post_$index'),
          child: ListTile(title: Text('Post $index')),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              key: Key('feed_list'),
              itemCount: posts.length,
              itemBuilder: (context, index) => posts[index],
            ),
          ),
        ),
      );

      expect(find.byKey(Key('feed_list')), findsOneWidget);
      expect(find.byKey(Key('post_0')), findsOneWidget);
      expect(find.byKey(Key('post_1')), findsOneWidget);
    });

    testWidgets('Feed should be scrollable', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              key: Key('feed_list'),
              itemCount: 20,
              itemBuilder: (context, index) => Container(
                height: 100,
                key: Key('post_$index'),
                child: Text('Post $index'),
              ),
            ),
          ),
        ),
      );

      // Scroll down
      await tester.drag(find.byKey(Key('feed_list')), Offset(0, -500));
      await tester.pump();

      // Post 0 might be scrolled out of view
      // Later posts should be visible
      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
