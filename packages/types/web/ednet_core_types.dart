import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_core_types/ednet_core_types.dart';
import 'package:ednet_core_types/ednet_core_types_app.dart';

void main() {
  final repository = CoreRepository();
  final domain = repository.getDomainModels('EDNetCore') as EDNetCoreModels;
  TypesApp(domain);
}
