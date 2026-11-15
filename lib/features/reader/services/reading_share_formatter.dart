import '../models/reading_content.dart';

class ReadingShareFormatter {
  const ReadingShareFormatter();

  String format({
    required ReadingContent document,
    required ReadingUnit unit,
    required String unitLabel,
    required String questionPrefix,
    required String answerPrefix,
    required String referencesLabel,
    required String attribution,
  }) {
    final List<String> parts = <String>[
      '*${document.title}*',
      '_${<String>[if (unit.parentTitle != null) unit.parentTitle!, unitLabel].join(' · ')}_',
      if (unit.question != null) '*$questionPrefix ${unit.question}*',
      if (unit.question != null) '$answerPrefix ${unit.body}' else unit.body,
      if (unit.references.isNotEmpty)
        '*$referencesLabel*\n${unit.references.join('\n')}',
      '_${attribution}_',
    ];
    return parts.join('\n\n');
  }
}
