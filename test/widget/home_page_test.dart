import 'package:asciify/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("Test Home Page Widgets", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomePage()));
    var titleFinder = find.byKey(Key('title'));
    var captionFinder = find.byKey(Key('caption'));
    var cameraFinder = find.byKey(Key('cameraImage'));
    expect(titleFinder, findsOneWidget);
    expect(captionFinder, findsOneWidget);
    expect(cameraFinder, findsOneWidget);
  });

}