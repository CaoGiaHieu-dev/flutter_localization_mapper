import 'app_localizations.dart';

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get cashier_fiat_deposit_timeframe_bank_brite => 'Immédiat';

  @override
  String get cashier_activate_tronlink => 'Pour utiliser TronLink, cliquez d\'abord sur votre extension TronLink et connectez-vous. ';

  @override
  String get cashier_active_balance => 'Solde actif';

  @override
  String cashier_balance_reverted(Object currency) {
    return 'Solde en $currency';
  }

  @override
  String cashier_convert_before_withdraw(Object convertfrom, Object convertto, Object convertFrom, Object convertTo) {
    return '* Pour pouvoir retirer $convertFrom, vous devez d\'abord le reconvertir en $convertTo.\n';
  }
}
