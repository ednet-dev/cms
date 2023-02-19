// abstract class IRepository<T extends Entity> {
//   T findById(IIdentity identity);
//
//   List<T> find(IQuery query);
// }
//
// abstract class IQuery<T extends Entity> {
//   final ICriteria<T> criteria;
//
//   const IQuery({criteria}) : criteria = criteria;
// }
//
// class UserQuery extends IQuery<User> {
//   const UserQuery({super.criteria});
// }
//
// abstract class ICriteria<T extends Entity> {
//   late IFilter<T> filter;
//   late ISort<T> sort;
//
//   ICriteria<T> and(ICriteria<T> criteria);
//
//   ICriteria<T> or(ICriteria<T> criteria);
//
//   ICriteria<T> not();
// }
//
// abstract class ISort<T extends Entity> {
//   late List<IAttribute<T>> attributes;
//
//   bool sort(T entity);
// }
//
// abstract class And<T> extends Operand {
//   And(super.left, super.right);
// }
//
// abstract class IAttribute<T> {
//   late T value;
// }
//
// // class NumberSort<T extends Entity> implements ISort<T> {
// //   @override
// //   bool sort(T entity) {
// //
// //   }
// // }
//
// abstract class IFilter<T extends Entity> {
//   bool filter(T entity);
// }
//
// abstract class Entity with IIdentity {}
//
// mixin IIdentity<T> {
//   late T id;
// }
//
// class User extends Entity {
//   final name;
//
//   User({
//     required this.name,
//   });
// }
//
// class Contains {
//   final String value;
//
//   Contains(this.value);
// }
//
// class Operand<T> {
//   final T left;
//   final T? right;
//
//   const Operand(this.left, this.right);
//
//   @override
//   bool operator ==(Object other) {
//     if (other is Operand) {
//       return left == other.left && right == other.right;
//     }
//     return false;
//   }
// }
//
// class IsEqual extends Operand<String> {
//   final String value;
//
//   IsEqual(this.value) : super(value, value);
//
//   bool operator ==(Object other) {
//     if (other is IsEqual) {
//       return value == other.value;
//     }
//     return false;
//   }
// }
//
// class Sort {
//   final List<SortAttribute> attributes;
//
//   Sort(this.attributes);
// }
//
// enum SortDirection {
//   asc,
//   desc,
// }
//
// class SortAttribute<T> {
//   final T value;
//   final SortDirection direction;
//
//   SortAttribute({
//     required this.value,
//     required this.direction,
//   });
// }
//
// //
// // void moin() {
// //   final u = User(name: "Patrik svejzi");
// //
// //
// //   const userFilter = Filter(
// //     [
// //       On(
// //             (user) => IsEqual(user.name, filterUserName),
// //       ),
// //       On(
// //             (user) => Contains(user.name, filterUserName),
// //       ),
// //       On(
// //             (user) => StartsWith(user.name, filterUserName),
// //       ),
// //     ],
// //   );
// //
// //   const userSort = Sort<User>(
// //     [
// //       On(
// //             (user) =>
// //             SortAttribute(
// //               value: user.name,
// //               direction: Sort.acz,
// //             ),
// //       ),
// //     ],
// //   )
// //
// //   const query = Query(
// //     criteria: Criteria(
// //       filter: userFilter,
// //       sort: Sort(
// //         [
// //               (user) =>
// //               SortAttribute<String>(
// //                 value: user.name,
// //                 direction: Sort.asc,
// //               ),
// //         ],
// //       ),
// //     ),
// //   );
// //
// //   const results = await userRepository.find(query);
// // }
