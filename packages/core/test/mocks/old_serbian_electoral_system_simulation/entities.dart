part of '../serbian_election.dart';

/// Glasač – birač sa pravom glasa
class Glasac extends Entity<Glasac> {
  Glasac(Concept concept) {
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

  /// Biračko mesto gde je glasač upisan
  IzbornaJedinica? get birackoMesto =>
      getParent('birackoMesto') as IzbornaJedinica?;
  set birackoMesto(IzbornaJedinica? value) {
    if (value != null) {
      setParent('birackoMesto', value);
    }
  }
}

/// Politička stranka koja učestvuje na izborima
class PolitickaStranka extends Entity<PolitickaStranka> {
  PolitickaStranka(Concept concept) {
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
}

/// Koalicija političkih stranaka
class Koalicija extends Entity<Koalicija> {
  Koalicija(Concept concept) {
    this.concept = concept;
  }

  String get naziv => getAttribute('naziv') as String;
  set naziv(String value) => setAttribute('naziv', value);

  DateTime get datumFormiranja => getAttribute('datumFormiranja') as DateTime;
  set datumFormiranja(DateTime value) => setAttribute('datumFormiranja', value);

  String get nosiocKoalicije => getAttribute('nosiocKoalicije') as String;
  set nosiocKoalicije(String value) => setAttribute('nosiocKoalicije', value);

  List<PolitickaStranka> get clanice =>
      getChildren('clanice') as List<PolitickaStranka>;
  set clanice(List<PolitickaStranka> value) => setChildren('clanice', value);
}

/// Izborna lista koja učestvuje na izborima
class IzbornaLista extends Entity<IzbornaLista> {
  IzbornaLista(Concept concept) {
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

  /// Stranka nosilac liste (ako nije koaliciona)
  PolitickaStranka? get stranka => getParent('stranka') as PolitickaStranka?;
  set stranka(PolitickaStranka? value) {
    if (value != null) {
      setParent('stranka', value);
    }
  }

  /// Koalicija nosilac liste (ako je koaliciona)
  Koalicija? get koalicija => getParent('koalicija') as Koalicija?;
  set koalicija(Koalicija? value) {
    if (value != null) {
      setParent('koalicija', value);
    }
  }
}

/// Kandidat na izbornoj listi
class Kandidat extends Entity<Kandidat> {
  Kandidat(Concept concept) {
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

  /// Stranka kojoj kandidat pripada
  PolitickaStranka get stranka => getParent('stranka') as PolitickaStranka;
  set stranka(PolitickaStranka value) => setParent('stranka', value);

  /// Izborna lista na kojoj je kandidat
  IzbornaLista get izbornaLista => getParent('izbornaLista') as IzbornaLista;
  set izbornaLista(IzbornaLista value) => setParent('izbornaLista', value);
}

/// Izborna jedinica (biračko mesto, opština, okrug, region, država)
class IzbornaJedinica extends Entity<IzbornaJedinica> {
  IzbornaJedinica(Concept concept) {
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

  /// Nadređena izborna jedinica
  IzbornaJedinica? get nadredjenaJedinica =>
      getParent('nadredjenaJedinica') as IzbornaJedinica?;
  set nadredjenaJedinica(IzbornaJedinica? value) {
    if (value != null) {
      setParent('nadredjenaJedinica', value);
    }
  }
}

/// Pojedinačni glas birača
class Glas extends Entity<Glas> {
  Glas(Concept concept) {
    this.concept = concept;
  }

  DateTime get datumGlasanja => getAttribute('datumGlasanja') as DateTime;
  set datumGlasanja(DateTime value) => setAttribute('datumGlasanja', value);

  String? get vreme => getAttribute('vreme') as String?;
  set vreme(String? value) => setAttribute('vreme', value);

  /// Glasač koji je glasao
  Glasac get glasac => getParent('glasac') as Glasac;
  set glasac(Glasac value) => setParent('glasac', value);

  /// Izborna lista za koju je glasao
  IzbornaLista get izbornaLista => getParent('izbornaLista') as IzbornaLista;
  set izbornaLista(IzbornaLista value) => setParent('izbornaLista', value);

  /// Biračko mesto gde je glasao
  IzbornaJedinica get birackoMesto =>
      getParent('birackoMesto') as IzbornaJedinica;
  set birackoMesto(IzbornaJedinica value) => setParent('birackoMesto', value);
}
