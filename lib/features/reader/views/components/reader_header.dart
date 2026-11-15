import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import 'reader_overflow_menu.dart';

class ReaderHeader extends StatelessWidget {
  const ReaderHeader({
    required this.enabled,
    required this.onShare,
    required this.favorite,
    required this.favoriteEnabled,
    required this.onFavorite,
    required this.onSettings,
    required this.onTranslation,
    required this.onCopy,
    super.key,
  });
  final bool enabled;
  final void Function(Rect origin)? onShare;
  final bool favorite;
  final bool favoriteEnabled;
  final VoidCallback onFavorite;
  final VoidCallback onSettings;
  final VoidCallback onTranslation;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations strings = AppLocalizations.of(context);
    final ButtonStyle buttonStyle = IconButton.styleFrom(
      fixedSize: const Size(48, 48),
      iconSize: 22,
      visualDensity: VisualDensity.standard,
    );
    return IconButtonTheme(
      data: IconButtonThemeData(
        style: (IconButtonTheme.of(context).style ?? const ButtonStyle()).merge(
          buttonStyle,
        ),
      ),
      child: SizedBox(
        height: 48,
        child: Row(
          children: <Widget>[
            IconButton(
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.chevron_left),
            ),
            const Spacer(),
            Builder(
              builder: (BuildContext buttonContext) => IconButton(
                tooltip: strings.readerShare,
                onPressed: onShare == null
                    ? null
                    : () {
                        final RenderBox box =
                            buttonContext.findRenderObject()! as RenderBox;
                        onShare!(box.localToGlobal(Offset.zero) & box.size);
                      },
                icon: const Icon(Icons.ios_share_outlined, size: 20),
              ),
            ),
            SizedBox.square(
              dimension: 48,
              child: ReaderOverflowMenu(
                favorite: favorite,
                favoriteEnabled: favoriteEnabled,
                enabled: enabled,
                onFavorite: onFavorite,
                onSettings: onSettings,
                onTranslation: onTranslation,
                onCopy: onCopy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
