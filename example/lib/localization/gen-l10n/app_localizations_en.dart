import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get cashier_fiat_deposit_timeframe_bank_brite => 'Instant';

  @override
  String get cashier_activate_tronlink => 'To use TronLink, first click on your TronLink extension and log in.';

  @override
  String get cashier_active_balance => 'Active balance';

  @override
  String cashier_balance_reverted(Object currency) {
    return '$currency balance';
  }

  @override
  String cashier_convert_before_withdraw(Object convertfrom, Object convertto, Object convertFrom, Object convertTo) {
    return '* For withdrawing your $convertFrom you first need to convert it back to $convertTo';
  }
}
