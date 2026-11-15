import 'package:flutter/material.dart';

import '../models/reader_preferences.dart';

class ReaderTheme extends ThemeExtension<ReaderTheme> {
  const ReaderTheme(this.palette);
  final ReaderPalette palette;
  static ReaderTheme of(BuildContext context) =>
      Theme.of(context).extension<ReaderTheme>()!;
  static const List<List<Color>> _colors = <List<Color>>[
    <Color>[
      Color(0xFFFAFAF8),
      Color(0xFFFFFFFF),
      Color(0xFF242B33),
      Color(0xFF73777B),
      Color(0xFF263E59),
      Color(0xFFA85D61),
      Color(0xFF263E59),
      Color(0xFFE8E6E1),
      Color(0xFFDAD8D3),
      Color(0xFF263E59),
      Color(0xFFFFFFFF),
      Color(0xFFC5C5C5),
    ],
    <Color>[
      Color(0xFFEFE7D7),
      Color(0xFFF5EFE4),
      Color(0xFF38332B),
      Color(0xFF746B5E),
      Color(0xFF34465A),
      Color(0xFFA85D61),
      Color(0xFF34465A),
      Color(0xFFDCD2BF),
      Color(0xFFD2C7B3),
      Color(0xFF34465A),
      Color(0xFFF5EFE4),
      Color(0xFFB8AE9E),
    ],
    <Color>[
      Color(0xFF1B222A),
      Color(0xFF222A32),
      Color(0xFFE5E1D9),
      Color(0xFFA8ADB3),
      Color(0xFFC4D3E3),
      Color(0xFFD38A8E),
      Color(0xFFAFC6DF),
      Color(0xFF343D47),
      Color(0xFF414B56),
      Color(0xFFAFC6DF),
      Color(0xFF1B222A),
      Color(0xFF626C76),
    ],
  ];
  Color get background => _colors[palette.index][0];
  Color get surface => _colors[palette.index][1];
  Color get primaryText => _colors[palette.index][2];
  Color get secondaryText => _colors[palette.index][3];
  Color get heading => _colors[palette.index][4];
  Color get accent => _colors[palette.index][5];
  Color get reference => _colors[palette.index][6];
  Color get divider => _colors[palette.index][7];
  Color get border => _colors[palette.index][8];
  Color get selectedBackground => _colors[palette.index][9];
  Color get selectedForeground => _colors[palette.index][10];
  Color get disabled => _colors[palette.index][11];
  ThemeData data(ThemeData base) {
    final Brightness brightness = palette == ReaderPalette.dark
        ? Brightness.dark
        : Brightness.light;
    final ColorScheme scheme =
        ColorScheme.fromSeed(
          seedColor: heading,
          brightness: brightness,
        ).copyWith(
          primary: heading,
          onPrimary: selectedForeground,
          secondary: accent,
          surface: surface,
          onSurface: primaryText,
          onSurfaceVariant: secondaryText,
          outline: border,
          outlineVariant: divider,
        );
    return base.copyWith(
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      disabledColor: disabled,
      canvasColor: background,
      textTheme: ThemeData(brightness: brightness).textTheme
          .apply(bodyColor: primaryText, displayColor: heading),
      iconTheme: IconThemeData(color: heading, size: 22),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: heading,
          disabledForegroundColor: disabled,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: heading,
          disabledForegroundColor: disabled,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: heading,
          disabledForegroundColor: disabled,
          side: BorderSide(color: border),
        ),
      ),
      dividerTheme: DividerThemeData(color: divider, thickness: 1, space: 1),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: background,
        surfaceTintColor: background,
        elevation: 0,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: surface,
        surfaceTintColor: surface,
        elevation: 2,
      ),
      extensions: <ThemeExtension<dynamic>>[this],
    );
  }

  @override
  ReaderTheme copyWith({ReaderPalette? palette}) =>
      ReaderTheme(palette ?? this.palette);
  @override
  ReaderTheme lerp(covariant ReaderTheme? other, double t) =>
      t < .5 ? this : other ?? this;
}
