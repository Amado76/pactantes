// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get brandSubtitle => 'Recursos Reformados';

  @override
  String get introTitle => 'Crescendo em Graça e Verdade';

  @override
  String get introDescription =>
      'Bíblias, confissões, catecismos e textos históricos da fé reformada.';

  @override
  String get bibleTitle => 'Bíblia Sagrada';

  @override
  String get bibleEdition => 'Versão SBT';

  @override
  String get continueReading => 'Continuar lendo';

  @override
  String get exploreLibrary => 'Explorar a biblioteca';

  @override
  String get seeAll => 'Ver tudo';

  @override
  String get confessions => 'Confissões de fé';

  @override
  String get catechisms => 'Catecismos';

  @override
  String get creeds => 'Credos históricos';

  @override
  String get documents => 'Documentos reformados';

  @override
  String get home => 'Início';

  @override
  String get bible => 'Bíblia';

  @override
  String get library => 'Biblioteca';

  @override
  String get search => 'Buscar';

  @override
  String get community => 'Comunidade';

  @override
  String get moreOptions => 'Mais opções';

  @override
  String completed(int percent) {
    return '$percent% CONCLUÍDO';
  }

  @override
  String paragraph(int number) {
    return 'Parágrafo $number';
  }

  @override
  String readingPage(int current, int total) {
    return 'Leitura $current de $total';
  }

  @override
  String get startReading => 'Começar a ler';

  @override
  String question(int number) {
    return 'Pergunta $number';
  }

  @override
  String questionCount(int count) {
    return '$count perguntas';
  }

  @override
  String get documentBeginning => 'Início do documento';

  @override
  String get documentConfession => 'Confissão de fé';

  @override
  String get documentCatechism => 'Catecismo';

  @override
  String get documentCreed => 'Credo histórico';

  @override
  String get documentHistorical => 'Documento reformado';

  @override
  String get documentCollection => 'Coleção';

  @override
  String get readingProgressError =>
      'Não foi possível carregar o progresso de leitura.';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get loadingReadingProgress => 'Carregando o progresso de leitura';
}
