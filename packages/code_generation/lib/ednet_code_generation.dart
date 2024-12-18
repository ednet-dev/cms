library ednet_code_generation;

import 'dart:io';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_core/gen/ednet_test.dart';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as p;

part 'src/ednet_code_generator.dart';

part 'src/doc_gen.dart';

part 'src/lib_gen.dart';

part 'src/test_gen.dart';

part 'src/web_gen.dart';

String libraryName = 'ednet_one';
String domainName = 'ednet';
String? outputDir;
String modelName = 'one';

late CoreRepository ednetCoreRepository;
late Domain ednetCoreDomain;
late Model ednetCoreModel;

String? modelJson;
String? yamlString;
