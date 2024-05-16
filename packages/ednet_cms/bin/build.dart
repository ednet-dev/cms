import 'dart:io';
import 'package:path/path.dart' as p;

void main(List<String> arguments) {
  // Get the path of the build.dart script.
  Uri scriptUri = Platform.script;

  // Resolve the path of the client project folder, assuming the script is called from the root folder.
  String clientAppFolderPath = p.dirname(p.dirname(p.fromUri(scriptUri)));

  print('The path of the client project folder is: $clientAppFolderPath');
}
