part of ednet_core;

class AttributeTypes extends Entities<AttributeType> {}

class AttributeType extends Entity<AttributeType> {
  late String base;
  late int length;

  Domain domain;

  AttributeType(this.domain, String typeCode) {
    if (typeCode == 'String') {
      base = typeCode;
      length = 64;
    } else if (typeCode == 'num') {
      base = typeCode;
      length = 8;
    } else if (typeCode == 'int') {
      base = typeCode;
      length = 8;
    } else if (typeCode == 'double') {
      base = typeCode;
      length = 8;
    } else if (typeCode == 'bool') {
      base = typeCode;
      length = 8;
    } else if (typeCode == 'DateTime') {
      base = typeCode;
      length = 16;
    } else if (typeCode == 'Duration') {
      base = typeCode;
      length = 16;
    } else if (typeCode == 'Uri') {
      base = typeCode;
      length = 80;
    } else if (typeCode == 'Email') {
      base = 'String';
      length = 48;
    } else if (typeCode == 'Telephone') {
      base = 'String';
      length = 16;
    } else if (typeCode == 'PostalCode') {
      base = 'String';
      length = 16;
    } else if (typeCode == 'ZipCode') {
      base = 'String';
      length = 16;
    } else if (typeCode == 'Name') {
      base = 'String';
      length = 32;
    } else if (typeCode == 'Description') {
      base = 'String';
      length = 256;
    } else if (typeCode == 'Money') {
      base = 'double';
      length = 8;
    } else if (typeCode == 'dynamic') {
      base = typeCode;
      length = 64;
    } else if (typeCode == 'Other') {
      base = 'dynamic';
      length = 128;
    } else {
      base = typeCode;
      length = 96;
    }
    code = typeCode;
    domain.types.add(this);
  }

  bool isEmail(String email) {
    var regexp = RegExp(r'\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\b');
    return regexp.hasMatch(email);
  }

  bool validate(String value) {
    if (base == 'num') {
      try {
        num.parse(value);
      } on FormatException {
        return false;
      }
    } else if (base == 'int') {
      try {
        int.parse(value);
      } on FormatException {
        return false;
      }
    } else if (base == 'double') {
      try {
        double.parse(value);
      } on FormatException {
        return false;
      }
    } else if (base == 'bool') {
      if (value != 'true' && value != 'false') {
        return false;
      }
    } else if (base == 'DateTime') {
      try {
        DateTime.parse(value);
      } on FormatException {
        return false;
      }
    } else if (base == 'Duration') {
      // validation?
    } else if (base == 'Uri') {
      var uri = Uri.parse(value);
      if (uri.host == '') {
        return false;
      }
    } else if (code == 'Email') {
      return isEmail(value);
    }
    return true;
  }

  bool validateValue(dynamic value) {
    if (value == null) {
      return true;
    }

    if (base == 'num') {
      return value is num;
    } else if (base == 'int') {
      return value is int;
    } else if (base == 'double') {
      return value is double;
    } else if (base == 'bool') {
      return value is bool;
    } else if (base == 'DateTime') {
      return value is DateTime;
    } else if (base == 'Duration') {
      return value is Duration;
    } else if (base == 'Uri') {
      return value is Uri;
    } else if (code == 'Email') {
      if (!(value is String)) {
        return false;
      }
      return true;
    } else if (base == 'String') {
      if (!(value is String)) {
        return false;
      }
      return true;
    }
    return true;
  }

  int compare(var value1, var value2) {
    var compare = 0;
    if (base == 'String') {
      compare = value1.compareTo(value2);
    } else if (base == 'num' || base == 'int' || base == 'double') {
      compare = value1.compareTo(value2);
    } else if (base == 'bool') {
      compare = value1.toString().compareTo(value2.toString());
    } else if (base == 'DateTime') {
      compare = value1.compareTo(value2);
    } else if (base == 'Duration') {
      compare = value1.compareTo(value2);
    } else if (base == 'Uri') {
      compare = value1.toString().compareTo(value2.toString());
    } else {
      String msg = 'cannot compare then order on this type: $code type.';
      throw OrderException(msg);
    }
    return compare;
  }

  @override
  Map<String, dynamic> toGraph() {
    final graph = super.toGraph();
    graph['base'] = base;
    graph['length'] = length;
    return graph;
  }
}
