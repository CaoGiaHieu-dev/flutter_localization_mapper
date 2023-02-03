# grant executable permissions
chmod +x ./write_to_file.sh

# generate localization
(cd ../ && flutter gen-l10n)

# write imports and annotations to app_localization.dart file
echo "\nAdding required imports to generated app_localizations"
./write_to_file.sh "../lib/localization/gen-l10n/app_localizations.dart"  17 "import 'package:localization_mapper_annotation/localization_mapper_annotation.dart';"
./write_to_file.sh "../lib/localization/gen-l10n/app_localizations.dart"  18 "part 'app_localizations.g.dart';"
./write_to_file.sh "../lib/localization/gen-l10n/app_localizations.dart"  19 "@LocalizationMapperAnnotation()"

echo "\nGenerating app_localizations mapper files"
(cd ../ && flutter pub run build_runner build --delete-conflicting-outputs)