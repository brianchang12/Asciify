class SameNameFileException implements Exception {
  String _cause;
  SameNameFileException(this._cause);

  String getCause() {
    return _cause;
  }
}

class PlatformException implements Exception {
  String _cause;
  PlatformException(this._cause);

  String getCause() {
    return _cause;
  }
}

class NoImageException implements Exception {
  String _cause;
  NoImageException(this._cause);

  String getCause() {
    return _cause;
  }
}