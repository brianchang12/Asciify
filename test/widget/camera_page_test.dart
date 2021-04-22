
import 'package:asciify/exception/custom_exception.dart';
import 'package:asciify/screens/camera_page.dart';
import 'package:fake_async/fake_async.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Test Camera Page Widgets', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: CameraPage(),));
    var buttonFinder = find.byType(ElevatedButton);
    var emptyImageFinder = find.byKey(Key('emptyImageDisplay'));
    expect(buttonFinder, findsNWidgets(6));
    expect(emptyImageFinder, findsOneWidget);
  });

  testWidgets("No Image Exception Test", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: CameraPage(),));
    fakeAsync((async) {
      var convertButtonFinder = find.byKey(Key('cameraButton'));
      var cropButtonFinder = find.byKey(Key('cropButton'));
      try {
        tester.tap(cropButtonFinder);
        async.elapse(new Duration(seconds: 100));
      } on NoImageException catch(e) {
        expect(e, isInstanceOf<NoImageException>());
      }
      try {
        tester.tap(convertButtonFinder);
        async.elapse(new Duration(seconds: 100));
      } on NoImageException {
        expect(tester.takeException(), isInstanceOf<NoImageException>());
      }
    });
  });
}