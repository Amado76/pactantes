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
