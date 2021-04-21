
import 'package:asciify/screens/email_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Test Email Page Widget', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: EmailPage(),
    ));
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.byKey(Key('addFile')), findsOneWidget);
  });
}