import 'package:ednet_core/ednet_core.dart';
import 'model.dart';

/// ModelEntries za srpski izborni sistem
class SerbianElectionEntries extends ModelEntries {
  SerbianElectionEntries(Model model) : super(model);

  /// Creates a map of new entity collections for each concept from the model
  @override
  Map<String, Entities> newEntries() {
    final entries = <String, Entities>{};

    // We'll create entries for each concept
    for (final concept in model.concepts) {
      if (concept.code == SerbianElectionModel.GLASAC) {
        entries[concept.code] = Glasaci(concept);
      } else if (concept.code == SerbianElectionModel.POLITICKA_STRANKA) {
        entries[concept.code] = PolitickeStranke(concept);
      } else if (concept.code == SerbianElectionModel.KOALICIJA) {
        entries[concept.code] = Koalicije(concept);
      } else if (concept.code == SerbianElectionModel.IZBORNA_LISTA) {
        entries[concept.code] = IzborneListe(concept);
      } else if (concept.code == SerbianElectionModel.KANDIDAT) {
        entries[concept.code] = Kandidati(concept);
      } else if (concept.code == SerbianElectionModel.IZBORNA_JEDINICA) {
        entries[concept.code] = IzborneJedinice(concept);
      } else if (concept.code == SerbianElectionModel.GLAS) {
        entries[concept.code] = Glasovi(concept);
      }
    }

    return entries;
  }

  /// Returns a new entity collection for the given concept
  @override
  Entities? newEntities(String conceptCode) {
    final concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError('$conceptCode concept does not exist.');
    }

    if (concept.code == SerbianElectionModel.GLASAC) {
      return Glasaci(concept);
    }

    if (concept.code == SerbianElectionModel.POLITICKA_STRANKA) {
      return PolitickeStranke(concept);
    }

    if (concept.code == SerbianElectionModel.KOALICIJA) {
      return Koalicije(concept);
    }

    if (concept.code == SerbianElectionModel.IZBORNA_LISTA) {
      return IzborneListe(concept);
    }

    if (concept.code == SerbianElectionModel.KANDIDAT) {
      return Kandidati(concept);
    }

    if (concept.code == SerbianElectionModel.IZBORNA_JEDINICA) {
      return IzborneJedinice(concept);
    }

    if (concept.code == SerbianElectionModel.GLAS) {
      return Glasovi(concept);
    }

    return null;
  }

  /// Returns a new entity for the given concept
  @override
  Entity? newEntity(String conceptCode) {
    final concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError('$conceptCode concept does not exist.');
    }

    if (concept.code == SerbianElectionModel.GLASAC) {
      return Glasac(concept);
    }

    if (concept.code == SerbianElectionModel.POLITICKA_STRANKA) {
      return PolitickaStranka(concept);
    }

    if (concept.code == SerbianElectionModel.KOALICIJA) {
      return Koalicija(concept);
    }

    if (concept.code == SerbianElectionModel.IZBORNA_LISTA) {
      return IzbornaLista(concept);
    }

    if (concept.code == SerbianElectionModel.KANDIDAT) {
      return Kandidat(concept);
    }

    if (concept.code == SerbianElectionModel.IZBORNA_JEDINICA) {
      return IzbornaJedinica(concept);
    }

    if (concept.code == SerbianElectionModel.GLAS) {
      return Glas(concept);
    }

    return null;
  }

  // Getters for entity collections
  Glasaci get glasaci => getEntry(SerbianElectionModel.GLASAC) as Glasaci;
  PolitickeStranke get politickeStranke =>
      getEntry(SerbianElectionModel.POLITICKA_STRANKA) as PolitickeStranke;
  Koalicije get koalicije =>
      getEntry(SerbianElectionModel.KOALICIJA) as Koalicije;
  IzborneListe get izborneListe =>
      getEntry(SerbianElectionModel.IZBORNA_LISTA) as IzborneListe;
  Kandidati get kandidati =>
      getEntry(SerbianElectionModel.KANDIDAT) as Kandidati;
  IzborneJedinice get izborneJedinice =>
      getEntry(SerbianElectionModel.IZBORNA_JEDINICA) as IzborneJedinice;
  Glasovi get glasovi => getEntry(SerbianElectionModel.GLAS) as Glasovi;
}

//====================================================================
// ENTITY IMPLEMENTATIONS
//====================================================================

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

/// Politička stranka
abstract class PolitickaStrankaGen extends Entity<PolitickaStranka> {
  PolitickaStrankaGen(Concept concept) {
    this.concept = concept;
  }

  String get naziv => getAttribute('naziv') as String;
  set naziv(String value) => setAttribute('naziv', value);

  String get skraceniNaziv => getAttribute('skraceniNaziv') as String;
  set skraceniNaziv(String value) => setAttribute('skraceniNaziv', value);

  DateTime get datumOsnivanja => getAttribute('datumOsnivanja') as DateTime;
  set datumOsnivanja(DateTime value) => setAttribute('datumOsnivanja', value);

  String get ideologija => getAttribute('ideologija') as String;
  set ideologija(String value) => setAttribute('ideologija', value);

  String get predsednik => getAttribute('predsednik') as String;
  set predsednik(String value) => setAttribute('predsednik', value);

  int get brojClanova => getAttribute('brojClanova') as int;
  set brojClanova(int value) => setAttribute('brojClanova', value);

  bool get manjinskaStranka =>
      getAttribute('manjinskaStranka') as bool? ?? false;
  set manjinskaStranka(bool value) => setAttribute('manjinskaStranka', value);

  @override
  PolitickaStranka newEntity() => PolitickaStranka(concept);

  @override
  PolitickeStranke newEntities() => PolitickeStranke(concept);
}

abstract class PolitickeStrankeGen extends Entities<PolitickaStranka> {
  PolitickeStrankeGen(Concept concept) {
    this.concept = concept;
  }

  @override
  PolitickeStranke newEntities() => PolitickeStranke(concept);

  @override
  PolitickaStranka newEntity() => PolitickaStranka(concept);
}

/// Koalicija
abstract class KoalicijaGen extends Entity<Koalicija> {
  KoalicijaGen(Concept concept) {
    this.concept = concept;
    final strankaKoncept = concept.model.concepts.singleWhereCode(
      SerbianElectionModel.POLITICKA_STRANKA,
    );
    if (strankaKoncept != null) {
      setChild(SerbianElectionModel.CLANICE, PolitickeStranke(strankaKoncept));
    }
  }

  String get naziv => getAttribute('naziv') as String;
  set naziv(String value) => setAttribute('naziv', value);

  DateTime get datumFormiranja => getAttribute('datumFormiranja') as DateTime;
  set datumFormiranja(DateTime value) => setAttribute('datumFormiranja', value);

  String get nosiocKoalicije => getAttribute('nosiocKoalicije') as String;
  set nosiocKoalicije(String value) => setAttribute('nosiocKoalicije', value);

  PolitickeStranke get clanice =>
      getChild(SerbianElectionModel.CLANICE) as PolitickeStranke;
  set clanice(PolitickeStranke value) =>
      setChild(SerbianElectionModel.CLANICE, value);

  // Pomoćna metoda za dodavanje stranaka u koaliciju
  void dodajStranku(PolitickaStranka stranka) {
    clanice.add(stranka);
  }

  // Pomoćna metoda za dodavanje više stranaka odjednom
  void dodajStranke(List<PolitickaStranka> stranke) {
    for (final stranka in stranke) {
      dodajStranku(stranka);
    }
  }

  @override
  Koalicija newEntity() => Koalicija(concept);

  @override
  Koalicije newEntities() => Koalicije(concept);
}

abstract class KoalicijeGen extends Entities<Koalicija> {
  KoalicijeGen(Concept concept) {
    this.concept = concept;
  }

  @override
  Koalicije newEntities() => Koalicije(concept);

  @override
  Koalicija newEntity() => Koalicija(concept);
}

/// Izborna lista
abstract class IzbornaListaGen extends Entity<IzbornaLista> {
  IzbornaListaGen(Concept concept) {
    this.concept = concept;
  }

  String get naziv => getAttribute('naziv') as String;
  set naziv(String value) => setAttribute('naziv', value);

  int get redniBroj => getAttribute('redniBroj') as int;
  set redniBroj(int value) => setAttribute('redniBroj', value);

  int? get brojGlasova => getAttribute('brojGlasova') as int?;
  set brojGlasova(int? value) => setAttribute('brojGlasova', value ?? 0);

  int? get brojMandata => getAttribute('brojMandata') as int?;
  set brojMandata(int? value) => setAttribute('brojMandata', value ?? 0);

  bool get manjinskaLista => getAttribute('manjinskaLista') as bool? ?? false;
  set manjinskaLista(bool value) => setAttribute('manjinskaLista', value);

  PolitickaStranka? get stranka =>
      getParent(SerbianElectionModel.STRANKA) as PolitickaStranka?;
  set stranka(PolitickaStranka? value) {
    if (value != null) {
      setParent(SerbianElectionModel.STRANKA, value);
    }
  }

  Koalicija? get koalicija =>
      getParent(SerbianElectionModel.KOALICIJA_REL) as Koalicija?;
  set koalicija(Koalicija? value) {
    if (value != null) {
      setParent(SerbianElectionModel.KOALICIJA_REL, value);
    }
  }

  @override
  IzbornaLista newEntity() => IzbornaLista(concept);

  @override
  IzborneListe newEntities() => IzborneListe(concept);
}

abstract class IzborneListeGen extends Entities<IzbornaLista> {
  IzborneListeGen(Concept concept) {
    this.concept = concept;
  }

  @override
  IzborneListe newEntities() => IzborneListe(concept);

  @override
  IzbornaLista newEntity() => IzbornaLista(concept);
}

/// Kandidat
abstract class KandidatGen extends Entity<Kandidat> {
  KandidatGen(Concept concept) {
    this.concept = concept;
  }

  String get ime => getAttribute('ime') as String;
  set ime(String value) => setAttribute('ime', value);

  String get prezime => getAttribute('prezime') as String;
  set prezime(String value) => setAttribute('prezime', value);

  DateTime get datumRodjenja => getAttribute('datumRodjenja') as DateTime;
  set datumRodjenja(DateTime value) => setAttribute('datumRodjenja', value);

  String get jmbg => getAttribute('jmbg') as String;
  set jmbg(String value) => setAttribute('jmbg', value);

  String get zanimanje => getAttribute('zanimanje') as String;
  set zanimanje(String value) => setAttribute('zanimanje', value);

  String get prebivaliste => getAttribute('prebivaliste') as String;
  set prebivaliste(String value) => setAttribute('prebivaliste', value);

  int get pozicijaNaListi => getAttribute('pozicijaNaListi') as int;
  set pozicijaNaListi(int value) => setAttribute('pozicijaNaListi', value);

  bool get nosilacListe => getAttribute('nosilacListe') as bool? ?? false;
  set nosilacListe(bool value) => setAttribute('nosilacListe', value);

  String? get biografija => getAttribute('biografija') as String?;
  set biografija(String? value) => setAttribute('biografija', value);

  PolitickaStranka get stranka =>
      getParent(SerbianElectionModel.STRANKA) as PolitickaStranka;
  set stranka(PolitickaStranka value) =>
      setParent(SerbianElectionModel.STRANKA, value);

  IzbornaLista get izbornaLista =>
      getParent(SerbianElectionModel.IZBORNA_LISTA_REL) as IzbornaLista;
  set izbornaLista(IzbornaLista value) =>
      setParent(SerbianElectionModel.IZBORNA_LISTA_REL, value);

  @override
  Kandidat newEntity() => Kandidat(concept);

  @override
  Kandidati newEntities() => Kandidati(concept);
}

abstract class KandidatiGen extends Entities<Kandidat> {
  KandidatiGen(Concept concept) {
    this.concept = concept;
  }

  @override
  Kandidati newEntities() => Kandidati(concept);

  @override
  Kandidat newEntity() => Kandidat(concept);
}

/// Izborna jedinica
abstract class IzbornaJedinicaGen extends Entity<IzbornaJedinica> {
  IzbornaJedinicaGen(Concept concept) {
    this.concept = concept;
  }

  String get naziv => getAttribute('naziv') as String;
  set naziv(String value) => setAttribute('naziv', value);

  String get sifra => getAttribute('sifra') as String;
  set sifra(String value) => setAttribute('sifra', value);

  String get nivo => getAttribute('nivo') as String;
  set nivo(String value) => setAttribute('nivo', value);

  int get brojStanovnika => getAttribute('brojStanovnika') as int;
  set brojStanovnika(int value) => setAttribute('brojStanovnika', value);

  int get brojUpisanihBiraca => getAttribute('brojUpisanihBiraca') as int;
  set brojUpisanihBiraca(int value) =>
      setAttribute('brojUpisanihBiraca', value);

  int get brojGlasalih => getAttribute('brojGlasalih') as int? ?? 0;
  set brojGlasalih(int value) => setAttribute('brojGlasalih', value);

  IzbornaJedinica? get nadredjenaJedinica =>
      getParent(SerbianElectionModel.NADREDJENA_JEDINICA) as IzbornaJedinica?;
  set nadredjenaJedinica(IzbornaJedinica? value) {
    if (value != null) {
      setParent(SerbianElectionModel.NADREDJENA_JEDINICA, value);
    }
  }

  @override
  IzbornaJedinica newEntity() => IzbornaJedinica(concept);

  @override
  IzborneJedinice newEntities() => IzborneJedinice(concept);
}

abstract class IzborneJediniceGen extends Entities<IzbornaJedinica> {
  IzborneJediniceGen(Concept concept) {
    this.concept = concept;
  }

  @override
  IzborneJedinice newEntities() => IzborneJedinice(concept);

  @override
  IzbornaJedinica newEntity() => IzbornaJedinica(concept);
}

/// Glas
abstract class GlasGen extends Entity<Glas> {
  GlasGen(Concept concept) {
    this.concept = concept;
  }

  DateTime get datumGlasanja => getAttribute('datumGlasanja') as DateTime;
  set datumGlasanja(DateTime value) => setAttribute('datumGlasanja', value);

  String? get vreme => getAttribute('vreme') as String?;
  set vreme(String? value) => setAttribute('vreme', value);

  Glasac get glasac => getParent(SerbianElectionModel.GLASAC_REL) as Glasac;
  set glasac(Glasac value) => setParent(SerbianElectionModel.GLASAC_REL, value);

  IzbornaLista get izbornaLista =>
      getParent(SerbianElectionModel.IZBORNA_LISTA_REL) as IzbornaLista;
  set izbornaLista(IzbornaLista value) =>
      setParent(SerbianElectionModel.IZBORNA_LISTA_REL, value);

  IzbornaJedinica get birackoMesto =>
      getParent(SerbianElectionModel.BIRACKO_MESTO) as IzbornaJedinica;
  set birackoMesto(IzbornaJedinica value) =>
      setParent(SerbianElectionModel.BIRACKO_MESTO, value);

  @override
  Glas newEntity() => Glas(concept);

  @override
  Glasovi newEntities() => Glasovi(concept);
}

abstract class GlasoviGen extends Entities<Glas> {
  GlasoviGen(Concept concept) {
    this.concept = concept;
  }

  @override
  Glasovi newEntities() => Glasovi(concept);

  @override
  Glas newEntity() => Glas(concept);
}

// Konkretne implementacije entiteta

/// Glasač - implementacija
class Glasac extends GlasacGen {
  Glasac(Concept concept) : super(concept);
}

/// Glasači - kolekcija
class Glasaci extends GlasaciGen {
  Glasaci(Concept concept) : super(concept);
}

/// Politička stranka - implementacija
class PolitickaStranka extends PolitickaStrankaGen {
  PolitickaStranka(Concept concept) : super(concept);
}

/// Političke stranke - kolekcija
class PolitickeStranke extends PolitickeStrankeGen {
  PolitickeStranke(Concept concept) : super(concept);
}

/// Koalicija - implementacija
class Koalicija extends KoalicijaGen {
  Koalicija(Concept concept) : super(concept);
}

/// Koalicije - kolekcija
class Koalicije extends KoalicijeGen {
  Koalicije(Concept concept) : super(concept);
}

/// Izborna lista - implementacija
class IzbornaLista extends IzbornaListaGen {
  IzbornaLista(Concept concept) : super(concept);
}

/// Izborne liste - kolekcija
class IzborneListe extends IzborneListeGen {
  IzborneListe(Concept concept) : super(concept);
}

/// Kandidat - implementacija
class Kandidat extends KandidatGen {
  Kandidat(Concept concept) : super(concept);
}

/// Kandidati - kolekcija
class Kandidati extends KandidatiGen {
  Kandidati(Concept concept) : super(concept);
}

/// Izborna jedinica - implementacija
class IzbornaJedinica extends IzbornaJedinicaGen {
  IzbornaJedinica(Concept concept) : super(concept);
}

/// Izborne jedinice - kolekcija
class IzborneJedinice extends IzborneJediniceGen {
  IzborneJedinice(Concept concept) : super(concept);
}

/// Glas - implementacija
class Glas extends GlasGen {
  Glas(Concept concept) : super(concept);
}

/// Glasovi - kolekcija
class Glasovi extends GlasoviGen {
  Glasovi(Concept concept) : super(concept);
}
