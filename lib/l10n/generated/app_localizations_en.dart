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

  @override
  String get readerSettings => 'Reading settings';

  @override
  String get readerTextSize => 'Text size';

  @override
  String get readerLight => 'Light';

  @override
  String get readerPaper => 'Paper';

  @override
  String get readerDark => 'Dark';

  @override
  String get readerSpacing => 'Spacing';

  @override
  String get readerCompact => 'Compact';

  @override
  String get readerNormal => 'Normal';

  @override
  String get readerWide => 'Wide';

  @override
  String get readerAddFavorite => 'Add to favorites';

  @override
  String get readerRemoveFavorite => 'Remove from favorites';

  @override
  String get readerCopy => 'Copy text';

  @override
  String get readerCopied => 'Text copied';

  @override
  String get readerShare => 'Share';

  @override
  String get readerClose => 'Close';

  @override
  String get readerPrevious => 'Previous unit';

  @override
  String get readerNext => 'Next unit';

  @override
  String get readerReferences => 'Biblical references:';

  @override
  String get readerQuestionPrefix => 'Q.';

  @override
  String get readerAnswerPrefix => 'A.';

  @override
  String get readerAttribution => 'Shared from Pactantes — Reformed Resources.';

  @override
  String get readerLoadError => 'Could not open this document.';

  @override
  String get readerSaveError =>
      'Could not save your changes. Please try again.';

  @override
  String get readerActionError =>
      'Could not complete this action. Please try again.';

  @override
  String get readerDecreaseSize => 'Decrease text size';

  @override
  String get readerIncreaseSize => 'Increase text size';

  @override
  String get readerNavigation => 'Document navigation';

  @override
  String get readerTheme => 'Theme';

  @override
  String get readerTranslation => 'Translation';

  @override
  String get readerDeviceLanguage => 'Device language';

  @override
  String get readerEnglish => 'English';

  @override
  String get readerPortuguese => 'Portuguese';

  @override
  String get readerSpanish => 'Spanish';

  @override
  String get homeResumeStudy => 'Resume study';

  @override
  String get homeBeginStudy => 'Begin study';

  @override
  String get homeConfessionsSummary => 'Confessional texts';

  @override
  String get homeCatechismsSummary => 'Questions and answers';

  @override
  String get homeCreedsSummary => 'Statements of faith';

  @override
  String get homeDocumentsSummary => 'Historical texts';

  @override
  String get homeScriptureQuote =>
      '“For by grace are ye saved through faith; and that not of yourselves: it is the gift of God:”';

  @override
  String get homeScriptureReference => 'EPHESIANS 2:8';

  @override
  String bibleBookName(String book, String code) {
    String _temp0 = intl.Intl.selectLogic(book, {
      'book1Chr': '1 Chronicles',
      'book1Cor': '1 Corinthians',
      'book1John': '1 John',
      'book1Kgs': '1 Kings',
      'book1Pet': '1 Peter',
      'book1Sam': '1 Samuel',
      'book1Thess': '1 Thessalonians',
      'book1Tim': '1 Timothy',
      'book2Chr': '2 Chronicles',
      'book2Cor': '2 Corinthians',
      'book2Kgs': '2 Kings',
      'book2Pet': '2 Peter',
      'book2Sam': '2 Samuel',
      'book2Thess': '2 Thessalonians',
      'book2Tim': '2 Timothy',
      'bookActs': 'Acts',
      'bookCol': 'Colossians',
      'bookDan': 'Daniel',
      'bookDeut': 'Deuteronomy',
      'bookEccl': 'Ecclesiastes',
      'bookEph': 'Ephesians',
      'bookExod': 'Exodus',
      'bookEzek': 'Ezekiel',
      'bookGal': 'Galatians',
      'bookGen': 'Genesis',
      'bookHab': 'Habakkuk',
      'bookHeb': 'Hebrews',
      'bookIsa': 'Isaiah',
      'bookJas': 'James',
      'bookJer': 'Jeremiah',
      'bookJob': 'Job',
      'bookJoel': 'Joel',
      'bookJohn': 'John',
      'bookJosh': 'Joshua',
      'bookJude': 'Jude',
      'bookLev': 'Leviticus',
      'bookLuke': 'Luke',
      'bookMark': 'Mark',
      'bookMatt': 'Matthew',
      'bookMic': 'Micah',
      'bookNah': 'Nahum',
      'bookNum': 'Numbers',
      'bookPhil': 'Philippians',
      'bookProv': 'Proverbs',
      'bookPs': 'Psalms',
      'bookRev': 'Revelation',
      'bookRom': 'Romans',
      'bookTitus': 'Titus',
      'bookZech': 'Zechariah',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get language => 'Language';
}
