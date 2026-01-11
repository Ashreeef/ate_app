// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// This file contains basic widget tests that don't require Firebase.

void main() {
  testWidgets('Basic widget rendering test', (WidgetTester tester) async {
    // Build a simple widget to verify test framework works
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('ATE App')),
          body: Center(child: Text('Welcome to ATE')),
        ),
      ),
    );

    // Verify the widget renders correctly
    expect(find.text('ATE App'), findsOneWidget);
    expect(find.text('Welcome to ATE'), findsOneWidget);
  });

  testWidgets('Button tap test', (WidgetTester tester) async {
    int counter = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              body: Center(child: Text('Counter: $counter')),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    counter++;
                  });
                },
                child: Icon(Icons.add),
              ),
            );
          },
        ),
      ),
    );

    expect(find.text('Counter: 0'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('Counter: 1'), findsOneWidget);
  });
}
