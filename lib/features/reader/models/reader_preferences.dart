enum ReaderTranslation {
  device(null),
  english('en'),
  portuguese('pt'),
  spanish('es');

  const ReaderTranslation(this.languageCode);
  final String? languageCode;
}

enum ReaderPalette { light, paper, dark }

enum ReadingSpacing {
  compact(1.4),
  normal(1.65),
  wide(1.9);

  const ReadingSpacing(this.lineHeight);
  final double lineHeight;
}

class ReaderPreferences {
  const ReaderPreferences({
    this.palette = ReaderPalette.light,
    this.textSize = 20,
    this.spacing = ReadingSpacing.normal,
    this.translation = ReaderTranslation.device,
  });
  final ReaderPalette palette;
  final double textSize;
  final ReadingSpacing spacing;
  final ReaderTranslation translation;

  ReaderPreferences copyWith({
    ReaderPalette? palette,
    double? textSize,
    ReadingSpacing? spacing,
    ReaderTranslation? translation,
  }) => ReaderPreferences(
    palette: palette ?? this.palette,
    textSize: (textSize ?? this.textSize).clamp(14, 36),
    spacing: spacing ?? this.spacing,
    translation: translation ?? this.translation,
  );

  Map<String, Object> toJson() => <String, Object>{
    'theme': palette.name,
    'textSize': textSize,
    'spacing': spacing.name,
    'translation': translation.name,
  };

  factory ReaderPreferences.fromJson(Map<String, Object?> json) {
    final Object? size = json['textSize'];
    return ReaderPreferences(
      translation:
          ReaderTranslation.values
              .where(
                (ReaderTranslation value) => value.name == json['translation'],
              )
              .firstOrNull ??
          ReaderTranslation.device,
      palette:
          ReaderPalette.values
              .where((ReaderPalette p) => p.name == json['theme'])
              .firstOrNull ??
          ReaderPalette.light,
      textSize: size is num && size.isFinite
          ? size.toDouble().clamp(14, 36)
          : 20,
      spacing:
          ReadingSpacing.values
              .where((ReadingSpacing s) => s.name == json['spacing'])
              .firstOrNull ??
          ReadingSpacing.normal,
    );
  }
}
