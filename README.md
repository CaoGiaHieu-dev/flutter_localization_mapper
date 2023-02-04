# localization_mapper
A dart package to generate app-localization mapper that can be parsed dynamic translation keys (as flutter-localizations package does not yet support this).

Note: Setup localization using `flutter_localizations` package before proceeding with this.

## Getting started
Install dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter

  flutter_localizations:
    sdk: flutter
    
  localization_mapper_annotation: <latest-version>
  
dev_dependencies:
  build_runner: ^2.3.3
  
  localization_mapper_generator: <latest-version>
```


Define shell-scripts

This will write the required imports to the app-localization generated file given the relative file path, annotate with `LocalizationMapperAnnotation` and finally generate a part-file (mapper) for app-localization translation keys.


Note: `replace_string.sh` script is currently limited to writing imports and annotations to a specific line number (which should be accounted for when supplying parameters in the `generate_localization.sh` script) but a better approach would be a script to search for the beginning of the generated `app-localization` class and add imports and annotation above the class. 
```sh
../scripts/replace_string.sh

#!/bin/bash

# check if enough arguments were provided
if [ $# -lt 3 ]; then
    echo "Error: Not enough arguments provided."
    echo "Usage: $0 <input_file> <search_pattern> <replacement_string>"
    exit 1
fi

# assign input arguments to variables
input_file=$1
search_pattern=$2
replacement_string=$3

# check if the input file exists
if [ ! -f $input_file ]; then
    echo "Error: Input file does not exist."
    exit 1
fi

# backup the original file
cp $input_file "$input_file.bak"

# perform the search and replace and write the result to a new file
sed "s/$search_pattern/$replacement_string/i" $input_file > "$input_file.tmp"

# check if the replacement was successful
if [ $? -ne 0 ]; then
    echo "Error: Replacement failed."
    exit 1
fi

# overwrite the original file with the new file
mv "$input_file.tmp" "$input_file"

echo "Replacement completed successfully."
```

The below `generate_localization.sh` script 
- grants `replace_string.sh` executable permission
- generates translations
- write required imports and annotations to generated `app-localization` file
- generates other part files with `app-localization` mapper inclusive

Note: ensure to change `filePath` to your `/app_localizations.dart` file location.
```sh
../scripts/generate_localization.sh

# grant executable permissions (you should grant executable permissions at your will and not via scripts)
chmod +x ./replace_string.sh

# generate localization
(cd ../ && flutter gen-l10n)

filePath="../lib/localization/gen-l10n/app_localizations.dart"
searchParameter="abstract class AppLocalizations {"
requiredImports=$(cat << EOM
import 'package:localization_mapper_annotation\/localization_mapper_annotation.dart';\n\
part 'app_localizations.g.dart';\n\n\
@LocalizationMapperAnnotation()\n\
abstract class AppLocalizations {
EOM
)

# write imports and annotations to app_localization.dart file
echo "\nAdding required imports to generated app_localizations"
bash ./replace_string.sh "$filePath" "$searchParameter" "$requiredImports"

echo "\nGenerating app_localizations mapper files"
(cd ../ && flutter pub run build_runner build --delete-conflicting-outputs)
```

Helper extensions

To access translations dynamically and parse placeholder parameters, I created an extension to simplify and hide unessecary boilerplate-code.

```dart
import 'package:flutter/material.dart';

import '../gen-l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  Locale get locale => Localizations.localeOf(this);

  String l10nParser(String translationKey, {List<Object>? arguments}) {
    const mapper = AppLocalizationsMapper(); // generated app-localizations.g.dart file
    final object = mapper.toLocalizationMap(this)[translationKey];

    if (object is String) return object;

    assert(arguments != null, 'Arguments should not be null!');
    assert(arguments!.isNotEmpty, 'Arguments should not be empty!');

    return Function.apply(object, arguments);
  }
}
```

Example usage

Note: parameters, are parsed as a list of positional arguments which should be parsed as specified in the translation-file.

```dart
  final status = context.l10nParser('transaction_status');
  final title = context.l10nParser('application_title');
  
  // parsing placeholder parameters
  final greeting = context.l10nParser('app_greeting', arguments: ['😀']); // Hello 😀
```

## Observed Limitaions
Flutter application regenerates localization files on `application run` (including `app-localization` file even with `generate: false`) which results to cleared annotations and imports and will require running the `generate_localization.sh` script to write all required imports and annotations in the `app-localization` file. 

With this in mind, the regenerated files results to errors that might prevent the execution of running the application since the generated part file `AppLocalizationsMapper` of `AppLocalizations` does not exist yet and is referenced in `LocalizationExtension`.

An approach around this would be to create a post script run workflow to run the `generate_localization.sh` script when `flutter run` command is completed when using a terminal or code editor to run the flutter application

**Note: Your PRs regarding this is highly encouraged and welcome**

For more information, checkout the example project.

