import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import 'reading_actions.dart';

class PlatformReadingActions implements ReadingActions {
  const PlatformReadingActions(this._share);
  final SharePlus _share;
  @override
  Future<void> share(String text, Rect origin) async {
    try {
      await _share.share(ShareParams(text: text, sharePositionOrigin: origin));
    } on Exception {
      throw const ReadingActionException();
    }
  }

  @override
  Future<void> copy(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
    } on Exception {
      throw const ReadingActionException();
    }
  }
}
