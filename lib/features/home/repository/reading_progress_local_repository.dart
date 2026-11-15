import '../../../core/preferences/preferences_reader.dart';
import '../../../core/reading_progress/models/reading_progress_codec.dart';
import '../../../core/reading_progress/models/reading_progress.dart';

abstract interface class ReadingProgressLocalRepository {
  Future<List<ReadingProgress>> read();
}

class ReadingProgressLocalRepositoryImpl
    implements ReadingProgressLocalRepository {
  const ReadingProgressLocalRepositoryImpl(this._preferences);

  static const String storageKey = ReadingProgressCodec.storageKey;
  final PreferencesReader _preferences;

  @override
  Future<List<ReadingProgress>> read() async {
    return ReadingProgressCodec.decode(
      await _preferences.readString(storageKey),
    );
  }
}
