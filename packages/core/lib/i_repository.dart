part of ednet_core;

abstract class IRepository {
  void add(IDomainModels domainModels);

  Domains get domains;

  IDomainModels getDomainModels(String domainCode);

  void gen(String library, [bool specific = true]);
}

//class Repository implements RepoApi {
