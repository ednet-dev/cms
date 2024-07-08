part of ednet_core;

String genRepository(CoreRepository repo, String library) {
  //
  final repoName =
      '${library.split('_').map((e) => e[0].toUpperCase() + e.substring(1)).join()}Repo';

  var sc = 'part of ${library}; \n';
  sc = '${sc} \n';
  sc = '${sc}// lib/repository.dart \n';
  sc = '${sc} \n';
  sc = '${sc}class $repoName extends CoreRepository { \n';
  sc = '${sc} \n';
  sc = '${sc}  static const REPOSITORY = "$repoName"; \n';
  sc = '${sc} \n';
  sc = '${sc}  $repoName([String code=REPOSITORY]) : super(code) { \n';
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
