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
  String get bibleEdition => 'Tradução SBT';

  @override
  String get continueReading => 'Continuar leitura';

  @override
  String get exploreLibrary => 'Explorar Acervo';

  @override
  String get seeAll => 'Ver acervo completo';

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

  @override
  String get readerSettings => 'Ajustes de leitura';

  @override
  String get readerTextSize => 'Tamanho do texto';

  @override
  String get readerLight => 'Claro';

  @override
  String get readerPaper => 'Papel';

  @override
  String get readerDark => 'Escuro';

  @override
  String get readerSpacing => 'Espaçamento';

  @override
  String get readerCompact => 'Compacto';

  @override
  String get readerNormal => 'Normal';

  @override
  String get readerWide => 'Amplo';

  @override
  String get readerAddFavorite => 'Adicionar aos favoritos';

  @override
  String get readerRemoveFavorite => 'Remover dos favoritos';

  @override
  String get readerCopy => 'Copiar texto';

  @override
  String get readerCopied => 'Texto copiado';

  @override
  String get readerShare => 'Compartilhar';

  @override
  String get readerClose => 'Fechar';

  @override
  String get readerPrevious => 'Unidade anterior';

  @override
  String get readerNext => 'Próxima unidade';

  @override
  String get readerReferences => 'Referências bíblicas:';

  @override
  String get readerQuestionPrefix => 'P.';

  @override
  String get readerAnswerPrefix => 'R.';

  @override
  String get readerAttribution =>
      'Compartilhado pelo Pactantes — Recursos Reformados.';

  @override
  String get readerLoadError => 'Não foi possível abrir este documento.';

  @override
  String get readerSaveError =>
      'Não foi possível salvar as alterações. Tente novamente.';

  @override
  String get readerActionError =>
      'Não foi possível concluir esta ação. Tente novamente.';

  @override
  String get readerDecreaseSize => 'Diminuir tamanho do texto';

  @override
  String get readerIncreaseSize => 'Aumentar tamanho do texto';

  @override
  String get readerNavigation => 'Navegação do documento';

  @override
  String get readerTheme => 'Tema';

  @override
  String get readerTranslation => 'Tradução';

  @override
  String get readerDeviceLanguage => 'Idioma do aparelho';

  @override
  String get readerEnglish => 'Inglês';

  @override
  String get readerPortuguese => 'Português';

  @override
  String get readerSpanish => 'Espanhol';

  @override
  String get homeResumeStudy => 'Retomar estudo';

  @override
  String get homeBeginStudy => 'Começar estudo';

  @override
  String get homeConfessionsSummary => 'Textos confessionais';

  @override
  String get homeCatechismsSummary => 'Perguntas e respostas';

  @override
  String get homeCreedsSummary => 'Símbolos da fé';

  @override
  String get homeDocumentsSummary => 'Textos históricos';

  @override
  String get homeScriptureQuote =>
      '“Pois pela graça sois salvos, por meio da fé; e isto não vem de vós, é dom de Deus.”';

  @override
  String get homeScriptureReference => 'EFÉSIOS 2:8';

  @override
  String bibleBookName(String book, String code) {
    String _temp0 = intl.Intl.selectLogic(book, {
      'book1Chr': '1 Crônicas',
      'book1Cor': '1 Coríntios',
      'book1John': '1 João',
      'book1Kgs': '1 Reis',
      'book1Pet': '1 Pedro',
      'book1Sam': '1 Samuel',
      'book1Thess': '1 Tessalonicenses',
      'book1Tim': '1 Timóteo',
      'book2Chr': '2 Crônicas',
      'book2Cor': '2 Coríntios',
      'book2Kgs': '2 Reis',
      'book2Pet': '2 Pedro',
      'book2Sam': '2 Samuel',
      'book2Thess': '2 Tessalonicenses',
      'book2Tim': '2 Timóteo',
      'bookActs': 'Atos',
      'bookCol': 'Colossenses',
      'bookDan': 'Daniel',
      'bookDeut': 'Deuteronômio',
      'bookEccl': 'Eclesiastes',
      'bookEph': 'Efésios',
      'bookExod': 'Êxodo',
      'bookEzek': 'Ezequiel',
      'bookGal': 'Gálatas',
      'bookGen': 'Gênesis',
      'bookHab': 'Habacuque',
      'bookHeb': 'Hebreus',
      'bookIsa': 'Isaías',
      'bookJas': 'Tiago',
      'bookJer': 'Jeremias',
      'bookJob': 'Jó',
      'bookJoel': 'Joel',
      'bookJohn': 'João',
      'bookJosh': 'Josué',
      'bookJude': 'Judas',
      'bookLev': 'Levítico',
      'bookLuke': 'Lucas',
      'bookMark': 'Marcos',
      'bookMatt': 'Mateus',
      'bookMic': 'Miqueias',
      'bookNah': 'Naum',
      'bookNum': 'Números',
      'bookPhil': 'Filipenses',
      'bookProv': 'Provérbios',
      'bookPs': 'Salmos',
      'bookRev': 'Apocalipse',
      'bookRom': 'Romanos',
      'bookTitus': 'Tito',
      'bookZech': 'Zacarias',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get language => 'Idioma';
}
