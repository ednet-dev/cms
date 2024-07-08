part of ednet_core_types;

// lib/repository.dart

class Repository extends CoreRepository {
  static const REPOSITORY = 'Repository';

  Repository([String code = REPOSITORY]) : super(code) {
    var domain = new Domain('EDNetCore');
    domains.add(domain);
    add(EDNetCoreDomain(domain));
  }
}
