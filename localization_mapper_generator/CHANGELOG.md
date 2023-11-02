## 0.0.1

* Defined generator objects
* Implemented generator for `AppLocalizationsMapper`
* Implemented generator for `AppLocalizationsExtension` on build-context
* Accounted for config-options from `LocalizationMapperAnnotation`

## 0.0.2

* Accounted for null cases where translation-key was not found. returns `Translation key not found!` on error.

## 0.0.3

* Reduced dart-sdk minimum constraints `'>=2.18.1 <3.0.0'` 

## 1.0.0-dev.1

* Updated dart-sdk constraints `'>=3.0.0-0 <4.0.0'`
* Fixed bug resulting to un-generated `app_localizations.g.dart` file
