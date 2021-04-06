class SameNameFileException implements Exception {
  String cause;
  SameNameFileException(this.cause);
}

class PlatformException implements Exception {
  String cause;
  PlatformException(this.cause);
}

class NoImageException implements Exception {
  String cause;
  NoImageException(this.cause);
}