part of ednet_core;

String dropEnd(String text, String end) {
  String withoutEnd = text;
  int endPosition = text.lastIndexOf(end);
  if (endPosition > 0) {
    // drop the end
    withoutEnd = text.substring(0, endPosition);
  }
  return withoutEnd;
}

String plural(String text) {
  var t = text.trim();
  if (t == '') {
    return '';
  }
  String result;
  String lastLetter = t.substring(t.length - 1, t.length);
  if (lastLetter == 'x') {
    result = '${t}es';
  } else if (lastLetter == 'z') {
    result = '${t}zes';
  } else if (lastLetter == 'y') {
    String withoutLast = dropEnd(text, lastLetter);
    result = '${withoutLast}ies';
  } else {
    result = '${t}s';
  }
  return result;
}

String firstLetterLower(String text) {
  var t = text.trim();
  if (t == '') {
    return '';
  }
  List<String> letterList = t.split('');
  letterList[0] = letterList[0].toLowerCase();
  String result = '';
  for (String letter in letterList) {
    result = '$result$letter';
  }
  return result;
}

String firstLetterUpper(String text) {
  var t = text.trim();
  if (t == '') {
    return '';
  }
  List<String> letterList = t.split('');
  letterList[0] = letterList[0].toUpperCase();
  String result = '';
  for (String letter in letterList) {
    result = '$result$letter';
  }
  return result;
}

String camelCaseSeparator(String text, String separator) {
  var t = text.trim();
  if (t == '') {
    return '';
  }
  RegExp exp = RegExp(r"([A-Z])");
  Iterable<Match> matches = exp.allMatches(t);
  var indexes = <int>[];
  for (Match m in matches) {
    indexes.add(m.end);
  }
  int previousIndex = 0;
  var camelCaseWordList = <String>[];
  for (int index in indexes) {
    String camelCaseWord = t.substring(previousIndex, index - 1);
    camelCaseWordList.add(camelCaseWord);
    previousIndex = index - 1;
  }
  String camelCaseWord = t.substring(previousIndex);
  camelCaseWordList.add(camelCaseWord);

  String? previousCamelCaseWord;
  String result = '';
  for (String camelCaseWord in camelCaseWordList) {
    if (camelCaseWord == '') {
      previousCamelCaseWord = camelCaseWord;
    } else {
      if (previousCamelCaseWord == '') {
        result = '$result$camelCaseWord';
      } else {
        result = '$result$separator$camelCaseWord';
      }
      previousCamelCaseWord = camelCaseWord;
    }
  }
  return result;
}

String camelCaseLowerSeparator(String text, String separator) {
  var result = camelCaseSeparator(text, separator);
  return result.toLowerCase();
}

String camelCaseFirstLetterUpperSeparator(String text, String separator) {
  var result = camelCaseSeparator(text, separator);
  return firstLetterUpper(result);
}
