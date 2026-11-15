import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import 'reading_database.dart';

class SqfliteReadingDatabase implements ReadingDatabase {
  SqfliteReadingDatabase(this._factory, this._assets);
  final DatabaseFactory _factory;
  final AssetBundle _assets;
  Future<Database>? _database;

  Future<Database> _open() async {
    // Versioned corpus files never overwrite user preferences or a previous corpus.
    final String directory = await _factory.getDatabasesPath();
    await Directory(directory).create(recursive: true);
    final String destination = path.join(directory, 'reformed_documents_v3.db');
    if (!await File(destination).exists()) {
      final ByteData bytes = await _assets.load(
        'assets/db/reformed_documents.db',
      );
      final File temporary = File('$destination.installing');
      await temporary.writeAsBytes(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
        flush: true,
      );
      final Database candidate = await _factory.openDatabase(
        temporary.path,
        options: OpenDatabaseOptions(readOnly: true, singleInstance: false),
      );
      try {
        final List<Map<String, Object?>> result = await candidate.rawQuery(
          'PRAGMA quick_check',
        );
        if (result.single.values.single != 'ok') {
          throw const ReadingDatabaseException();
        }
        await candidate.rawQuery(
          'SELECT canonical_question_number FROM heidelberg_questions LIMIT 1',
        );
      } finally {
        await candidate.close();
      }
      await temporary.rename(destination);
    }
    return _factory.openDatabase(
      destination,
      options: OpenDatabaseOptions(readOnly: true),
    );
  }

  @override
  Future<List<Map<String, Object?>>> query(
    String sql, [
    List<Object?> arguments = const <Object?>[],
  ]) async {
    try {
      final Database database = await (_database ??= _open());
      return await database.rawQuery(sql, arguments);
    } on Exception {
      _database = null;
      throw const ReadingDatabaseException();
    }
  }
}
