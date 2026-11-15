// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get brandSubtitle => 'Recursos Reformados';

  @override
  String get introTitle => 'Creciendo en Gracia y Verdad';

  @override
  String get introDescription =>
      'Biblias, confesiones, catecismos y textos históricos de la fe reformada.';

  @override
  String get bibleTitle => 'Biblia Santa';

  @override
  String get bibleEdition => 'Versión SBT';

  @override
  String get continueReading => 'Continuar leyendo';

  @override
  String get exploreLibrary => 'Explorar la biblioteca';

  @override
  String get seeAll => 'Ver todo';

  @override
  String get confessions => 'Confesiones de fe';

  @override
  String get catechisms => 'Catecismos';

  @override
  String get creeds => 'Credos históricos';

  @override
  String get documents => 'Documentos reformados';

  @override
  String get home => 'Inicio';

  @override
  String get bible => 'Biblia';

  @override
  String get library => 'Biblioteca';

  @override
  String get search => 'Buscar';

  @override
  String get community => 'Comunidad';

  @override
  String get moreOptions => 'Más opciones';

  @override
  String completed(int percent) {
    return '$percent% COMPLETADO';
  }

  @override
  String paragraph(int number) {
    return 'Párrafo $number';
  }

  @override
  String readingPage(int current, int total) {
    return 'Lectura $current de $total';
  }

  @override
  String get startReading => 'Comenzar a leer';

  @override
  String question(int number) {
    return 'Pregunta $number';
  }

  @override
  String questionCount(int count) {
    return '$count preguntas';
  }

  @override
  String get documentBeginning => 'Inicio del documento';

  @override
  String get documentConfession => 'Confesión de fe';

  @override
  String get documentCatechism => 'Catecismo';

  @override
  String get documentCreed => 'Credo histórico';

  @override
  String get documentHistorical => 'Documento reformado';

  @override
  String get documentCollection => 'Colección';

  @override
  String get readingProgressError =>
      'No se pudo cargar el progreso de lectura.';

  @override
  String get retry => 'Reintentar';

  @override
  String get loadingReadingProgress => 'Cargando el progreso de lectura';

  @override
  String get readerSettings => 'Ajustes de lectura';

  @override
  String get readerTextSize => 'Tamaño del texto';

  @override
  String get readerLight => 'Claro';

  @override
  String get readerPaper => 'Papel';

  @override
  String get readerDark => 'Oscuro';

  @override
  String get readerSpacing => 'Espaciado';

  @override
  String get readerCompact => 'Compacto';

  @override
  String get readerNormal => 'Normal';

  @override
  String get readerWide => 'Amplio';

  @override
  String get readerAddFavorite => 'Añadir a favoritos';

  @override
  String get readerRemoveFavorite => 'Quitar de favoritos';

  @override
  String get readerCopy => 'Copiar texto';

  @override
  String get readerCopied => 'Texto copiado';

  @override
  String get readerShare => 'Compartir';

  @override
  String get readerClose => 'Cerrar';

  @override
  String get readerPrevious => 'Unidad anterior';

  @override
  String get readerNext => 'Unidad siguiente';

  @override
  String get readerReferences => 'Referencias bíblicas:';

  @override
  String get readerQuestionPrefix => 'P.';

  @override
  String get readerAnswerPrefix => 'R.';

  @override
  String get readerAttribution =>
      'Compartido desde Pactantes — Recursos Reformados.';

  @override
  String get readerLoadError => 'No se pudo abrir este documento.';

  @override
  String get readerSaveError =>
      'No se pudieron guardar los cambios. Inténtalo de nuevo.';

  @override
  String get readerActionError =>
      'No se pudo completar esta acción. Inténtalo de nuevo.';

  @override
  String get readerDecreaseSize => 'Reducir tamaño del texto';

  @override
  String get readerIncreaseSize => 'Aumentar tamaño del texto';

  @override
  String get readerNavigation => 'Navegación del documento';

  @override
  String get readerTheme => 'Tema';

  @override
  String get readerTranslation => 'Traducción';

  @override
  String get readerDeviceLanguage => 'Idioma del dispositivo';

  @override
  String get readerEnglish => 'Inglés';

  @override
  String get readerPortuguese => 'Portugués';

  @override
  String get readerSpanish => 'Español';

  @override
  String get homeResumeStudy => 'Retomar estudio';

  @override
  String get homeBeginStudy => 'Comenzar estudio';

  @override
  String get homeConfessionsSummary => 'Textos confesionales';

  @override
  String get homeCatechismsSummary => 'Preguntas y respuestas';

  @override
  String get homeCreedsSummary => 'Símbolos de la fe';

  @override
  String get homeDocumentsSummary => 'Textos históricos';

  @override
  String get homeScriptureQuote =>
      '“Porque por gracia sois salvos por la fe; y esto no de vosotros, pues es don de Dios:”';

  @override
  String get homeScriptureReference => 'EFESIOS 2:8';

  @override
  String bibleBookName(String book, String code) {
    String _temp0 = intl.Intl.selectLogic(book, {
      'book1Chr': '1 Crónicas',
      'book1Cor': '1 Corintios',
      'book1John': '1 Juan',
      'book1Kgs': '1 Reyes',
      'book1Pet': '1 Pedro',
      'book1Sam': '1 Samuel',
      'book1Thess': '1 Tesalonicenses',
      'book1Tim': '1 Timoteo',
      'book2Chr': '2 Crónicas',
      'book2Cor': '2 Corintios',
      'book2Kgs': '2 Reyes',
      'book2Pet': '2 Pedro',
      'book2Sam': '2 Samuel',
      'book2Thess': '2 Tesalonicenses',
      'book2Tim': '2 Timoteo',
      'bookActs': 'Hechos',
      'bookCol': 'Colosenses',
      'bookDan': 'Daniel',
      'bookDeut': 'Deuteronomio',
      'bookEccl': 'Eclesiastés',
      'bookEph': 'Efesios',
      'bookExod': 'Éxodo',
      'bookEzek': 'Ezequiel',
      'bookGal': 'Gálatas',
      'bookGen': 'Génesis',
      'bookHab': 'Habacuc',
      'bookHeb': 'Hebreos',
      'bookIsa': 'Isaías',
      'bookJas': 'Santiago',
      'bookJer': 'Jeremías',
      'bookJob': 'Job',
      'bookJoel': 'Joel',
      'bookJohn': 'Juan',
      'bookJosh': 'Josué',
      'bookJude': 'Judas',
      'bookLev': 'Levítico',
      'bookLuke': 'Lucas',
      'bookMark': 'Marcos',
      'bookMatt': 'Mateo',
      'bookMic': 'Miqueas',
      'bookNah': 'Nahúm',
      'bookNum': 'Números',
      'bookPhil': 'Filipenses',
      'bookProv': 'Proverbios',
      'bookPs': 'Salmos',
      'bookRev': 'Apocalipsis',
      'bookRom': 'Romanos',
      'bookTitus': 'Tito',
      'bookZech': 'Zacarías',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get language => 'Idioma';
}
