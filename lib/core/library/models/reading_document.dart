import 'package:flutter/foundation.dart';

enum DocumentType { confession, catechism, creed, document, collection }

@immutable
class ReadingDocument {
  const ReadingDocument({
    required this.id,
    required this.title,
    required this.type,
    required this.isAvailable,
    this.collectionId,
    this.totalUnits,
  }) : assert(totalUnits == null || totalUnits > 0);

  final String id;

  /// The title of the registered Spanish resource, independent of the UI locale.
  final String title;
  final DocumentType type;
  final String? collectionId;
  final int? totalUnits;
  final bool isAvailable;
}
