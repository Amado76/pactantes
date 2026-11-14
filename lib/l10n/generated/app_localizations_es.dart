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
}
