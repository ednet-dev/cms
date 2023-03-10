## 0.0.1+7
 
 - Bump "ednet_core" to `0.0.1+7`.  

## 0.0.1+6

+ Debug Github CI/CD

## 0.0.1+5

+ Tag based GitHub Actions publishing of core, gen and cms

## 0.0.1+4

+ streamline and lock versioning of ednet_core, ednet_code_generation and ednet_cms to v0.

## 0.0.1+3

  + EDNetDSL JSON schema for JSON and YAML dialects
  + example yaml domain model 

## 0.0.1+2

+ refactor to modern Dart
  + all Api suffixes of interfaces to IName
  + ConceptEntity -> Entity
  + nullability functional unstable solution
+ reset version

## 0.0.1+1

Legacy

*2.0.3* 2015-05-19

+ rename ValidationError into ValidationException in lib/domain/model/error/validations.dart
+ ValidationException implements Exception

*2.0.3* 2015-05-15

+ rename errors.dart into exceptions.dart in lib/domain/model/error
+ before: class EDNetCoreError extends Error
+ now: class EDNetCoreException implements Exception
+ rename other classes in exceptions.dart

*2.0.3* 2015-05-04

+ use test: ^0.12.0 in pubspec

*2.0.2* 2015-05-01 (Pub)

+ add void where missing

*2.0.2* 2015-04-30

+ gen void where missing
+ add void where missing

*2.0.1* 2015-04-29 (Pub)

+ add random.dart and search.dart in lib/gen
+ improve formatting of generated tests
+ add several examples from projects at GitHub

*2.0.1* 2015-04-25

+ add null check in the Id.compareAttributes method in lib/model/id.dart
+ prepare ednet_core to use one day mixins in ConceptGen classes, e.g.,
  abstract class ProjectGen extends Object with ConceptEntity<Project> {
  abstract class ProjectsGen extends Object with Entities<Project> {
+ update ConceptEntity and Entities in lib/domain/model/entity.dart and entities.dart:
  no constructors, add void set concept(Concept concept)
+ update the newEntity and newEntities methods in ModelEntries in lib/domain/model/entries.dart
+ update the example and test folders

*2.0.1* 2015-04-24

+ use new test package
+ update pubspec.yaml: from dev_dependencies to dependencies for test
+ update import in the test folder
+ update lib/gen/ednet_core_test.dart

*2.0.0* 2014-10-03 (Pub)

+ from json to entity: test if there is oid in json
+ integrate entities, addEntities, setEntities, removeEntities
+ whenAdded, whenSet and whenRemoved can be set only if concept.updateWhen is true
+ add removeFrom and setAttributesFrom in Entities
+ add setAttributesFrom in ConceptEntity
+ add whenAdded, whenSet and whenRemoved DateTime properties in ConceptEntity
+ populate references down the internal tree of each entry concept
+ compare 2 values of the same type in the type
+ if a concept does not have an id, a required attribute becomes essential
+ compare 2 entities based on their attributes
+ use type base when validating a type value
+ use type base when comparing id attributes
+ add child navigate with init of true
+ init parent absorb to true
+ add Duration, PostalCode, ZipCode types
+ validate if a String value is of the attribute type
+ add increment attributes in concept
+ add util/text_transformers.dart and use it for codes and labels
+ add Telephone, Name, Description and Money attribute types
+ derive default labels, if null, from code and codes
+ derive default attribute length, if null, from type length
+ meta: set length of Uri type, Email type
+ meta: add label and labels in concept; label in property; length in attribute
+ add getStringOrNullFromAttribute to ConceptEntity API:
  return null, and not "null", if getStringFromAttribute is null
+ add a list of not increment attributes in concept
+ add a list of identifier attributes in concept
+ add a list of not identifier attributes in concept
+ add missing end of a generated test
+ validate if code is empty in lower or upper transformations in entity
+ add error messages when add and remove propagations are not successful
+ prepare domain, model and entities in main of tests
+ propagate immediately after pre in add and remove
+ correct a problem in remove (removed the same entity twice),
  discovered in newly generated tests
+ add more gen tests
+ handle id attribute increment in add propagations
+ order entry concepts for model init
+ drop increment attribute in model init;
  drop increment attribute id unique error test
+ handle neighbor names different from standard names in model init code gen
+ handle optional parents in model init code gen
+ break a loop on creating reflexive child entities in the model's init
+ use Reference to set up first references from model json in each entry tree,
  then populate external parents based on references
+ treat special case of reflexive and twin neighbors in model init
+ add conditions in code gen of tests
+ add more raw data for random gen
+ for Email type generate random init values in model
+ support type code vs. type base (Email vs. String)
+ decomment Email and Other types in domain
+ concept external parents and external required parents
+ model ordered (by external parent count) entry concepts
+ generate model init with initChildren ordered by external parent count
+ external parent count for concept parents
+ rename base type to origin type
+ generate mutiple tests per entry concept
+ generate a test file per entry concept
+ generate model init with internal children
+ update code gen (specific repo, domain and model; model entry json)
+ remove displayJson() in generated code
+ in addition to String, num and DateTime attribute ids,
  you can order on Uri and bool attribute ids
+ improve entries.fromJson based on the entry concept internal tree
+ for a parent reference in JSON, instead of only oid string,
  use a map of oid  string, parent concept code and entry concept code
+ change API in lib/domain/model/entries.dart:
  EntityApi single(Oid oid);
  EntityApi internalSingle(String entryConceptCode, Oid oid);
  EntitiesApi internalChild(String entryConceptCode, Oid oid);
  String fromEntryToJson(String entryConceptCode);
  fromJsonToEntry(String entryJson);
  String toJson();
  fromJson(String json);
+ change API in lib/domain/model/entities.dart:
  EntityApi internalSingle(Oid oid);
  EntitiesApi internalChild(Oid oid);
  removed: List<Map<String, Object>> toJson();
+ update README.md

*1.0.6* 2014-02-25

+ add return null when there is a warning

*1.0.5* 2014-02-25

+ in code gen replace new Uri.fromString by Uri.parse

*1.0.4* 2013-12-03

+ remove unreachable code

*1.0.3* 2013-11-28

+ when loading data from a json document avoid creating entities that have been already created

*1.0.2* 2013-11-25

+ rename LOG.md to CHANGELOG.md
+ update pubspec.yaml: Homepage and Documentation links

*1.0.1* 2013-11-07

+ update README.md to display web links properly
