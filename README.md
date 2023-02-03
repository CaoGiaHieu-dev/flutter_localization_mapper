# localization_mapper
A dart package to generate app-localization mapper that can be parsed dynamic translation keys (as flutter-localizations package does not yet support this).

**All contributions to the package are welcome**

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


Note: `write_to_file.sh` script is currently limited to writing imports and annotations to a specific line number (which should be accounted for when supplying parameters in the `generate_localization.sh` script) but a better approach would be a script to search for the beginning of the generated `app-localization` class and add imports and annotation above the class. 
```sh
../scripts/write_to_file.sh

#!/bin/bash

# check if enough arguments were provided
if [ $# -lt 2 ]; then
    echo "Error: Not enough arguments provided."
    echo "Usage: $0 <file> <line_number> <string_to_add>"
    exit 1
fi

# assign input arguments to variables
file=$1
line_number=$2
string_to_add=$3

# backup the original file
cp $file "$file.bak"

# add the string to the desired line and write the result to a new file
counter=0
while read line; do
    ((counter++))
    if [ $counter -eq $line_number ]; then
        echo "$string_to_add$line" >> "$file.tmp"
    else
        echo "$line" >> "$file.tmp"
    fi
done < "$file"

# overwrite the original file with the new file
mv "$file.tmp" "$file"

echo "String addition completed successfully."

```

The below `generate_localization.sh` script 
- grants `write_to_file.sh` executable permission
- generates translations
- write required imports and annotations to generated `app-localization` file
- generates other part files with `app-localization` mapper inclusive

Note: ensure to change all paths to your proper `../lib/localization/gen-l10n/app_localizations.dart` file part and add your contributions for a better script.
```sh
../scripts/generate_localization.sh

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
```

Helper extensions

To access translations dynamically and parse placeholder parameters, I created an extension to simplify and hide unessecary boilerplate-code.

```dart
import 'package:flutter/material.dart';

import '../gen-l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get cashierL10n => AppLocalizations.of(this)!;
  Locale get cashierActiveLocale => Localizations.localeOf(this);

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
  final status = context.cashierL10nParse('transaction_status');
  final title = context.cashierL10nParse('application_title');
  
  // parsing placeholder parameters
  final greeting = context.cashierL10nParse('app_greeting', arguments: ['😀']); // Hello 😀
```

Observed Limitaions
Flutter application regenerates `app-localization` file which results to cleared annotations and imports and will require running the `generate_localization.sh` script to write all required imports and annotations in the `app-localization` file. 

For more information, checkout the example project.

