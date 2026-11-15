import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';

enum _ReaderAction { favorite, settings, translation, copy }

class ReaderOverflowMenu extends StatelessWidget {
  const ReaderOverflowMenu({
    required this.favorite,
    required this.favoriteEnabled,
    required this.enabled,
    required this.onFavorite,
    required this.onSettings,
    required this.onCopy,
    required this.onTranslation,
    super.key,
  });
  final bool favorite;
  final bool favoriteEnabled;
  final bool enabled;
  final VoidCallback onFavorite;
  final VoidCallback onSettings;
  final VoidCallback onCopy;
  final VoidCallback onTranslation;
  @override
  Widget build(BuildContext context) {
    final AppLocalizations strings = AppLocalizations.of(context);
    return PopupMenuButton<_ReaderAction>(
      tooltip: strings.moreOptions,
      enabled: enabled,
      icon: const Icon(Icons.more_horiz, size: 22),
      position: PopupMenuPosition.under,
      onSelected: (_ReaderAction action) {
        switch (action) {
          case _ReaderAction.favorite:
            onFavorite();
          case _ReaderAction.settings:
            onSettings();
          case _ReaderAction.copy:
            onCopy();
          case _ReaderAction.translation:
            onTranslation();
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<_ReaderAction>>[
        PopupMenuItem<_ReaderAction>(
          value: _ReaderAction.favorite,
          enabled: favoriteEnabled,
          child: Row(
            children: <Widget>[
              Icon(favorite ? Icons.bookmark : Icons.bookmark_border),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  favorite
                      ? strings.readerRemoveFavorite
                      : strings.readerAddFavorite,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<_ReaderAction>(
          value: _ReaderAction.settings,
          child: Row(
            children: <Widget>[
              const Icon(Icons.text_fields),
              const SizedBox(width: 12),
              Flexible(child: Text(strings.readerSettings)),
            ],
          ),
        ),
        PopupMenuItem<_ReaderAction>(
          value: _ReaderAction.translation,
          child: Row(
            children: <Widget>[
              const Icon(Icons.translate_outlined),
              const SizedBox(width: 12),
              Flexible(child: Text(strings.readerTranslation)),
            ],
          ),
        ),
        PopupMenuItem<_ReaderAction>(
          value: _ReaderAction.copy,
          child: Row(
            children: <Widget>[
              const Icon(Icons.content_copy_outlined),
              const SizedBox(width: 12),
              Flexible(child: Text(strings.readerCopy)),
            ],
          ),
        ),
      ],
    );
  }
}
