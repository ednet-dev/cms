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
      } else if (concept.code == SerbianElectionModel.IZBORI) {
        entries[concept.code] = Izboris(concept);
      } else if (concept.code == SerbianElectionModel.IZBORNI_ZAKON) {
        entries[concept.code] = IzborniZakons(concept);
      } else if (concept.code == SerbianElectionModel.IZBORNA_KOMISIJA) {
        entries[concept.code] = IzbornaKomisijas(concept);
      } else if (concept.code == SerbianElectionModel.TIP_IZBORA) {
        entries[concept.code] = TipIzboras(concept);
      } else if (concept.code == SerbianElectionModel.IZBORNI_SISTEM) {
        entries[concept.code] = IzborniSistems(concept);
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

    if (concept.code == SerbianElectionModel.IZBORI) {
      return Izboris(concept);
    }

    if (concept.code == SerbianElectionModel.IZBORNI_ZAKON) {
      return IzborniZakons(concept);
    }

    if (concept.code == SerbianElectionModel.IZBORNA_KOMISIJA) {
      return IzbornaKomisijas(concept);
    }

    if (concept.code == SerbianElectionModel.TIP_IZBORA) {
      return TipIzboras(concept);
    }

    if (concept.code == SerbianElectionModel.IZBORNI_SISTEM) {
      return IzborniSistems(concept);
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

    if (concept.code == SerbianElectionModel.IZBORI) {
      return Izbori(concept);
    }

    if (concept.code == SerbianElectionModel.IZBORNI_ZAKON) {
      return IzborniZakon(concept);
    }

    if (concept.code == SerbianElectionModel.IZBORNA_KOMISIJA) {
      return IzbornaKomisija(concept);
    }

    if (concept.code == SerbianElectionModel.TIP_IZBORA) {
      return TipIzbora(concept);
    }

    if (concept.code == SerbianElectionModel.IZBORNI_SISTEM) {
      return IzborniSistem(concept);
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
  Izboris get izbori => getEntry(SerbianElectionModel.IZBORI) as Izboris;
  IzborniZakons get izborniZakoni =>
      getEntry(SerbianElectionModel.IZBORNI_ZAKON) as IzborniZakons;
  IzbornaKomisijas get izborneKomisije =>
      getEntry(SerbianElectionModel.IZBORNA_KOMISIJA) as IzbornaKomisijas;
  TipIzboras get tipoviIzbora =>
      getEntry(SerbianElectionModel.TIP_IZBORA) as TipIzboras;
  IzborniSistems get izborniSistemi =>
      getEntry(SerbianElectionModel.IZBORNI_SISTEM) as IzborniSistems;
}

//====================================================================
// ENTITY IMPLEMENTATIONS
//====================================================================

/// Glasač - birač sa pravom glasa
/// Glasac entity represents a voter in the Serbian electoral system
/// Glasac entity predstavlja birača u srpskom izbornom sistemu
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

  bool get birackoPrevo => getAttribute('birackoPrevo') as bool? ?? false;
  set birackoPrevo(bool pravo) => setAttribute('birackoPrevo', pravo);

  bool get dijaspora => getAttribute('dijaspora') as bool? ?? false;
  set dijaspora(bool dijaspora) => setAttribute('dijaspora', dijaspora);

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

/// Glasači - kolekcija
/// Glasaci represents a collection of Glasac entities
/// Glasaci predstavlja kolekciju entiteta Glasac
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
/// PolitickaStranka entity represents a political party in Serbia
/// PolitickaStranka entity predstavlja političku stranku u Srbiji
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

  String? get nacionalnaManjina => getAttribute('nacionalnaManjina') as String?;
  set nacionalnaManjina(String? nacionalnaManjina) =>
      setAttribute('nacionalnaManjina', nacionalnaManjina);

  bool get registrovana => getAttribute('registrovana') as bool? ?? false;
  set registrovana(bool registrovana) =>
      setAttribute('registrovana', registrovana);

  @override
  PolitickaStranka newEntity() => PolitickaStranka(concept);

  @override
  PolitickeStranke newEntities() => PolitickeStranke(concept);
}

/// Političke stranke - kolekcija
/// PolitickeStranke represents a collection of PolitickaStranka entities
/// PolitickeStranke predstavlja kolekciju entiteta PolitickaStranka
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
/// Koalicija entity represents a coalition of political parties
/// Koalicija entity predstavlja koaliciju političkih stranaka
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

/// Koalicije - kolekcija
/// Koalicije represents a collection of Koalicija entities
/// Koalicije predstavlja kolekciju entiteta Koalicija
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
/// IzbornaLista entity represents an electoral list submitted for an election
/// IzbornaLista entity predstavlja izbornu listu prijavljenu za izbore
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

/// Izborne liste - kolekcija
/// IzborneListe represents a collection of IzbornaLista entities
/// IzborneListe predstavlja kolekciju entiteta IzbornaLista
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
/// Kandidat entity represents a candidate on an electoral list
/// Kandidat entity predstavlja kandidata na izbornoj listi
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

/// Kandidati - kolekcija
/// Kandidati represents a collection of Kandidat entities
/// Kandidati predstavlja kolekciju entiteta Kandidat
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
/// IzbornaJedinica entity represents an electoral unit in Serbia
/// IzbornaJedinica entity predstavlja izbornu jedinicu u Srbiji
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

  int get brojMandata => getAttribute('brojMandata') as int;
  set brojMandata(int value) => setAttribute('brojMandata', value);

  double get izlaznost => getAttribute('izlaznost') as double;
  set izlaznost(double value) => setAttribute('izlaznost', value);

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

/// Izborne jedinice - kolekcija
/// IzborneJedinice represents a collection of IzbornaJedinica entities
/// IzborneJedinice predstavlja kolekciju entiteta IzbornaJedinica
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
/// Glas entity represents a vote in an election
/// Glas entity predstavlja glas na izborima
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

/// Glasovi - kolekcija
/// Glasovi represents a collection of Glas entities
/// Glasovi predstavlja kolekciju entiteta Glas
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
/// Glasac entity represents a voter in the Serbian electoral system
/// Glasac entity predstavlja birača u srpskom izbornom sistemu
class Glasac extends GlasacGen {
  Glasac(Concept concept) : super(concept);
}

/// Glasači - kolekcija
/// Glasaci represents a collection of Glasac entities
/// Glasaci predstavlja kolekciju entiteta Glasac
class Glasaci extends GlasaciGen {
  Glasaci(Concept concept) : super(concept);
}

/// Politička stranka - implementacija
/// PolitickaStranka entity represents a political party in Serbia
/// PolitickaStranka entity predstavlja političku stranku u Srbiji
class PolitickaStranka extends PolitickaStrankaGen {
  PolitickaStranka(Concept concept) : super(concept);
}

/// Političke stranke - kolekcija
/// PolitickeStranke represents a collection of PolitickaStranka entities
/// PolitickeStranke predstavlja kolekciju entiteta PolitickaStranka
class PolitickeStranke extends PolitickeStrankeGen {
  PolitickeStranke(Concept concept) : super(concept);
}

/// Koalicija - implementacija
/// Koalicija entity represents a coalition of political parties
/// Koalicija entity predstavlja koaliciju političkih stranaka
class Koalicija extends KoalicijaGen {
  Koalicija(Concept concept) : super(concept);
}

/// Koalicije - kolekcija
/// Koalicije represents a collection of Koalicija entities
/// Koalicije predstavlja kolekciju entiteta Koalicija
class Koalicije extends KoalicijeGen {
  Koalicije(Concept concept) : super(concept);
}

/// Izborna lista - implementacija
/// IzbornaLista entity represents an electoral list submitted for an election
/// IzbornaLista entity predstavlja izbornu listu prijavljenu za izbore
class IzbornaLista extends IzbornaListaGen {
  IzbornaLista(Concept concept) : super(concept);
}

/// Izborne liste - kolekcija
/// IzborneListe represents a collection of IzbornaLista entities
/// IzborneListe predstavlja kolekciju entiteta IzbornaLista
class IzborneListe extends IzborneListeGen {
  IzborneListe(Concept concept) : super(concept);
}

/// Kandidat - implementacija
/// Kandidat entity represents a candidate on an electoral list
/// Kandidat entity predstavlja kandidata na izbornoj listi
class Kandidat extends KandidatGen {
  Kandidat(Concept concept) : super(concept);
}

/// Kandidati - kolekcija
/// Kandidati represents a collection of Kandidat entities
/// Kandidati predstavlja kolekciju entiteta Kandidat
class Kandidati extends KandidatiGen {
  Kandidati(Concept concept) : super(concept);
}

/// Izborna jedinica - implementacija
/// IzbornaJedinica entity represents an electoral unit in Serbia
/// IzbornaJedinica entity predstavlja izbornu jedinicu u Srbiji
class IzbornaJedinica extends IzbornaJedinicaGen {
  IzbornaJedinica(Concept concept) : super(concept);
}

/// Izborne jedinice - kolekcija
/// IzborneJedinice represents a collection of IzbornaJedinica entities
/// IzborneJedinice predstavlja kolekciju entiteta IzbornaJedinica
class IzborneJedinice extends IzborneJediniceGen {
  IzborneJedinice(Concept concept) : super(concept);
}

/// Glas - implementacija
/// Glas entity represents a vote in an election
/// Glas entity predstavlja glas na izborima
class Glas extends GlasGen {
  Glas(Concept concept) : super(concept);
}

/// Glasovi - kolekcija
/// Glasovi represents a collection of Glas entities
/// Glasovi predstavlja kolekciju entiteta Glas
class Glasovi extends GlasoviGen {
  Glasovi(Concept concept) : super(concept);
}

/// Izbori - generička klasa
/// Izbori entity represents an election in Serbia
/// Izbori entity predstavlja izbore u Srbiji
abstract class IzboriGen extends Entity<Izbori> {
  IzboriGen(Concept concept) {
    if (concept.code != SerbianElectionModel.IZBORI) {
      throw Exception(
          'Izbori entity requires ${SerbianElectionModel.IZBORI} concept');
    }
    this.concept = concept;
  }

  String get naziv => getAttribute('naziv') as String;
  set naziv(String value) => setAttribute('naziv', value);

  DateTime get datumOdrzavanja => getAttribute('datumOdrzavanja') as DateTime;
  set datumOdrzavanja(DateTime value) => setAttribute('datumOdrzavanja', value);

  bool get redovni => getAttribute('redovni') as bool? ?? true;
  set redovni(bool value) => setAttribute('redovni', value);

  DateTime get datumRaspisivanja =>
      getAttribute('datumRaspisivanja') as DateTime;
  set datumRaspisivanja(DateTime value) =>
      setAttribute('datumRaspisivanja', value);

  String get nivoVlasti => getAttribute('nivoVlasti') as String;
  set nivoVlasti(String value) => setAttribute('nivoVlasti', value);

  int get brojUpisanihBiraca => getAttribute('brojUpisanihBiraca') as int;
  set brojUpisanihBiraca(int value) =>
      setAttribute('brojUpisanihBiraca', value);

  int get brojGlasalih => getAttribute('brojGlasalih') as int? ?? 0;
  set brojGlasalih(int value) => setAttribute('brojGlasalih', value);

  int get brojNevazecihListica =>
      getAttribute('brojNevazecihListica') as int? ?? 0;
  set brojNevazecihListica(int value) =>
      setAttribute('brojNevazecihListica', value);

  double get izlaznost => getAttribute('izlaznost') as double? ?? 0.0;
  set izlaznost(double value) => setAttribute('izlaznost', value);

  TipIzbora? get tipIzbora =>
      getParent(SerbianElectionModel.TIP_IZBORA_REL) as TipIzbora?;
  set tipIzbora(TipIzbora? value) =>
      setParent(SerbianElectionModel.TIP_IZBORA_REL, value);

  IzbornaKomisija? get izbornaKomisija =>
      getParent(SerbianElectionModel.IZBORNA_KOMISIJA_REL) as IzbornaKomisija?;
  set izbornaKomisija(IzbornaKomisija? value) =>
      setParent(SerbianElectionModel.IZBORNA_KOMISIJA_REL, value);

  IzborniZakon? get izborniZakon =>
      getParent(SerbianElectionModel.IZBORNI_ZAKON_REL) as IzborniZakon?;
  set izborniZakon(IzborniZakon? value) =>
      setParent(SerbianElectionModel.IZBORNI_ZAKON_REL, value);

  IzborniSistem? get izborniSistem =>
      getParent(SerbianElectionModel.IZBORNI_SISTEM_REL) as IzborniSistem?;
  set izborniSistem(IzborniSistem? value) =>
      setParent(SerbianElectionModel.IZBORNI_SISTEM_REL, value);
}

/// Izbori - kolekcija generička klasa
/// Izboris represents a collection of Izbori entities
/// Izboris predstavlja kolekciju entiteta Izbori
abstract class IzborisGen extends Entities<Izbori> {
  IzborisGen(Concept concept) {
    if (concept.code != SerbianElectionModel.IZBORI) {
      throw Exception(
          'Izboris requires ${SerbianElectionModel.IZBORI} concept');
    }
    this.concept = concept;
  }
}

/// IzborniZakon - generička klasa
/// IzborniZakon entity represents an electoral law in Serbia
/// IzborniZakon entity predstavlja izborni zakon u Srbiji
abstract class IzborniZakonGen extends Entity<IzborniZakon> {
  IzborniZakonGen(Concept concept) {
    if (concept.code != SerbianElectionModel.IZBORNI_ZAKON) {
      throw Exception(
          'IzborniZakon entity requires ${SerbianElectionModel.IZBORNI_ZAKON} concept');
    }
    this.concept = concept;
  }

  String get naziv => getAttribute('naziv') as String;
  set naziv(String value) => setAttribute('naziv', value);

  String get tipZakona => getAttribute('tipZakona') as String;
  set tipZakona(String value) => setAttribute('tipZakona', value);

  DateTime get datumDonosenja => getAttribute('datumDonosenja') as DateTime;
  set datumDonosenja(DateTime value) => setAttribute('datumDonosenja', value);

  bool get naSnazi => getAttribute('naSnazi') as bool? ?? true;
  set naSnazi(bool value) => setAttribute('naSnazi', value);

  String? get opisZakona => getAttribute('opisZakona') as String?;
  set opisZakona(String? value) => setAttribute('opisZakona', value);

  double get cenzus => getAttribute('cenzus') as double? ?? 0.03;
  set cenzus(double value) => setAttribute('cenzus', value);

  bool get cenzusZaManjine => getAttribute('cenzusZaManjine') as bool? ?? false;
  set cenzusZaManjine(bool value) => setAttribute('cenzusZaManjine', value);

  double get kvoraZene => getAttribute('kvoraZene') as double? ?? 0.4;
  set kvoraZene(double value) => setAttribute('kvoraZene', value);

  String get nivoVlasti => getAttribute('nivoVlasti') as String;
  set nivoVlasti(String value) => setAttribute('nivoVlasti', value);
}

/// IzborniZakoni - kolekcija generička klasa
/// IzborniZakons represents a collection of IzborniZakon entities
/// IzborniZakons predstavlja kolekciju entiteta IzborniZakon
abstract class IzborniZakonsGen extends Entities<IzborniZakon> {
  IzborniZakonsGen(Concept concept) {
    if (concept.code != SerbianElectionModel.IZBORNI_ZAKON) {
      throw Exception(
          'IzborniZakons requires ${SerbianElectionModel.IZBORNI_ZAKON} concept');
    }
    this.concept = concept;
  }
}

/// IzbornaKomisija - generička klasa
/// IzbornaKomisija entity represents an electoral commission in Serbia
/// IzbornaKomisija entity predstavlja izbornu komisiju u Srbiji
abstract class IzbornaKomisijaGen extends Entity<IzbornaKomisija> {
  IzbornaKomisijaGen(Concept concept) {
    if (concept.code != SerbianElectionModel.IZBORNA_KOMISIJA) {
      throw Exception(
          'IzbornaKomisija entity requires ${SerbianElectionModel.IZBORNA_KOMISIJA} concept');
    }
    this.concept = concept;
  }

  String get naziv => getAttribute('naziv') as String;
  set naziv(String value) => setAttribute('naziv', value);

  String get nivo => getAttribute('nivo') as String;
  set nivo(String value) => setAttribute('nivo', value);

  int get brojClanova => getAttribute('brojClanova') as int;
  set brojClanova(int value) => setAttribute('brojClanova', value);

  String get predsednik => getAttribute('predsednik') as String;
  set predsednik(String value) => setAttribute('predsednik', value);
}

/// IzborneKomisije - kolekcija generička klasa
/// IzbornaKomisijas represents a collection of IzbornaKomisija entities
/// IzbornaKomisijas predstavlja kolekciju entiteta IzbornaKomisija
abstract class IzbornaKomisijasGen extends Entities<IzbornaKomisija> {
  IzbornaKomisijasGen(Concept concept) {
    if (concept.code != SerbianElectionModel.IZBORNA_KOMISIJA) {
      throw Exception(
          'IzbornaKomisijas requires ${SerbianElectionModel.IZBORNA_KOMISIJA} concept');
    }
    this.concept = concept;
  }
}

/// TipIzbora - generička klasa
/// TipIzbora entity represents a type of election in Serbia
/// TipIzbora entity predstavlja tip izbora u Srbiji
abstract class TipIzboraGen extends Entity<TipIzbora> {
  TipIzboraGen(Concept concept) {
    if (concept.code != SerbianElectionModel.TIP_IZBORA) {
      throw Exception(
          'TipIzbora entity requires ${SerbianElectionModel.TIP_IZBORA} concept');
    }
    this.concept = concept;
  }

  String get naziv => getAttribute('naziv') as String;
  set naziv(String value) => setAttribute('naziv', value);

  String? get opis => getAttribute('opis') as String?;
  set opis(String? value) => setAttribute('opis', value);

  String get nivoVlasti => getAttribute('nivoVlasti') as String;
  set nivoVlasti(String value) => setAttribute('nivoVlasti', value);

  int get periodMandataGodina => getAttribute('periodMandataGodina') as int;
  set periodMandataGodina(int value) =>
      setAttribute('periodMandataGodina', value);
}

/// TipoviIzbora - kolekcija generička klasa
/// TipIzboras represents a collection of TipIzbora entities
/// TipIzboras predstavlja kolekciju entiteta TipIzbora
abstract class TipIzborasGen extends Entities<TipIzbora> {
  TipIzborasGen(Concept concept) {
    if (concept.code != SerbianElectionModel.TIP_IZBORA) {
      throw Exception(
          'TipIzboras requires ${SerbianElectionModel.TIP_IZBORA} concept');
    }
    this.concept = concept;
  }
}

/// IzborniSistem - generička klasa
/// IzborniSistem entity represents an electoral system in Serbia
/// IzborniSistem entity predstavlja izborni sistem u Srbiji
abstract class IzborniSistemGen extends Entity<IzborniSistem> {
  IzborniSistemGen(Concept concept) {
    if (concept.code != SerbianElectionModel.IZBORNI_SISTEM) {
      throw Exception(
          'IzborniSistem entity requires ${SerbianElectionModel.IZBORNI_SISTEM} concept');
    }
    this.concept = concept;
  }

  String get naziv => getAttribute('naziv') as String;
  set naziv(String value) => setAttribute('naziv', value);

  String? get opis => getAttribute('opis') as String?;
  set opis(String? value) => setAttribute('opis', value);

  bool get proporcionalni => getAttribute('proporcionalni') as bool? ?? true;
  set proporcionalni(bool value) => setAttribute('proporcionalni', value);

  bool get vecinskiPrvi => getAttribute('vecinskiPrvi') as bool? ?? false;
  set vecinskiPrvi(bool value) => setAttribute('vecinskiPrvi', value);

  String get metoda => getAttribute('metoda') as String? ?? 'DHont';
  set metoda(String value) => setAttribute('metoda', value);

  String get nivoVlasti => getAttribute('nivoVlasti') as String;
  set nivoVlasti(String value) => setAttribute('nivoVlasti', value);

  double get cenzus => getAttribute('cenzus') as double? ?? 0.03;
  set cenzus(double value) => setAttribute('cenzus', value);
}

/// IzborniSistemi - kolekcija generička klasa
/// IzborniSistems represents a collection of IzborniSistem entities
/// IzborniSistems predstavlja kolekciju entiteta IzborniSistem
abstract class IzborniSistemsGen extends Entities<IzborniSistem> {
  IzborniSistemsGen(Concept concept) {
    if (concept.code != SerbianElectionModel.IZBORNI_SISTEM) {
      throw Exception(
          'IzborniSistems requires ${SerbianElectionModel.IZBORNI_SISTEM} concept');
    }
    this.concept = concept;
  }
}

/// Izbori - implementacija
/// Izbori entity represents an election in Serbia
/// Izbori entity predstavlja izbore u Srbiji
class Izbori extends IzboriGen {
  Izbori(Concept concept) : super(concept);
}

/// Izbori - kolekcija
/// Izboris represents a collection of Izbori entities
/// Izboris predstavlja kolekciju entiteta Izbori
class Izboris extends IzborisGen {
  Izboris(Concept concept) : super(concept);
}

/// IzborniZakon - implementacija
/// IzborniZakon entity represents an electoral law in Serbia
/// IzborniZakon entity predstavlja izborni zakon u Srbiji
class IzborniZakon extends IzborniZakonGen {
  IzborniZakon(Concept concept) : super(concept);
}

/// IzborniZakoni - kolekcija
/// IzborniZakons represents a collection of IzborniZakon entities
/// IzborniZakons predstavlja kolekciju entiteta IzborniZakon
class IzborniZakons extends IzborniZakonsGen {
  IzborniZakons(Concept concept) : super(concept);
}

/// IzbornaKomisija - implementacija
/// IzbornaKomisija entity represents an electoral commission in Serbia
/// IzbornaKomisija entity predstavlja izbornu komisiju u Srbiji
class IzbornaKomisija extends IzbornaKomisijaGen {
  IzbornaKomisija(Concept concept) : super(concept);
}

/// IzborneKomisije - kolekcija
/// IzbornaKomisijas represents a collection of IzbornaKomisija entities
/// IzbornaKomisijas predstavlja kolekciju entiteta IzbornaKomisija
class IzbornaKomisijas extends IzbornaKomisijasGen {
  IzbornaKomisijas(Concept concept) : super(concept);
}

/// TipIzbora - implementacija
/// TipIzbora entity represents a type of election in Serbia
/// TipIzbora entity predstavlja tip izbora u Srbiji
class TipIzbora extends TipIzboraGen {
  TipIzbora(Concept concept) : super(concept);
}

/// TipoviIzbora - kolekcija
/// TipIzboras represents a collection of TipIzbora entities
/// TipIzboras predstavlja kolekciju entiteta TipIzbora
class TipIzboras extends TipIzborasGen {
  TipIzboras(Concept concept) : super(concept);
}

/// IzborniSistem - implementacija
/// IzborniSistem entity represents an electoral system in Serbia
/// IzborniSistem entity predstavlja izborni sistem u Srbiji
class IzborniSistem extends IzborniSistemGen {
  IzborniSistem(Concept concept) : super(concept);
}

/// IzborniSistemi - kolekcija
/// IzborniSistems represents a collection of IzborniSistem entities
/// IzborniSistems predstavlja kolekciju entiteta IzborniSistem
class IzborniSistems extends IzborniSistemsGen {
  IzborniSistems(Concept concept) : super(concept);
}
