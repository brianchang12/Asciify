import 'dart:io';
import 'package:asciify/class/ascii_converter.dart';
import 'package:image/image.dart' as img;
import 'package:test/test.dart';

void main() {
  group('Test for ascii conversion', () {
    test('Test white image', () async {
      File file = File('test_assets/white.png');
      img.Image image = img.decodePng(await file.readAsBytes())!;
      AsciiConverter? asciiConverter = AsciiConverter.getInstance();
      StringBuffer buffer = asciiConverter!.asciiConvert(image);
      expect(buffer, isA<StringBuffer>());
      String str = buffer.toString();
      List<String> strings = str.split('\n');
      for (String line in strings) {
        for (int i = 0; i < line.length; i++) {
          expect(str[0], equals(' '));
        }
      }
    });
    test('Test black image', () async {
      File file = File('test_assets/black.png');
      img.Image image = img.decodePng(await file.readAsBytes())!;
      AsciiConverter? asciiConverter = AsciiConverter.getInstance();
      StringBuffer buffer = asciiConverter!.asciiConvert(image);
      expect(buffer, isA<StringBuffer>());
      String str = buffer.toString();
      List<String> strings = str.split('\n');
      for (String line in strings) {
        for (int i = 0; i < line.length; i++) {
          expect(str[0], equals('@'));
        }
      }
    });
    test('Test gray image', () async {
      File file = File('test_assets/gray.png');
      img.Image image = img.decodePng(await file.readAsBytes())!;
      AsciiConverter? asciiConverter = AsciiConverter.getInstance();
      StringBuffer buffer = asciiConverter!.asciiConvert(image);
      expect(buffer, isA<StringBuffer>());
      String str = buffer.toString();
      List<String> strings = str.split('\n');
      for (String line in strings) {
        for (int i = 0; i < line.length; i++) {
          expect(str[0], equals('='));
        }
      }
    });
  });

}