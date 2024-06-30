part of ednet_core;

abstract class IOneApplication {
  Domains get domains;

  Domains get groupedDomains;

  DomainModels getDomainModels(String domain, String model);
}
