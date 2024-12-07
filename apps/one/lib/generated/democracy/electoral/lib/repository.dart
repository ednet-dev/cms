part of './democracy_electoral.dart';

// lib/repository.dart
class DemocracyElectoralRepo extends CoreRepository {
  DemocracyElectoralRepo([super.code = repository]) {
    final domain = Domain('Democracy');
    domains.add(domain);
    add(DemocracyDomain(domain));
  }

  static const repository = 'DemocracyElectoralRepo';
}
