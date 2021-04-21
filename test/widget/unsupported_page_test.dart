import 'package:asciify/screens/unsupported_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Test Unsupported Page Widgets', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: UnsupportedPage(),));
        expect(find.byKey(Key('unsupportedCaption')), findsOneWidget);
  });
}