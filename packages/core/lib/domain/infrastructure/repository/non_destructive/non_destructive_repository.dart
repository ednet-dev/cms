part of repository;

// class NonDestructiveRepository extends CoreRepository {
//   @override
//   List<AggregateRoot> findAll() {
//     // TODO: implement findAll
//     throw UnimplementedError();
//   }
//
//   @override
//   List<AggregateRoot> findByCriteria(criteria) {
//     // TODO: implement findByCriteria
//     throw UnimplementedError();
//   }
//
//   @override
//   AggregateRoot findById(String id) {
//     // TODO: implement findById
//     throw UnimplementedError();
//   }
//
//   @override
//   void save(AggregateRoot aggregateRoot) {
//     // TODO: implement save
//   }
// // final Isar _isar;
// //
// // NonDestructiveRepository(this._isar);
// //
// // Future<T> get<T extends Entity>(Id id) async {
// //   final snapshot = await _isar.snapshot(id);
// //   return snapshot.rehydrate<T>();
// // }
// //
// // Future<List<T>> query<T extends Entity>(Criterion criterion) async {
// //   final snapshots = await _isar.snapshotAll(criterion);
// //   return snapshots.map((snapshot) => snapshot.rehydrate<T>()).toList();
// // }
// //
// // Future<void> put<T extends Entity>(T entity) async {
// //   await _isar.applyEvents(entity.events);
// // }
// //
// // Future<void> putAll<T extends Entities>(List<T> entities) async {
// //   final events = entities.expand((entity) => entity.events);
// //   await _isar.applyEvents(events);
// // }
// //
// // Future<void> delete<T extends Entities>(T entity) async {
// //   await _isar.applyEvents(entity.deleteEvents);
// // }
// //
// // Future<void> deleteAll<T extends Entities>(List<T> entities) async {
// //   final events = entities.expand((entity) => entity.deleteEvents);
// //   await _isar.applyEvents(events);
// // }
// }
