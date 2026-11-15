import 'dart:ui';

abstract interface class ReadingActions {
  Future<void> share(String text, Rect origin);
  Future<void> copy(String text);
}

class ReadingActionException implements Exception {
  const ReadingActionException();
}
