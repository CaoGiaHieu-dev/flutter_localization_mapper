library localization_mapper_generator;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/localization_mapper_generator.dart';

Builder generateLocalizationClass(BuilderOptions options) =>
    SharedPartBuilder([LocalizationMapperGenerator()], 'localization_mapper_gen');
