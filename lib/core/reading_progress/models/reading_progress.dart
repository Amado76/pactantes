import 'package:flutter/foundation.dart';

@immutable
class ReadingProgress {
  const ReadingProgress({
    required this.documentId,
    required this.sectionId,
    this.sectionTitle = '',
    required this.paragraph,
    required this.progress,
    required this.lastReadAt,
  });

  final String documentId;
  final String sectionId;
  final String sectionTitle;
  final int paragraph;

  /// Persisted as a fraction: 0.68 means 68 percent.
  final double progress;
  final DateTime lastReadAt;

  bool get isValid =>
      documentId.trim().isNotEmpty &&
      sectionId.trim().isNotEmpty &&
      paragraph > 0 &&
      progress.isFinite;

  double get fraction => progress.isFinite ? progress.clamp(0.0, 1.0) : 0;
  int get percentage => (fraction * 100).round();

  Map<String, Object> toJson() => <String, Object>{
    'documentId': documentId,
    'sectionId': sectionId,
    'sectionTitle': sectionTitle,
    'paragraph': paragraph,
    'progress': progress,
    'lastReadAt': lastReadAt.toUtc().toIso8601String(),
  };

  static ReadingProgress? fromJson(Object? value) {
    if (value is! Map<String, Object?>) return null;
    final Object? documentId = value['documentId'];
    final Object? sectionId = value['sectionId'];
    final Object sectionTitle = value['sectionTitle'] ?? '';
    final Object? paragraph = value['paragraph'];
    final Object? progress = value['progress'];
    final Object? timestamp = value['lastReadAt'];
    if (documentId is! String ||
        sectionId is! String ||
        sectionTitle is! String ||
        paragraph is! int ||
        progress is! num ||
        timestamp is! String) {
      return null;
    }
    final DateTime? lastReadAt = DateTime.tryParse(timestamp);
    if (lastReadAt == null) return null;
    final ReadingProgress item = ReadingProgress(
      documentId: documentId.trim(),
      sectionId: sectionId.trim(),
      sectionTitle: sectionTitle.trim(),
      paragraph: paragraph,
      progress: progress.toDouble(),
      lastReadAt: lastReadAt,
    );
    return item.isValid ? item : null;
  }
}
