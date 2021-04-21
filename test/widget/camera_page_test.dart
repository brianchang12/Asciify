
import 'package:asciify/exception/custom_exception.dart';
import 'package:asciify/screens/camera_page.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Test Camera Page Widgets', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: CameraPage(),));
    var buttonFinder = find.byType(ElevatedButton);
    var floatingButtonFinder = find.byType(FloatingActionButton);
    var emptyImageFinder = find.byKey(Key('emptyImageDisplay'));
    expect(buttonFinder, findsNWidgets(3));
    expect(floatingButtonFinder, findsOneWidget);
    expect(emptyImageFinder, findsOneWidget);
  });

  testWidgets("No Image Exception Test", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: CameraPage(),));
    var cropButtonFinder = find.byKey(Key('cropButton'));
    try {
      await tester.tap(cropButtonFinder);
    } on NoImageException {
      expect(tester.takeException(), isInstanceOf<NoImageException>());
    }
    var convertButtonFinder = find.byKey(Key('convertButton'));
    try {
      await tester.tap(convertButtonFinder);
    } on NoImageException {
      expect(tester.takeException(), isInstanceOf<NoImageException>());
    }

  });
}