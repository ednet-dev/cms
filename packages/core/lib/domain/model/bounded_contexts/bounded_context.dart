// part of ednet_core;
// import '../../../../../../../../../home/slavisam/.config/Google/AndroidStudio2021.3/scratches/semantic_attribute.dart';
// import 'package:ednet_core/src/domain/model/entity/semantic_attribute_format.dart';
// import 'package:ednet_core/src/domain/model/entity/semantic_attribute_type.dart';
//
// class BoundedContext {
//   final String name;
//
//   final List<ValueObject> valueObjects;
//   final List<Entity> entities;
//   final List<AggregateRoot> aggregateRoots;
//   final List<ApplicationService> applicationServices;
//   late final List<BoundedContext> dependencies;
//   final List<Repository> repositories;
//
//   BoundedContext({required this.name,
//     required this.entities,
//     this.applicationServices,
//     this.dependencies,
//     this.repositories}) {
//     _validateName();
//     _validateEntities();
//     _validateApplicationServices();
//     _validateDependencies();
//   }
//
//   void _validateName() {
//     if (name == null || name.isEmpty) {
//       throw Exception("Bounded context name must be provided");
//     }
//   }
//
//   void _validateEntities() {
//     if (entities == null || entities.isEmpty) {
//       throw Exception("Bounded context must have at least one entity");
//     }
//     entities.forEach((entity) {
//       if (entity.name == null || entity.name.isEmpty) {
//         throw Exception("Entity name must be provided");
//       }
//     });
//   }
//
//   void _validateApplicationServices() {
//     if (applicationServices == null) {
//       return;
//     }
//     applicationServices.forEach((applicationService) {
//       if (applicationService.name == null || applicationService.name.isEmpty) {
//         throw Exception("Application service must have a name.");
//       }
//
// // Create the ApplicationService instance.
//       final appService = ApplicationService(
//           name: applicationService.name,
//           dependencies: appServiceDependencies,
//           commands: appServiceCommands,
//           events: appServiceEvents);
//
// // Add the ApplicationService instance to the list of application services.
//       applicationServices.add(appService);
//     });
//   }
//
//   void _validateDependencies() {
//     if (dependencies == null) {
//       return;
//     }
//     dependencies.forEach((dependency) {
//       if (dependency.name == null || dependency.name.isEmpty) {
//         throw Exception("Bounded context dependency must have a name");
//       }
//     });
//   }
//
// // Add the BoundedContext instance to the map of contexts.
//
//   factory BoundedContext.fromYaml(Map<dynamic, dynamic> yaml) {
//     final entities = yaml['entities']
//         .map((entityYaml) => Entity.fromYaml(entityYaml))
//         .toList();
//
//     final services = yaml['services']
//         .map((serviceYaml) => Service.fromYaml(serviceYaml, entities))
//         .toList();
//
//     final repositories = yaml['repositories']
//         .map((repositoryYaml) => Repository.fromYaml(repositoryYaml))
//         .toList();
//     return BoundedContext(
//         name: yaml['name'],
//         entities: entities,
//         services: services,
//         repositories: repositories);
//   }
// }
//
//
// // based on selected criteria attributes of entity, value object or aggregate root and
// // based on selected operands which connect two or more criterion's,
// // we can build a query which will be used to find the aggregate root
// // or entity or value object
// // for example:
// // Criteria criteria = Criteria()
// //   ..addCriterion(Criterion('name', Operand.EQUAL, 'John'))
// //   ..addCriterion(Criterion('age', Operand.GREATER_THAN, 18))
// //   ..addCriterion(Criterion('age', Operand.LESS_THAN, 30));
// // this criteria will be used to find all users with name John, age greater than 18 and less than 30
//
// // we can also add a criterion which will be used to sort the results
// // Criteria criteria = Criteria()
// //   ..addCriterion(Criterion('name', Operand.EQUAL, 'John'))
// //   ..addCriterion(Criterion('age', Operand.GREATER_THAN, 18))
// //   ..addCriterion(Criterion('age', Operand.LESS_THAN, 30))
// //   ..addCriterion(Criterion('age', Operand.SORT, SortOrder.ASCENDING));
// // this criteria will be used to find all users with name John, age greater than 18 and less than 30
// // and sort them by age in ascending order
//
// // we can also add a criterion which will be used to limit the number of results
// // Criteria criteria = Criteria()
// //   ..addCriterion(Criterion('name', Operand.EQUAL, 'John'))
// //   ..addCriterion(Criterion('age', Operand.GREATER_THAN, 18))
// //   ..addCriterion(Criterion('age', Operand.LESS_THAN, 30))
// //   ..addCriterion(Criterion('age', Operand.SORT, SortOrder.ASCENDING))
// //   ..addCriterion(Criterion('age', Operand.LIMIT, 10));
// // this criteria will be used to find all users with name John, age greater than 18 and less than 30
// // and sort them by age in ascending order and limit the number of results to 10
//
// // we can also add a criterion which will be used to skip the first n results
// // Criteria criteria = Criteria()
// //   ..addCriterion(Criterion('name', Operand.EQUAL, 'John'))
// //   ..addCriterion(Criterion('age', Operand.GREATER_THAN, 18))
// //   ..addCriterion(Criterion('age', Operand.LESS_THAN, 30))
// //   ..addCriterion(Criterion('age', Operand.SORT, SortOrder.ASCENDING))
// //   ..addCriterion(Criterion('age', Operand.LIMIT, 10))
// //   ..addCriterion(Criterion('age', Operand.SKIP, 5));
// // this criteria will be used to find all users with name John, age greater than 18 and less than 30
// // and sort them by age in ascending order and limit the number of results to 10 and skip the first 5 results
// // this will return the 6th to 10th result
//
// // we can also add a criterion which will be used to find the aggregate root by its id
// // Criteria criteria = Criteria()
// //   ..addCriterion(Criterion('id', Operand.EQUAL, '123'));
// // this criteria will be used to find the aggregate root with id 123
//
// class Criteria<T extends Entity> {
//   /// Chaining operand for logical connection between two or more [Criteria] statements.
//   Operand chainingOperand = Operand.AND;
//
//   /// Inner operand for logical connection between two or more criteria.
//   Operand innerOperand = Operand.AND;
//   /// List of [Criteria] objects bound by [innerOperand].
//   List<Criterion> criteria = [];
//
//
//   /// Criteria manages limit, sort and pagination of results.
//   int limit;
//   int skip;
//   SortOrder sortOrder;
//   String sortAttribute;
//
//   /// Criteria objects preserve correct pagination and sort order upon getNextPageCriteria() and getPreviousPageCriteria() calls
//   int currentPage = 1;
//   int pageSize = 10;
//
//
//   void addCriterion(Criterion criterion) {
//     criteria.add(criterion);
//   }
//
//   void removeCriterion(Criterion criterion) {
//     criteria.remove(criterion);
//   }
//
//   void clearCriteria() {
//     criteria.clear();
//   }
//
//   List<Criterion> getCriteria() {
//     return criteria;
//   }
//
//   bool hasCriteria() {
//     return criteria.isNotEmpty;
//   }
//
//   bool hasCriterion(Criterion criterion) {
//     return criteria.contains(criterion);
//   }
//
//
//   void setLimit(int limit) {
//     this.limit = limit;
//   }
//
//   void setSkip(int skip) {
//     this.skip = skip;
//   }
//
//   void setSortOrder(SortOrder sortOrder) {
//     this.sortOrder = sortOrder;
//   }
//
//   void setSortAttribute(String sortAttribute) {
//     this.sortAttribute = sortAttribute;
//   }
//
//   int getLimit() {
//     return limit;
//   }
//
//   int getSkip() {
//     return skip;
//   }
//
//   SortOrder getSortOrder() {
//     return sortOrder;
//   }
//
//   String getSortAttribute() {
//     return sortAttribute;
//   }
//
//
//   void setCurrentPage(int currentPage) {
//     this.currentPage = currentPage;
//   }
//
//   void setPageSize(int pageSize) {
//     this.pageSize = pageSize;
//   }
//
//   int getCurrentPage() {
//     return currentPage;
//   }
//
//   int getPageSize() {
//     return pageSize;
//   }
//
//   Criteria({this.chainingOperand = Operand.AND});
//
//   Criteria getNextPageCriteria() {
//     Criteria criteria = clone();
//     criteria.setCurrentPage(currentPage + 1);
//     criteria.setSkip((currentPage + 1) * pageSize);
//     return criteria;
//   }
//
//   Criteria getPreviousPageCriteria() {
//     Criteria criteria = clone();
//     criteria.setCurrentPage(currentPage - 1);
//     criteria.setSkip((currentPage - 1) * pageSize);
//     return criteria;
//   }
//
//   Criteria clone() {
//     Criteria criteria = Criteria();
//     criteria.chainingOperand = chainingOperand;
//     criteria.criteria = criteria;
//     criteria.limit = limit;
//     criteria.skip = skip;
//     criteria.sortOrder = sortOrder;
//     criteria.sortAttribute = sortAttribute;
//     criteria.currentPage = currentPage;
//     criteria.pageSize = pageSize;
//     return criteria;
//   }
// }
//
// class Criterion {
//   final EntityAttribute attribute;
//   final Operand operand;
//   final dynamic value;
//
//   Criterion(this.attribute, this.operand, this.value);
// }
//
// // enum Operand { EQUAL, GREATER_THAN, LESS_THAN, SORT, LIMIT, SKIP }
//
// class Operand {
//   final OperandType operandType;
//
//   const Operand(this.operandType);
//
//   static const Operand EQUAL = Operand(OperandType.EQUAL);
//   static const Operand GREATER_THAN = Operand(OperandType.GREATER_THAN);
//   static const Operand LESS_THAN = Operand(OperandType.LESS_THAN);
//   static const Operand SORT = Operand(OperandType.SORT);
//   static const Operand LIMIT = Operand(OperandType.LIMIT);
//   static const Operand SKIP = Operand(OperandType.SKIP);
//   static const Operand AND = Operand(OperandType.AND);
//   static const Operand OR = Operand(OperandType.OR);
// }
//
// class OperandType {
//   final String value;
//
//   const OperandType(this.value);
//
//   static const OperandType EQUAL = OperandType('EQUAL');
//   static const OperandType GREATER_THAN = OperandType('GREATER_THAN');
//   static const OperandType LESS_THAN = OperandType('LESS_THAN');
//   static const OperandType SORT = OperandType('SORT');
//   static const OperandType LIMIT = OperandType('LIMIT');
//   static const OperandType SKIP = OperandType('SKIP');
//   static const OperandType AND = OperandType('AND');
//   static const OperandType OR = OperandType('OR');
// }
//
// class SortOrder {
//   final String value;
//
//   const SortOrder(this.value);
//
//   static const SortOrder ASCENDING = SortOrder('ASCENDING');
//   static const SortOrder DESCENDING = SortOrder('DESCENDING');
// }
//
// /// Show how chaining of Criteria works on example of building complex query
// /// which will be used to find all users with name John, age greater than 18 and less than 30
// /// and sort them by age in ascending order and limit the number of results to 10 and skip the first 5 results
//
// class UserCriteria extends Criteria<User> {
//   UserCriteria() : super(chainingOperand: Operand.AND);
// }
//
// class User extends Entity {
//   @override
//   String toString() {
//     return 'User{name: $name, attributes: $attributes}';
//   }
//
//   @override
//   List<EntityAttribute> attributes = [
//     const EntityAttribute(
//       name: 'name',
//       type: EntityAttributeType.text,
//       format: EntityAttributeFormat.medium,
//       value: 'USer entity dude!',
//
//     ),
//   ]
//
//   @override
//   late List<EntityCommand> commands;
//
//   @override
//   late String description;
//
//   @override
//   late String id;
//
//   @override
//   late List<EntityEvent> interests;
//
//   @override
//   late List<EntityPolicy> policies;
//
//   @override
//   late List<String> tags;
//
//   @override
//   late List<EntityEvent> topics;
//
//   @override
//   // TODO: implement toJson
//   String get toJson {
//     return '''{
//       "id": "$id",
//       "name": "$name",
//       "age": $age
//     }''';
//   }
//
//   @override
//   String name = 'User';
// }
//
// final criteria = Criteria<User>()
//   ..addCriterion(Criterion(User.name, Operand.EQUAL, 'John'))..addCriterion(
//       Criterion(User.age, Operand.GREATER_THAN, 18))..addCriterion(
//       Criterion(User.age, Operand.LESS_THAN, 30))..addCriterion(
//       Criterion(User.age, Operand.SORT, SortOrder.ASCENDING))..addCriterion(
//       Criterion(User.age, Operand.LIMIT, 10))..addCriterion(
//       Criterion(User.age, Operand.SKIP, 5));
