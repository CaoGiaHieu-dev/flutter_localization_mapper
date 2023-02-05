class MapperExtension {
  final bool l10n;
  final bool locale;
  final bool l10nParser;

  const MapperExtension(
      {this.l10n = true, this.locale = true, this.l10nParser = true});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MapperExtension &&
        other.l10n == l10n &&
        other.locale == locale &&
        other.l10nParser == l10nParser;
  }

  @override
  int get hashCode => l10n.hashCode ^ locale.hashCode ^ l10nParser.hashCode;

  @override
  String toString() =>
      'MapperExtension(l10n: $l10n, locale: $locale, l10nParser: $l10nParser)';
}

class LocalizationMapperAnnotation {
  final MapperExtension mapperExtension;

  const LocalizationMapperAnnotation(
      {this.mapperExtension = const MapperExtension()});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LocalizationMapperAnnotation &&
        other.mapperExtension == mapperExtension;
  }

  @override
  int get hashCode => mapperExtension.hashCode;

  @override
  String toString() =>
      'LocalizationMapperAnnotation(mapperExtension: $mapperExtension)';
}

const localizationMapper = LocalizationMapperAnnotation();
