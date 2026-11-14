import 'package:shared_preferences/shared_preferences.dart';

import 'preferences_reader.dart';

class SharedPreferencesReader implements PreferencesReader {
  const SharedPreferencesReader(this._preferences);

  final Future<SharedPreferences> Function() _preferences;

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
