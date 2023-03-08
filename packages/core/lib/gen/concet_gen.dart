import 'package:ednet_core/ednet_core.dart';

String genConceptGen({
  required Concept concept,
  required String library,
  Child? child,
  Parent? parent,
}) {
  Model model = concept.model;
  Domain domain = model.domain;

  var emptyChildren = '''
    ${concept.code}Gen(Concept concept) { 
    this.concept = concept; 
    }
  ''';
  var initChildren = '''
  ${concept.code}Gen(Concept concept) {
    this.concept = concept;
''';
  String template = '''
part of ${library}; 
 
// lib/gen/${domain.codeLowerUnderscore}/${model.codeLowerUnderscore}/${concept.codesLowerUnderscore}.dart 
 
abstract class ${concept.code}Gen extends Entity<${concept.code}> { 
   ${emptyChildren}
   ${initChildren}
    Concept? providerCriteriaConcept = concept.model.concepts.singleWhereCode("ProviderCriteria"); 
    assert(providerCriteriaConcept!= null); 
    setChild("inquiry", Provider  Criterias(providerCriteriaConcept!)); 
    Concept? attachmentConcept = concept.model.concepts.singleWhereCode("Attachment"); 
    assert(attachmentConcept!= null); 
    setChild("attachments", Attachments(attachmentConcept!)); 
    Concept? offerConcept = concept.model.concepts.singleWhereCode("Offer"); 
    assert(offerConcept!= null); 
    setChild("offers", Offers(offerConcept!)); 
  } 
 
  Reference get buyerReference => getReference("buyer") as Reference; 
  void set buyerReference(Reference reference) { setReference("buyer", reference); } 
  
  User get buyer => getParent("buyer") as User; 
  void set buyer(User p) { setParent("buyer", p); } 
  
  String get title => getAttribute("title"); 
  void set title(String a) { setAttribute("title", a); } 
  
  String get description => getAttribute("description"); 
  void set description(String a) { setAttribute("description", a); } 
  
  String get category => getAttribute("category"); 
  void set category(String a) { setAttribute("category", a); } 
  
  String get branch => getAttribute("branch"); 
  void set branch(String a) { setAttribute("branch", a); } 
  
  DateTime get publishingDate => getAttribute("publishingDate"); 
  void set publishingDate(DateTime a) { setAttribute("publishingDate", a); } 
  
  DateTime get expirationDate => getAttribute("expirationDate"); 
  void set expirationDate(DateTime a) { setAttribute("expirationDate", a); } 
  
  String get deliveryLocation => getAttribute("deliveryLocation"); 
  void set deliveryLocation(String a) { setAttribute("deliveryLocation", a); } 
  
  String get providerCriteria => getAttribute("providerCriteria"); 
  void set providerCriteria(String a) { setAttribute("providerCriteria", a); } 
  
  String get status => getAttribute("status"); 
  void set status(String a) { setAttribute("status", a); } 
  
  ProviderCriterias get inquiry => getChild("inquiry") as ProviderCriterias; 
  
  Attachments get attachments => getChild("attachments") as Attachments; 
  
  Offers get offers => getChild("offers") as Offers; 
  
  ${concept.code} newEntity() => ${concept.code}(concept); 
  Inquiries newEntities() => Inquiries(concept); 
  
} 
 
abstract class InquiriesGen extends Entities<${concept.code}> { 
 
  InquiriesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Inquiries newEntities() => Inquiries(concept); 
  ${concept.code} newEntity() => ${concept.code}(concept); 
  
}''';

  return template.replaceAllMapped(RegExp('{{(.*?)}}'), (match) {
    var placeholder = match.group(1);
    switch (placeholder) {
      case 'attribute.code':
        var attribute = concept.attributes.whereType<Attribute>().first;
        return attribute.code!;
      case 'attribute.type.base':
        var attribute = concept.attributes.whereType<Attribute>().first;
        return attribute.type?.base ?? '';

      case 'concept.id.length':
        return concept.id.length.toString();
      case 'concept.id.referenceLength':
        return concept.id.referenceLength.toString();
      case 'concept.id.attributeLength':
        return concept.id.attributeLength.toString();
      case 'concept.code':
        return concept.code!;
      case 'concept.codes':
        return concept.codes;
      case 'concept.codesLowerUnderscore':
        return concept.codesLowerUnderscore;
      case 'concept.codeFirstLetterLower':
        return concept.codeFirstLetterLower;
      case 'concept.codesLowerUnderscore':
        return concept.codesLowerUnderscore;
      case 'concept.model.codeLowerUnderscore':
        return concept.model.codeLowerUnderscore;
      case 'concept.model.domain.codeLowerUnderscore':
        return concept.model.domain.codeLowerUnderscore;

      case 'child.destinationConcept.codes':
        return child!.destinationConcept.codes;

      case 'destinationConcept.codeFirstLetterLower':
        var parent = concept.parents.whereType<Parent>().first;
        return parent.destinationConcept.codeFirstLetterLower;
      case 'destinationConcept.code':
        var child = concept.children.whereType<Child>().first;
        return child.destinationConcept.code!;
      case 'destinationConcept.codes':
        var child = concept.children.whereType<Child>().first;
        return child.destinationConcept.codes;
      //
      // case 'domain.package':
      //   return domain.package;
      case 'domain.codeLowerUnderscore':
        return domain.codeLowerUnderscore;
      //
      // case 'model.package':
      //   return model.package;

      case 'library':
        return library;

      case 'model.codeLowerUnderscore':
        return model.codeLowerUnderscore;

      case 'parent.code':
        var parent = concept.parents.whereType<Parent>().first;
        return parent.code!;
      case 'parent.destinationConcept.code':
        return parent!.destinationConcept.code!;

      case 'library':
        return library;

      default:
        return match.group(0)!;
    }
  });
}
