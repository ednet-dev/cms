part of ednet_core;

String genRepository(CoreRepository repo, String library) {
  var sc = 'part of ${library}; \n';
  sc = '${sc} \n';
  sc = '${sc}// lib/repository.dart \n';
  sc = '${sc} \n';
  sc = '${sc}class Repository extends CoreRepository { \n';
  sc = '${sc} \n';
  sc = '${sc}  static const REPOSITORY = "Repository"; \n';
  sc = '${sc} \n';
  sc = '${sc}  Repository([String code=REPOSITORY]) : super(code) { \n';
  for (Domain domain in repo.domains) {
    sc = '${sc}    var domain = Domain("${domain.code}"); \n';
    sc = '${sc}    domains.add(domain); \n';
    sc = '${sc}    add(${domain.code}Domain(domain)); \n';
    sc = '${sc} \n';
  }
  sc = '${sc}  } \n';
  sc = '${sc} \n';
  sc = '${sc}} \n';
  sc = '${sc} \n';

  return sc;
}
