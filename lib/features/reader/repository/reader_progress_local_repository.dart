import '../../../core/preferences/preferences_store.dart';
import '../../../core/reading_progress/models/reading_progress.dart';
import '../../../core/reading_progress/models/reading_progress_codec.dart';

abstract interface class ReaderProgressLocalRepository {
  Future<String?> readUnit(String documentId);
  Future<void> save({
    required String documentId,
    required String unitId,
    required String title,
    required double progress,
  });
}

class ReaderProgressLocalRepositoryImpl
    implements ReaderProgressLocalRepository {
  const ReaderProgressLocalRepositoryImpl(this._store);
  final PreferencesStore _store;
  Future<List<ReadingProgress>> _records() async => ReadingProgressCodec.decode(
    await _store.readString(ReadingProgressCodec.storageKey),
  );

  @override
  Future<String?> readUnit(String documentId) async {
    for (final ReadingProgress record in await _records()) {
      if (record.documentId == documentId) return record.sectionId;
    }
    return null;
  }

  @override
  Future<void> save({
    required String documentId,
    required String unitId,
    required String title,
    required double progress,
  }) async {
    final List<ReadingProgress> records = await _records();
    records.removeWhere(
      (ReadingProgress record) => record.documentId == documentId,
    );
    records.insert(
      0,
      ReadingProgress(
        documentId: documentId,
        sectionId: unitId,
        sectionTitle: title,
        paragraph: 1,
        progress: progress,
        lastReadAt: DateTime.now().toUtc(),
      ),
    );
    await _store.writeString(
      ReadingProgressCodec.storageKey,
      ReadingProgressCodec.encode(records),
    );
  }
}
