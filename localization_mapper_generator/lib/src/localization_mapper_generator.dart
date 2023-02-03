// ignore_for_file: implementation_imports, depend_on_referenced_packages

import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:localization_mapper_annotation/localization_mapper_annotation.dart';
import 'package:source_gen/source_gen.dart';

import 'model_visitor.dart';

// indicates methods mapper would not be generated for
const genExceptions = [
  'of',
  'delegate',
  'localizationsDelegates',
  'supportedLocales',
];

class LocalizationMapperGenerator
    extends GeneratorForAnnotation<LocalizationMapperAnnotation> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final visitor = ModelVisitor();
    element.visitChildren(visitor);

    final buffer = StringBuffer();
    final className = '${visitor.className}Mapper';

    buffer.writeln('class $className {');

    // constructor
    buffer.writeln('const $className();');

    // toMap
    buffer.writeln(
        'Map<String, dynamic> toLocalizationMap(BuildContext context) {');
    buffer.writeln('return {');
    // all getters
    for (var i = 0; i < visitor.fields.values.length; i++) {
      final element = visitor.fields.keys.elementAt(i);

      // skips gen-exceptions
      if (genExceptions.contains(element)) continue;

      buffer.writeln("'$element': AppLocalizations.of(context)!.$element,");
    }

    // all methods
    for (var i = 0; i < visitor.methods.values.length; i++) {
      final element = visitor.methods.keys.elementAt(i);
      final parameters = visitor.parameters.values.elementAt(i);

      // skips gen-exceptions
      if (genExceptions.contains(element)) continue;
      
      buffer.writeln(
          "'$element': ($parameters) => AppLocalizations.of(context)!.$element($parameters),");
    }

    buffer.writeln('};');
    buffer.writeln('}');
    buffer.writeln('}');

    return buffer.toString();
  }
}
