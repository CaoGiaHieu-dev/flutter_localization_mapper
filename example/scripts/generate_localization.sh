# grant executable permissions
chmod +x ./replace_string.sh

# generate localization
(cd ../ && flutter gen-l10n)

requiredImports=$(cat << EOM
import 'package:localization_mapper_annotation\/localization_mapper_annotation.dart';\n\
part 'app_localizations.g.dart';\n\n\
@LocalizationMapperAnnotation()\n\
abstract class AppLocalizations {
EOM
)

# requiredImports="import \'package:localization_mapper_annotation\/localization_mapper_annotation.dart'\;\npart \'app_localizations.g.dart'\;\n\n@LocalizationMapperAnnotation()\nabstract class AppLocalizations {"

# write imports and annotations to app_localization.dart file
echo "\nAdding required imports to generated app_localizations"
bash ./replace_string.sh "../lib/localization/gen-l10n/app_localizations.dart" "abstract class AppLocalizations {" "$requiredImports"

echo "\nGenerating app_localizations mapper files"
(cd ../ && flutter pub run build_runner build --delete-conflicting-outputs)