part of ednet_core;

class Domains extends Entities<Domain> {
  Domain? getDomain(String code) => singleWhereCode(code);
}

