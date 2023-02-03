import 'package:flutter/material.dart';

import '../gen-l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get cashierL10n => AppLocalizations.of(this)!;
  Locale get cashierActiveLocale => Localizations.localeOf(this);

  String l10nParser(String translationKey, {List<Object>? arguments}) {
    const mapper = AppLocalizationsMapper();
    final object = mapper.toLocalizationMap(this)[translationKey];

    if (object is String) return object;

    assert(arguments != null, 'Arguments should not be null!');
    assert(arguments!.isNotEmpty, 'Arguments should not be empty!');

    return Function.apply(object, arguments);
  }
}
