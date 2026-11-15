import 'package:shared_preferences/shared_preferences.dart';

import 'preferences_reader.dart';
import 'preferences_store.dart';

class SharedPreferencesReader implements PreferencesStore {
  const SharedPreferencesReader(this._preferences);

  final Future<SharedPreferences> Function() _preferences;

  @override
  Future<void> writeString(String key, String value) async {
    try {
      if (!await (await _preferences()).setString(key, value)) {
        throw const PreferencesWriteException();
      }
    } on Exception {
      throw const PreferencesWriteException();
    }
  }

  @override
  Future<String?> readString(String key) async {
    try {
      return (await _preferences()).getString(key);
    } on TypeError {
      return null;
    } on Exception {
      throw const PreferencesReadException();
    }
  }
}
