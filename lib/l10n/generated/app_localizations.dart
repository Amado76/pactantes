import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('pt'),
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @brandSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reformed Resources'**
  String get brandSubtitle;

  /// No description provided for @introTitle.
  ///
  /// In en, this message translates to:
  /// **'Growing in Grace and Truth'**
  String get introTitle;

  /// No description provided for @introDescription.
  ///
  /// In en, this message translates to:
  /// **'Bibles, confessions, catechisms and historical texts of the Reformed faith.'**
  String get introDescription;

  /// No description provided for @bibleTitle.
  ///
  /// In en, this message translates to:
  /// **'Holy Bible'**
  String get bibleTitle;

  /// No description provided for @bibleEdition.
  ///
  /// In en, this message translates to:
  /// **'SBT Version'**
  String get bibleEdition;

  /// No description provided for @continueReading.
  ///
  /// In en, this message translates to:
  /// **'Continue reading'**
  String get continueReading;

  /// No description provided for @exploreLibrary.
  ///
  /// In en, this message translates to:
  /// **'Explore the library'**
  String get exploreLibrary;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @confessions.
  ///
  /// In en, this message translates to:
  /// **'Confessions of faith'**
  String get confessions;

  /// No description provided for @catechisms.
  ///
  /// In en, this message translates to:
  /// **'Catechisms'**
  String get catechisms;

  /// No description provided for @creeds.
  ///
  /// In en, this message translates to:
  /// **'Historic creeds'**
  String get creeds;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Reformed documents'**
  String get documents;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @bible.
  ///
  /// In en, this message translates to:
  /// **'Bible'**
  String get bible;

  /// No description provided for @library.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @community.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get community;

  /// No description provided for @moreOptions.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get moreOptions;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'{percent}% COMPLETED'**
  String completed(int percent);

  /// No description provided for @paragraph.
  ///
  /// In en, this message translates to:
  /// **'Paragraph {number}'**
  String paragraph(int number);

  /// No description provided for @readingPage.
  ///
  /// In en, this message translates to:
  /// **'Reading {current} of {total}'**
  String readingPage(int current, int total);

  /// No description provided for @startReading.
  ///
  /// In en, this message translates to:
  /// **'Start reading'**
  String get startReading;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'Question {number}'**
  String question(int number);

  /// No description provided for @questionCount.
  ///
  /// In en, this message translates to:
  /// **'{count} questions'**
  String questionCount(int count);

  /// No description provided for @documentBeginning.
  ///
  /// In en, this message translates to:
  /// **'Beginning of the document'**
  String get documentBeginning;

  /// No description provided for @documentConfession.
  ///
  /// In en, this message translates to:
  /// **'Confession of faith'**
  String get documentConfession;

  /// No description provided for @documentCatechism.
  ///
  /// In en, this message translates to:
  /// **'Catechism'**
  String get documentCatechism;

  /// No description provided for @documentCreed.
  ///
  /// In en, this message translates to:
  /// **'Historic creed'**
  String get documentCreed;

  /// No description provided for @documentHistorical.
  ///
  /// In en, this message translates to:
  /// **'Reformed document'**
  String get documentHistorical;

  /// No description provided for @documentCollection.
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get documentCollection;

  /// No description provided for @readingProgressError.
  ///
  /// In en, this message translates to:
  /// **'Could not load reading progress.'**
  String get readingProgressError;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @loadingReadingProgress.
  ///
  /// In en, this message translates to:
  /// **'Loading reading progress'**
  String get loadingReadingProgress;

  /// No description provided for @readerSettings.
  ///
  /// In en, this message translates to:
  /// **'Reading settings'**
  String get readerSettings;

  /// No description provided for @readerTextSize.
  ///
  /// In en, this message translates to:
  /// **'Text size'**
  String get readerTextSize;

  /// No description provided for @readerLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get readerLight;

  /// No description provided for @readerPaper.
  ///
  /// In en, this message translates to:
  /// **'Paper'**
  String get readerPaper;

  /// No description provided for @readerDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get readerDark;

  /// No description provided for @readerSpacing.
  ///
  /// In en, this message translates to:
  /// **'Spacing'**
  String get readerSpacing;

  /// No description provided for @readerCompact.
  ///
  /// In en, this message translates to:
  /// **'Compact'**
  String get readerCompact;

  /// No description provided for @readerNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get readerNormal;

  /// No description provided for @readerWide.
  ///
  /// In en, this message translates to:
  /// **'Wide'**
  String get readerWide;

  /// No description provided for @readerAddFavorite.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get readerAddFavorite;

  /// No description provided for @readerRemoveFavorite.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get readerRemoveFavorite;

  /// No description provided for @readerCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy text'**
  String get readerCopy;

  /// No description provided for @readerCopied.
  ///
  /// In en, this message translates to:
  /// **'Text copied'**
  String get readerCopied;

  /// No description provided for @readerShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get readerShare;

  /// No description provided for @readerClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get readerClose;

  /// No description provided for @readerPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous unit'**
  String get readerPrevious;

  /// No description provided for @readerNext.
  ///
  /// In en, this message translates to:
  /// **'Next unit'**
  String get readerNext;

  /// No description provided for @readerReferences.
  ///
  /// In en, this message translates to:
  /// **'Biblical references:'**
  String get readerReferences;

  /// No description provided for @readerQuestionPrefix.
  ///
  /// In en, this message translates to:
  /// **'Q.'**
  String get readerQuestionPrefix;

  /// No description provided for @readerAnswerPrefix.
  ///
  /// In en, this message translates to:
  /// **'A.'**
  String get readerAnswerPrefix;

  /// No description provided for @readerAttribution.
  ///
  /// In en, this message translates to:
  /// **'Shared from Pactantes — Reformed Resources.'**
  String get readerAttribution;

  /// No description provided for @readerLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not open this document.'**
  String get readerLoadError;

  /// No description provided for @readerSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save your changes. Please try again.'**
  String get readerSaveError;

  /// No description provided for @readerActionError.
  ///
  /// In en, this message translates to:
  /// **'Could not complete this action. Please try again.'**
  String get readerActionError;

  /// No description provided for @readerDecreaseSize.
  ///
  /// In en, this message translates to:
  /// **'Decrease text size'**
  String get readerDecreaseSize;

  /// No description provided for @readerIncreaseSize.
  ///
  /// In en, this message translates to:
  /// **'Increase text size'**
  String get readerIncreaseSize;

  /// No description provided for @readerNavigation.
  ///
  /// In en, this message translates to:
  /// **'Document navigation'**
  String get readerNavigation;

  /// No description provided for @readerTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get readerTheme;

  /// No description provided for @readerTranslation.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get readerTranslation;

  /// No description provided for @readerDeviceLanguage.
  ///
  /// In en, this message translates to:
  /// **'Device language'**
  String get readerDeviceLanguage;

  /// No description provided for @readerEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get readerEnglish;

  /// No description provided for @readerPortuguese.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get readerPortuguese;

  /// No description provided for @readerSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get readerSpanish;

  /// No description provided for @homeResumeStudy.
  ///
  /// In en, this message translates to:
  /// **'Resume study'**
  String get homeResumeStudy;

  /// No description provided for @homeBeginStudy.
  ///
  /// In en, this message translates to:
  /// **'Begin study'**
  String get homeBeginStudy;

  /// No description provided for @homeConfessionsSummary.
  ///
  /// In en, this message translates to:
  /// **'Confessional texts'**
  String get homeConfessionsSummary;

  /// No description provided for @homeCatechismsSummary.
  ///
  /// In en, this message translates to:
  /// **'Questions and answers'**
  String get homeCatechismsSummary;

  /// No description provided for @homeCreedsSummary.
  ///
  /// In en, this message translates to:
  /// **'Statements of faith'**
  String get homeCreedsSummary;

  /// No description provided for @homeDocumentsSummary.
  ///
  /// In en, this message translates to:
  /// **'Historical texts'**
  String get homeDocumentsSummary;

  /// No description provided for @homeScriptureQuote.
  ///
  /// In en, this message translates to:
  /// **'“For by grace are ye saved through faith; and that not of yourselves: it is the gift of God:”'**
  String get homeScriptureQuote;

  /// No description provided for @homeScriptureReference.
  ///
  /// In en, this message translates to:
  /// **'EPHESIANS 2:8'**
  String get homeScriptureReference;

  /// Bible book display name for a stable corpus book code; unknown codes remain unchanged.
  ///
  /// In en, this message translates to:
  /// **'{book, select, book1Chr{1 Chronicles} book1Cor{1 Corinthians} book1John{1 John} book1Kgs{1 Kings} book1Pet{1 Peter} book1Sam{1 Samuel} book1Thess{1 Thessalonians} book1Tim{1 Timothy} book2Chr{2 Chronicles} book2Cor{2 Corinthians} book2Kgs{2 Kings} book2Pet{2 Peter} book2Sam{2 Samuel} book2Thess{2 Thessalonians} book2Tim{2 Timothy} bookActs{Acts} bookCol{Colossians} bookDan{Daniel} bookDeut{Deuteronomy} bookEccl{Ecclesiastes} bookEph{Ephesians} bookExod{Exodus} bookEzek{Ezekiel} bookGal{Galatians} bookGen{Genesis} bookHab{Habakkuk} bookHeb{Hebrews} bookIsa{Isaiah} bookJas{James} bookJer{Jeremiah} bookJob{Job} bookJoel{Joel} bookJohn{John} bookJosh{Joshua} bookJude{Jude} bookLev{Leviticus} bookLuke{Luke} bookMark{Mark} bookMatt{Matthew} bookMic{Micah} bookNah{Nahum} bookNum{Numbers} bookPhil{Philippians} bookProv{Proverbs} bookPs{Psalms} bookRev{Revelation} bookRom{Romans} bookTitus{Titus} bookZech{Zechariah} other{{code}}}'**
  String bibleBookName(String book, String code);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
