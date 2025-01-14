part of ednet_core;

class EDNetException implements Exception {
  final String message;

  EDNetException(this.message);

  @override
  toString() => '*** $message ***';
}

class CommandException extends EDNetException {
  CommandException(String message) : super(message);
}

class AddException extends CommandException {
  AddException(String message) : super(message);
}

class CodeException extends EDNetException {
  CodeException(String message) : super(message);
}

class ConceptException extends EDNetException {
  ConceptException(String message) : super(message);
}

class IdException extends EDNetException {
  IdException(String message) : super(message);
}

class JsonException extends EDNetException {
  JsonException(String message) : super(message);
}

class OidException extends EDNetException {
  OidException(String message) : super(message);
}

class OrderException extends EDNetException {
  OrderException(String message) : super(message);
}

class ParentException extends EDNetException {
  ParentException(String message) : super(message);
}

class RemoveException extends CommandException {
  RemoveException(String message) : super(message);
}

class TypeException extends EDNetException {
  TypeException(String message) : super(message);
}

class UpdateException extends CommandException {
  UpdateException(String message) : super(message);
}

class ConceptError extends CommandException {
  ConceptError(String message) : super(message);
}
