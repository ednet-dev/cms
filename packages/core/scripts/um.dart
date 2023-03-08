import 'dart:convert';
import 'dart:io';

void main(List<String> arguments) {
  String dirPath;
  if (arguments.isNotEmpty) {
    dirPath = arguments[0];
  } else {
    dirPath = Directory.current.path;
  }
  var outputPath = '$dirPath/model.json';

  Map<String, dynamic> model = {
    'width': 1920,
    'height': 1080,
    'boxes': [],
    'lines': [],
  };

  // provider oid 1678027117481, id null, code provider



  // if (File(outputPath).existsSync()) {
  //   var contents = File(outputPath).readAsStringSync();
  //   model = json.decode(contents);
  // }

  var jsonFiles = Directory(dirPath)
      .listSync(recursive: true, followLinks: false)
      .where((entity) =>
          entity is File &&
          entity.path.toLowerCase().endsWith('.json') &&
          !(entity.path.toLowerCase().endsWith('model.json')));

  for (var file in jsonFiles) {
    var contents = (file as File).readAsStringSync();
    var data = json.decode(contents);

    if (data is List) {
      for (var singleData in data) {
        _updateModel(singleData, model);
      }
    } else {
      _updateModel(data, model);
    }
  }

  var output = File(outputPath);
  output.writeAsStringSync(json.encode(model));
}

void _updateModel(Map<String, dynamic> data, Map<String, dynamic> model) {
  if (data['boxes'] != null) {
    for (var box in data['boxes']) {
      var existingBox = model['boxes']
          .firstWhere((b) => b['name'] == box['name'], orElse: () => null);

      if (existingBox == null) {
        model['boxes'].add(box);
      } else if (!mapsEqual(box, existingBox)) {
        var index = model['boxes'].indexOf(existingBox);
        model['boxes'][index] = box;
      }
    }
  }

  if (data['lines'] != null) {
    for (var line in data['lines']) {
      var existingLine = model['lines'].firstWhere(
          (l) =>
              l['from'] == line['from'] &&
              l['to'] == line['to'] &&
              l['fromToName'] == line['fromToName'] &&
              l['toFromName'] == line['toFromName'],
          orElse: () => null);

      if (existingLine == null) {
        model['lines'].add(line);
      } else if (!mapsEqual(line, existingLine)) {
        var index = model['lines'].indexOf(existingLine);
        model['lines'][index] = line;
      }
    }
  }
}

bool mapsEqual(Map map1, Map map2) {
  if (map1.length != map2.length) return false;

  for (var key in map1.keys) {
    if (!map2.containsKey(key)) return false;
    if (map1[key] is Map && map2[key] is Map) {
      if (!mapsEqual(map1[key], map2[key])) return false;
    } else if (map1[key] is List && map2[key] is List) {
      if (!listEquals(map1[key], map2[key])) return false;
    } else if (map1[key] != map2[key]) {
      return false;
    }
  }

  return true;
}

bool listEquals(List list1, List list2) {
  if (list1.length != list2.length) return false;

  for (var i = 0; i < list1.length; i++) {
    if (list1[i] is Map && list2[i] is Map) {
      if (!mapsEqual(list1[i], list2[i])) return false;
    } else if (list1[i] is List && list2[i] is List) {
      if (!listEquals(list1[i], list2[i])) return false;
    } else if (list1[i] != list2[i]) {
      return false;
    }
  }

  return true;
}
