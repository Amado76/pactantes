import 'package:flutter/foundation.dart';

import '../../../core/library/models/reading_document.dart';
import '../../../core/reading_progress/models/reading_progress.dart';
import '../../reader/models/reading_content.dart';

@immutable
class HomeReadingItem {
  const HomeReadingItem({
    required this.document,
    this.progress,
    this.unit,
    this.sourceTitle,
    this.languageCode,
  });

  final ReadingDocument document;
  final ReadingProgress? progress;
  final ReadingUnit? unit;
  final String? sourceTitle;
  final String? languageCode;
}
