import 'package:flutter/widgets.dart';

import '../core/bible/bible_book_names.dart';
import 'generated/app_localizations.dart';

class LocalizedBibleBookNames implements BibleBookNames {
  const LocalizedBibleBookNames();

  @override
  String name(String bookCode, {required String languageCode}) =>
      lookupAppLocalizations(Locale(languageCode))
          .bibleBookName('book$bookCode', bookCode);
}
