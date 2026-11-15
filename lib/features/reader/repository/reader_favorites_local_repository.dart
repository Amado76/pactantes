import 'dart:convert';

import '../../../core/preferences/preferences_store.dart';

abstract interface class ReaderFavoritesLocalRepository {
  Future<bool> contains(String documentId, String unitId);
  Future<void> setFavorite(String documentId, String unitId, bool favorite);
}

class ReaderFavoritesLocalRepositoryImpl
    implements ReaderFavoritesLocalRepository {
  ReaderFavoritesLocalRepositoryImpl(this._store);
  final PreferencesStore _store;
  Future<void> _pending = Future<void>.value();
  static const String key = 'reader_favorites';
  Future<Set<String>> _read() async {
    final String? raw = await _store.readString(key);
    if (raw == null) return <String>{};
    final Object? decoded = jsonDecode(raw);
    if (decoded is! List<Object?> ||
        decoded.any((Object? value) => value is! String)) {
      throw const FormatException('Invalid favorites');
    }
    return decoded.cast<String>().toSet();
  }

  String _id(String documentId, String unitId) =>
      jsonEncode(<String>[documentId, unitId]);
  @override
  Future<bool> contains(String documentId, String unitId) async {
    await _pending;
    return (await _read()).contains(_id(documentId, unitId));
  }

  @override
  Future<void> setFavorite(String documentId, String unitId, bool favorite) {
    final Future<void> operation = _pending.then((_) async {
      final Set<String> values = await _read();
      if (favorite) {
        values.add(_id(documentId, unitId));
      } else {
        values.remove(_id(documentId, unitId));
      }
      await _store.writeString(key, jsonEncode(values.toList()));
    });
    _pending = operation.then(
      (_) {},
      onError: (Object error, StackTrace stack) {},
    );
    return operation;
  }
}
