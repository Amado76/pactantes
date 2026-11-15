import 'package:flutter/foundation.dart';

import '../../../core/library/models/reading_document.dart';
import '../../../core/reading_progress/models/reading_progress.dart';

@immutable
class HomeReadingItem {
  const HomeReadingItem({required this.document, this.progress});

  final ReadingDocument document;
  final ReadingProgress? progress;
}
