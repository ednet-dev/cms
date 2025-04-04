import 'package:ednet_core/ednet_core.dart';
import '../../src/model/serbian_election_model.dart';
import 'izborna_jedinica.dart';

/// Glasač - birač sa pravom glasa
abstract class GlasacGen extends Entity<Glasac> {
  GlasacGen(Concept concept) {
    this.concept = concept;
  }

  String get ime => getAttribute('ime') as String;
  set ime(String value) => setAttribute('ime', value);

  String get jmbg => getAttribute('jmbg') as String;
  set jmbg(String value) => setAttribute('jmbg', value);

  DateTime get datumRodjenja => getAttribute('datumRodjenja') as DateTime;
  set datumRodjenja(DateTime value) => setAttribute('datumRodjenja', value);

  String get pol => getAttribute('pol') as String;
  set pol(String value) => setAttribute('pol', value);

  String get opstina => getAttribute('opstina') as String;
  set opstina(String value) => setAttribute('opstina', value);

  bool get glasao => getAttribute('glasao') as bool? ?? false;
  set glasao(bool value) => setAttribute('glasao', value);

  IzbornaJedinica? get birackoMesto =>
      getParent(SerbianElectionModel.BIRACKO_MESTO) as IzbornaJedinica?;
  set birackoMesto(IzbornaJedinica? value) {
    if (value != null) {
      setParent(SerbianElectionModel.BIRACKO_MESTO, value);
    }
  }

  @override
  Glasac newEntity() => Glasac(concept);

  @override
  Glasaci newEntities() => Glasaci(concept);
}

abstract class GlasaciGen extends Entities<Glasac> {
  GlasaciGen(Concept concept) {
    this.concept = concept;
  }

  @override
  Glasaci newEntities() => Glasaci(concept);

  @override
  Glasac newEntity() => Glasac(concept);
}

/// Glasač - implementacija
class Glasac extends GlasacGen {
  Glasac(Concept concept) : super(concept);
}

/// Glasači - kolekcija
class Glasaci extends GlasaciGen {
  Glasaci(Concept concept) : super(concept);
}
