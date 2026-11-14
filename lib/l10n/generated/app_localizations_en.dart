// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get brandSubtitle => 'Reformed Resources';

  @override
  String get introTitle => 'Growing in Grace and Truth';

  @override
  String get introDescription =>
      'Bibles, confessions, catechisms and historical texts of the Reformed faith.';

  @override
  String get bibleTitle => 'Holy Bible';

  @override
  String get bibleEdition => 'SBT Version';

  @override
  String get continueReading => 'Continue reading';

  @override
  String get exploreLibrary => 'Explore the library';

  @override
  String get seeAll => 'See all';

  @override
  String get confessions => 'Confessions of faith';

  @override
  String get catechisms => 'Catechisms';

  @override
  String get creeds => 'Historic creeds';

  @override
  String get documents => 'Reformed documents';

  @override
  String get home => 'Home';

  @override
  String get bible => 'Bible';

  @override
  String get library => 'Library';

  @override
  String get search => 'Search';

  @override
  String get community => 'Community';

  @override
  String get moreOptions => 'More options';

  @override
  String completed(int percent) {
    return '$percent% COMPLETED';
  }

  @override
  String paragraph(int number) {
    return 'Paragraph $number';
  }

  @override
  String readingPage(int current, int total) {
    return 'Reading $current of $total';
  }

  @override
  String get startReading => 'Start reading';

  @override
  String question(int number) {
    return 'Question $number';
  }

  @override
  String questionCount(int count) {
    return '$count questions';
  }

  @override
  String get documentBeginning => 'Beginning of the document';

  @override
  String get documentConfession => 'Confession of faith';

  @override
  String get documentCatechism => 'Catechism';

  @override
  String get documentCreed => 'Historic creed';

  @override
  String get documentHistorical => 'Reformed document';

  @override
  String get documentCollection => 'Collection';

  @override
  String get readingProgressError => 'Could not load reading progress.';

  @override
  String get retry => 'Try again';

  @override
  String get loadingReadingProgress => 'Loading reading progress';
}
