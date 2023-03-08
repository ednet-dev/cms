part of ednet_core;

abstract class IId<T> implements Comparable<T>{
  Concept get concept;

  int get referenceLength;

  int get attributeLength;

  int get length;

  Reference? getReference(String code);

  void setReference(String code, Reference reference);

  Object? getAttribute(String code);

  void setAttribute(String code, Object attribute);
}
