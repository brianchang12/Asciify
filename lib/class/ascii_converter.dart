
import 'package:image/image.dart' as img;

class AsciiConverter {
  static AsciiConverter? _asciiConverterObj;

  AsciiConverter._();

  static AsciiConverter? getInstance() {
    if (_asciiConverterObj == null) {
      _asciiConverterObj = new AsciiConverter._();
    }
    return _asciiConverterObj;
  }

  StringBuffer asciiConvert(img.Image imageExtract) {
    String chars = " .:-=+*#%@";
    List<String> charList = chars.split("");
    charList = charList.reversed.toList();
    int charLength = charList.length;
    double interval = charLength / 256;
    var buffer = StringBuffer('');
    for (int y = 0; y < imageExtract.height; y++) {
      for (int x = 0; x < imageExtract.width; x++) {
        int testPixel = imageExtract.getPixel(x, y);
        int blue = ((testPixel & 0x00FF0000) >> 16);
        int green = ((testPixel & 0x0000FF00) >> 8);
        int red = testPixel & 0x000000FF;
        int grayValue = ((red / 3) + (green / 3) + (blue / 3)).round();
        buffer.write(
            charList[(grayValue * interval).floor()]);
      }
      buffer.write('\n');
    }
    return buffer;

  }

}