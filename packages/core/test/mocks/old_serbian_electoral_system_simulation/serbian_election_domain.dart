import 'package:ednet_core/ednet_core.dart';
import 'dart:math';
import 'dhondt_calculator_test.dart';

/// Serbian citizen with voting rights
class SerbianCitizen extends Entity<SerbianCitizen> {
  SerbianCitizen() : super();
}

/// Political party in the Serbian political system
class PoliticalParty extends Entity<PoliticalParty> {
  PoliticalParty() : super();
}

/// Coalition of political parties
class Coalition extends Entity<Coalition> {
  Coalition() : super();
}

/// Electoral list representing party or coalition in elections
class ElectoralList extends Entity<ElectoralList> {
  ElectoralList() : super();
}

/// Candidate for election
class Candidate extends Entity<Candidate> {
  Candidate() : super();
}

/// Electoral unit (polling station, municipality, district)
class ElectoralUnit extends Entity<ElectoralUnit> {
  ElectoralUnit() : super();
}

/// Vote cast by a citizen for an electoral list
class SerbianVote extends Entity<SerbianVote> {
  SerbianVote() : super();
}

/// Generated abstract base classes with Serbian terminology
abstract class GlasacGen extends Entity<Glasac> {
  GlasacGen(Concept concept) {
    this.concept = concept;
  }

  String get ime => getAttribute('ime');
  set ime(String a) => setAttribute('ime', a);

  String get jmbg => getAttribute('jmbg');
  set jmbg(String a) => setAttribute('jmbg', a);

  DateTime get datumRodjenja => getAttribute('datumRodjenja');
  set datumRodjenja(DateTime a) => setAttribute('datumRodjenja', a);

  String get pol => getAttribute('pol');
  set pol(String a) => setAttribute('pol', a);

  String get opstina => getAttribute('opstina');
  set opstina(String a) => setAttribute('opstina', a);

  bool get glasao => getAttribute('glasao');
  set glasao(bool a) => setAttribute('glasao', a);

  Reference get birackoMestoReference => getReference('birackoMesto')!;
  set birackoMestoReference(Reference reference) =>
      setReference('birackoMesto', reference);

  IzbornaJedinica get birackoMesto =>
      getParent('birackoMesto') as IzbornaJedinica;
  set birackoMesto(IzbornaJedinica bm) => setParent('birackoMesto', bm);

  Glasac newEntity() => Glasac(concept);
  Glasaci newEntities() => Glasaci(concept);
}

abstract class GlasaciGen extends Entities<Glasac> {
  GlasaciGen(Concept concept) {
    this.concept = concept;
  }

  Glasaci newEntities() => Glasaci(concept);
  Glasac newEntity() => Glasac(concept);
}

abstract class PolitickaStrankaGen extends Entity<PolitickaStranka> {
  PolitickaStrankaGen(Concept concept) {
    this.concept = concept;
  }

  String get naziv => getAttribute('naziv');
  set naziv(String a) => setAttribute('naziv', a);

  String get skraceniNaziv => getAttribute('skraceniNaziv');
  set skraceniNaziv(String a) => setAttribute('skraceniNaziv', a);

  DateTime get datumOsnivanja => getAttribute('datumOsnivanja');
  set datumOsnivanja(DateTime a) => setAttribute('datumOsnivanja', a);

  String get ideologija => getAttribute('ideologija');
  set ideologija(String a) => setAttribute('ideologija', a);

  bool get manjinskaStranka => getAttribute('manjinskaStranka');
  set manjinskaStranka(bool a) => setAttribute('manjinskaStranka', a);

  String get predsednik => getAttribute('predsednik');
  set predsednik(String a) => setAttribute('predsednik', a);

  int get brojClanova => getAttribute('brojClanova');
  set brojClanova(int a) => setAttribute('brojClanova', a);

  PolitickaStranka newEntity() => PolitickaStranka(concept);
  PolitickeStranke newEntities() => PolitickeStranke(concept);
}

abstract class PolitickeStrankeGen extends Entities<PolitickaStranka> {
  PolitickeStrankeGen(Concept concept) {
    this.concept = concept;
  }

  PolitickeStranke newEntities() => PolitickeStranke(concept);
  PolitickaStranka newEntity() => PolitickaStranka(concept);
}

abstract class IzbornaListaGen extends Entity<IzbornaLista> {
  IzbornaListaGen(Concept concept) {
    this.concept = concept;
  }

  String get naziv => getAttribute('naziv');
  set naziv(String a) => setAttribute('naziv', a);

  int get redniBroj => getAttribute('redniBroj');
  set redniBroj(int a) => setAttribute('redniBroj', a);

  int get brojGlasova => getAttribute('brojGlasova');
  set brojGlasova(int a) => setAttribute('brojGlasova', a);

  int get brojMandata => getAttribute('brojMandata');
  set brojMandata(int a) => setAttribute('brojMandata', a);

  bool get manjinskaLista => getAttribute('manjinskaLista');
  set manjinskaLista(bool a) => setAttribute('manjinskaLista', a);

  Reference get strankaReference => getReference('stranka')!;
  set strankaReference(Reference reference) =>
      setReference('stranka', reference);

  PolitickaStranka get stranka => getParent('stranka') as PolitickaStranka;
  set stranka(PolitickaStranka s) => setParent('stranka', s);

  IzbornaLista newEntity() => IzbornaLista(concept);
  IzborneListe newEntities() => IzborneListe(concept);
}

abstract class IzborneListeGen extends Entities<IzbornaLista> {
  IzborneListeGen(Concept concept) {
    this.concept = concept;
  }

  IzborneListe newEntities() => IzborneListe(concept);
  IzbornaLista newEntity() => IzbornaLista(concept);
}

abstract class IzbornaJedinicaGen extends Entity<IzbornaJedinica> {
  IzbornaJedinicaGen(Concept concept) {
    this.concept = concept;
  }

  String get naziv => getAttribute('naziv');
  set naziv(String a) => setAttribute('naziv', a);

  String get sifra => getAttribute('sifra');
  set sifra(String a) => setAttribute('sifra', a);

  String get nivo => getAttribute('nivo');
  set nivo(String a) => setAttribute('nivo', a);

  int get brojStanovnika => getAttribute('brojStanovnika');
  set brojStanovnika(int a) => setAttribute('brojStanovnika', a);

  int get brojUpisanihBiraca => getAttribute('brojUpisanihBiraca');
  set brojUpisanihBiraca(int a) => setAttribute('brojUpisanihBiraca', a);

  int get brojGlasalih => getAttribute('brojGlasalih');
  set brojGlasalih(int a) => setAttribute('brojGlasalih', a);

  Reference? get nadredjenaJedinicaReference =>
      getReference('nadredjenaJedinica');
  set nadredjenaJedinicaReference(Reference? reference) {
    if (reference != null) {
      setReference('nadredjenaJedinica', reference);
    }
  }

  IzbornaJedinica? get nadredjenaJedinica =>
      getParent('nadredjenaJedinica') as IzbornaJedinica?;
  set nadredjenaJedinica(IzbornaJedinica? nj) {
    if (nj != null) {
      setParent('nadredjenaJedinica', nj);
    }
  }

  IzbornaJedinica newEntity() => IzbornaJedinica(concept);
  IzborneJedinice newEntities() => IzborneJedinice(concept);
}

abstract class IzborneJediniceGen extends Entities<IzbornaJedinica> {
  IzborneJediniceGen(Concept concept) {
    this.concept = concept;
  }

  IzborneJedinice newEntities() => IzborneJedinice(concept);
  IzbornaJedinica newEntity() => IzbornaJedinica(concept);
}

abstract class GlasGen extends Entity<Glas> {
  GlasGen(Concept concept) {
    this.concept = concept;
  }

  DateTime get datumGlasanja => getAttribute('datumGlasanja');
  set datumGlasanja(DateTime a) => setAttribute('datumGlasanja', a);

  String get vreme => getAttribute('vreme');
  set vreme(String a) => setAttribute('vreme', a);

  Reference get glasacReference => getReference('glasac')!;
  set glasacReference(Reference reference) => setReference('glasac', reference);

  Reference get izbornaListaReference => getReference('izbornaLista')!;
  set izbornaListaReference(Reference reference) =>
      setReference('izbornaLista', reference);

  Reference get birackoMestoReference => getReference('birackoMesto')!;
  set birackoMestoReference(Reference reference) =>
      setReference('birackoMesto', reference);

  Glasac get glasac => getParent('glasac') as Glasac;
  set glasac(Glasac g) => setParent('glasac', g);

  IzbornaLista get izbornaLista => getParent('izbornaLista') as IzbornaLista;
  set izbornaLista(IzbornaLista il) => setParent('izbornaLista', il);

  IzbornaJedinica get birackoMesto =>
      getParent('birackoMesto') as IzbornaJedinica;
  set birackoMesto(IzbornaJedinica bm) => setParent('birackoMesto', bm);

  Glas newEntity() => Glas(concept);
  Glasovi newEntities() => Glasovi(concept);
}

abstract class GlasoviGen extends Entities<Glas> {
  GlasoviGen(Concept concept) {
    this.concept = concept;
  }

  Glasovi newEntities() => Glasovi(concept);
  Glas newEntity() => Glas(concept);
}

abstract class KoalicijaGen extends Entity<Koalicija> {
  KoalicijaGen(Concept concept) {
    this.concept = concept;
  }

  String get naziv => getAttribute('naziv');
  set naziv(String a) => setAttribute('naziv', a);

  DateTime get datumFormiranja => getAttribute('datumFormiranja');
  set datumFormiranja(DateTime a) => setAttribute('datumFormiranja', a);

  String get politickiProgram => getAttribute('politickiProgram');
  set politickiProgram(String a) => setAttribute('politickiProgram', a);

  bool get aktivna => getAttribute('aktivna');
  set aktivna(bool a) => setAttribute('aktivna', a);

  Reference get nosiocKoalicijeReference => getReference('nosiocKoalicije')!;
  set nosiocKoalicijeReference(Reference reference) =>
      setReference('nosiocKoalicije', reference);

  PolitickaStranka get nosiocKoalicije =>
      getParent('nosiocKoalicije') as PolitickaStranka;
  set nosiocKoalicije(PolitickaStranka ns) => setParent('nosiocKoalicije', ns);

  Koalicija newEntity() => Koalicija(concept);
  Koalicije newEntities() => Koalicije(concept);
}

abstract class KoalicijeGen extends Entities<Koalicija> {
  KoalicijeGen(Concept concept) {
    this.concept = concept;
  }

  Koalicije newEntities() => Koalicije(concept);
  Koalicija newEntity() => Koalicija(concept);
}

abstract class KandidatGen extends Entity<Kandidat> {
  KandidatGen(Concept concept) {
    this.concept = concept;
  }

  String get ime => getAttribute('ime');
  set ime(String a) => setAttribute('ime', a);

  String get prezime => getAttribute('prezime');
  set prezime(String a) => setAttribute('prezime', a);

  DateTime get datumRodjenja => getAttribute('datumRodjenja');
  set datumRodjenja(DateTime a) => setAttribute('datumRodjenja', a);

  String get jmbg => getAttribute('jmbg');
  set jmbg(String a) => setAttribute('jmbg', a);

  String get zanimanje => getAttribute('zanimanje');
  set zanimanje(String a) => setAttribute('zanimanje', a);

  String get prebivaliste => getAttribute('prebivaliste');
  set prebivaliste(String a) => setAttribute('prebivaliste', a);

  int get pozicijaNaListi => getAttribute('pozicijaNaListi');
  set pozicijaNaListi(int a) => setAttribute('pozicijaNaListi', a);

  bool get nosilacListe => getAttribute('nosilacListe');
  set nosilacListe(bool a) => setAttribute('nosilacListe', a);

  String get biografija => getAttribute('biografija');
  set biografija(String a) => setAttribute('biografija', a);

  Reference get strankaReference => getReference('stranka')!;
  set strankaReference(Reference reference) =>
      setReference('stranka', reference);

  Reference get izbornaListaReference => getReference('izbornaLista')!;
  set izbornaListaReference(Reference reference) =>
      setReference('izbornaLista', reference);

  PolitickaStranka get stranka => getParent('stranka') as PolitickaStranka;
  set stranka(PolitickaStranka s) => setParent('stranka', s);

  IzbornaLista get izbornaLista => getParent('izbornaLista') as IzbornaLista;
  set izbornaLista(IzbornaLista il) => setParent('izbornaLista', il);

  Kandidat newEntity() => Kandidat(concept);
  Kandidati newEntities() => Kandidati(concept);
}

abstract class KandidatiGen extends Entities<Kandidat> {
  KandidatiGen(Concept concept) {
    this.concept = concept;
  }

  Kandidati newEntities() => Kandidati(concept);
  Kandidat newEntity() => Kandidat(concept);
}

// Concrete implementations
class Glasac extends GlasacGen {
  Glasac(Concept concept) : super(concept);
}

class Glasaci extends GlasaciGen {
  Glasaci(Concept concept) : super(concept);
}

class PolitickaStranka extends PolitickaStrankaGen {
  PolitickaStranka(Concept concept) : super(concept);
}

class PolitickeStranke extends PolitickeStrankeGen {
  PolitickeStranke(Concept concept) : super(concept);
}

class IzbornaLista extends IzbornaListaGen {
  IzbornaLista(Concept concept) : super(concept);
}

class IzborneListe extends IzborneListeGen {
  IzborneListe(Concept concept) : super(concept);
}

class IzbornaJedinica extends IzbornaJedinicaGen {
  IzbornaJedinica(Concept concept) : super(concept);
}

class IzborneJedinice extends IzborneJediniceGen {
  IzborneJedinice(Concept concept) : super(concept);
}

class Glas extends GlasGen {
  Glas(Concept concept) : super(concept);
}

class Glasovi extends GlasoviGen {
  Glasovi(Concept concept) : super(concept);
}

class Koalicija extends KoalicijaGen {
  Koalicija(Concept concept) : super(concept);
}

class Koalicije extends KoalicijeGen {
  Koalicije(Concept concept) : super(concept);
}

class Kandidat extends KandidatGen {
  Kandidat(Concept concept) : super(concept);
}

class Kandidati extends KandidatiGen {
  Kandidati(Concept concept) : super(concept);
}

/// Comprehensive domain model for Serbian election simulation
class SerbianElectionDomain extends Domain {
  late Model model;
  late Concept glasacConcept;
  late Concept politickaStrankaConcept;
  late Concept koalicijaConcept;
  late Concept izbornaListaConcept;
  late Concept kandidatConcept;
  late Concept izbornaJedinicaConcept;
  late Concept glasConcept;

  late Glasaci glasaci;
  late PolitickeStranke politickeStranke;
  late Koalicije koalicije;
  late IzborneListe izborneListe;
  late Kandidati kandidati;
  late IzborneJedinice izborneJedinice;
  late Glasovi glasovi;

  SerbianElectionDomain() : super('Serbian Election Domain') {
    model = Model(this, 'SerbianElection');
    init();
  }

  void init() {
    // Initialize concepts
    glasacConcept =
        Concept(model, 'Glasac')
          ..code = 'Glasac'
          ..entry = true;
    politickaStrankaConcept =
        Concept(model, 'PolitickaStranka')
          ..code = 'PolitickaStranka'
          ..entry = true;
    koalicijaConcept =
        Concept(model, 'Koalicija')
          ..code = 'Koalicija'
          ..entry = true;
    izbornaListaConcept =
        Concept(model, 'IzbornaLista')
          ..code = 'IzbornaLista'
          ..entry = true;
    kandidatConcept =
        Concept(model, 'Kandidat')
          ..code = 'Kandidat'
          ..entry = true;
    izbornaJedinicaConcept =
        Concept(model, 'IzbornaJedinica')
          ..code = 'IzbornaJedinica'
          ..entry = true;
    glasConcept =
        Concept(model, 'Glas')
          ..code = 'Glas'
          ..entry = true;

    // Initialize entities
    glasaci = Glasaci(glasacConcept);
    politickeStranke = PolitickeStranke(politickaStrankaConcept);
    koalicije = Koalicije(koalicijaConcept);
    izborneListe = IzborneListe(izbornaListaConcept);
    kandidati = Kandidati(kandidatConcept);
    izborneJedinice = IzborneJedinice(izbornaJedinicaConcept);
    glasovi = Glasovi(glasConcept);
  }

  Glasac createGlasac({
    required String ime,
    required String jmbg,
    required DateTime datumRodjenja,
    required String pol,
    required String opstina,
    bool glasao = false,
    IzbornaJedinica? birackoMesto,
  }) {
    final glasac =
        Glasac(glasacConcept)
          ..ime = ime
          ..jmbg = jmbg
          ..datumRodjenja = datumRodjenja
          ..pol = pol
          ..opstina = opstina
          ..glasao = glasao;

    if (birackoMesto != null) {
      glasac.birackoMesto = birackoMesto;
    }

    return glasac;
  }

  PolitickaStranka createPolitickaStranka({
    required String naziv,
    required String skraceniNaziv,
    required DateTime datumOsnivanja,
    required String ideologija,
    required bool manjinskaStranka,
    required String predsednik,
    required int brojClanova,
  }) {
    return PolitickaStranka(politickaStrankaConcept)
      ..naziv = naziv
      ..skraceniNaziv = skraceniNaziv
      ..datumOsnivanja = datumOsnivanja
      ..ideologija = ideologija
      ..manjinskaStranka = manjinskaStranka
      ..predsednik = predsednik
      ..brojClanova = brojClanova;
  }

  IzbornaLista createIzbornaLista({
    required String naziv,
    required int redniBroj,
    int brojGlasova = 0,
    int brojMandata = 0,
    required bool manjinskaLista,
    required PolitickaStranka stranka,
  }) {
    final lista =
        IzbornaLista(izbornaListaConcept)
          ..naziv = naziv
          ..redniBroj = redniBroj
          ..brojGlasova = brojGlasova
          ..brojMandata = brojMandata
          ..manjinskaLista = manjinskaLista
          ..stranka = stranka;

    return lista;
  }

  IzbornaJedinica createIzbornaJedinica({
    required String naziv,
    required String sifra,
    required String nivo,
    required int brojStanovnika,
    required int brojUpisanihBiraca,
    int brojGlasalih = 0,
    IzbornaJedinica? nadredjenaJedinica,
  }) {
    final jedinica =
        IzbornaJedinica(izbornaJedinicaConcept)
          ..naziv = naziv
          ..sifra = sifra
          ..nivo = nivo
          ..brojStanovnika = brojStanovnika
          ..brojUpisanihBiraca = brojUpisanihBiraca
          ..brojGlasalih = brojGlasalih;

    if (nadredjenaJedinica != null) {
      jedinica.nadredjenaJedinica = nadredjenaJedinica;
    }

    return jedinica;
  }

  Glas createGlas({
    required Glasac glasac,
    required IzbornaLista izbornaLista,
    required IzbornaJedinica birackoMesto,
    required DateTime datumGlasanja,
    required String vreme,
  }) {
    return Glas(glasConcept)
      ..glasac = glasac
      ..izbornaLista = izbornaLista
      ..birackoMesto = birackoMesto
      ..datumGlasanja = datumGlasanja
      ..vreme = vreme;
  }

  Map<IzbornaLista, int> allocateSeats(
    List<IzbornaLista> lists, [
    int totalSeats = 250,
  ]) {
    final calculator = DhondtCalculator();
    final partyResults =
        lists
            .map(
              (list) => PartyResult(
                list.naziv,
                list.brojGlasova,
                isMinorityParty: list.manjinskaLista,
              ),
            )
            .toList();

    final results = calculator.calculateSeats(partyResults, totalSeats);
    final allocation = <IzbornaLista, int>{};

    for (var i = 0; i < lists.length; i++) {
      final result = results.firstWhere(
        (r) => r.name == lists[i].naziv,
        orElse: () => PartyResult(lists[i].naziv, lists[i].brojGlasova),
      );
      allocation[lists[i]] = result.seatsWon;
      lists[i].brojMandata = result.seatsWon;
    }

    return allocation;
  }

  String generateJMBG({
    required DateTime birthDate,
    required String gender,
    required String region,
  }) {
    final random = Random();
    final day = birthDate.day.toString().padLeft(2, '0');
    final month = birthDate.month.toString().padLeft(2, '0');
    final year = birthDate.year.toString().substring(1);

    String regionCode;
    switch (region.toLowerCase()) {
      case 'beograd':
        regionCode = '71';
        break;
      case 'novi sad':
        regionCode = '72';
        break;
      default:
        regionCode = '70';
    }

    final genderNum =
        gender.toLowerCase() == 'muški'
            ? random.nextInt(499) + 1
            : random.nextInt(499) + 500;
    final genderStr = genderNum.toString().padLeft(3, '0');

    final partial = '$day$month$year$regionCode$genderStr';

    var sum = 0;
    for (var i = 0; i < 12; i++) {
      final digit = int.parse(partial[i]);
      sum += (7 - i % 6) * digit;
    }

    final checksum = (11 - (sum % 11)) % 11;
    final checksumStr = checksum == 10 ? '0' : checksum.toString();

    return '$partial$checksumStr';
  }

  Koalicija createKoalicija({
    required String naziv,
    required DateTime datumFormiranja,
    required String politickiProgram,
    bool aktivna = true,
    required PolitickaStranka nosiocKoalicije,
  }) {
    return Koalicija(koalicijaConcept)
      ..naziv = naziv
      ..datumFormiranja = datumFormiranja
      ..politickiProgram = politickiProgram
      ..aktivna = aktivna
      ..nosiocKoalicije = nosiocKoalicije;
  }

  Kandidat createKandidat({
    required String ime,
    required String prezime,
    required DateTime datumRodjenja,
    required String jmbg,
    required String zanimanje,
    required String prebivaliste,
    required int pozicijaNaListi,
    required bool nosilacListe,
    required String biografija,
    required PolitickaStranka stranka,
    required IzbornaLista izbornaLista,
  }) {
    return Kandidat(kandidatConcept)
      ..ime = ime
      ..prezime = prezime
      ..datumRodjenja = datumRodjenja
      ..jmbg = jmbg
      ..zanimanje = zanimanje
      ..prebivaliste = prebivaliste
      ..pozicijaNaListi = pozicijaNaListi
      ..nosilacListe = nosilacListe
      ..biografija = biografija
      ..stranka = stranka
      ..izbornaLista = izbornaLista;
  }
}
