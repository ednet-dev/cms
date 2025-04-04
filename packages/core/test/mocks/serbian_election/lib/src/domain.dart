import 'dart:math';
import 'package:ednet_core/ednet_core.dart';
import 'model.dart';
import 'entities.dart' hide SerbianElectionEntries;
import 'repository.dart';
import 'dhondt_calculator.dart';

/// Serbian election domain model
class SerbianElectionDomain extends DomainModels {
  final ModelEntries _entries;

  SerbianElectionDomain(Domain domain, ModelEntries entries)
      : _entries = entries,
        super(domain) {
    add(_entries);
  }

  // Helper method to get entries
  SerbianElectionEntries get entries => _entries as SerbianElectionEntries;

  // Entity collections
  Glasaci get glasaci => entries.glasaci;
  PolitickeStranke get politickeStranke => entries.politickeStranke;
  Koalicije get koalicije => entries.koalicije;
  IzborneListe get izborneListe => entries.izborneListe;
  Kandidati get kandidati => entries.kandidati;
  IzborneJedinice get izborneJedinice => entries.izborneJedinice;
  Glasovi get glasovi => entries.glasovi;
  Izboris get izbori => entries.izbori;
  IzborniZakons get izborniZakoni => entries.izborniZakoni;
  IzbornaKomisijas get izborneKomisije => entries.izborneKomisije;
  TipIzboras get tipoviIzbora => entries.tipoviIzbora;
  IzborniSistems get izborniSistemi => entries.izborniSistemi;

  // Factory methods
  Glasac createGlasac({
    required String ime,
    required String jmbg,
    required DateTime datumRodjenja,
    required String pol,
    required String opstina,
    bool glasao = false,
    IzbornaJedinica? birackoMesto,
  }) {
    final glasac = Glasac(glasaci.concept)
      ..ime = ime
      ..jmbg = jmbg
      ..datumRodjenja = datumRodjenja
      ..pol = pol
      ..opstina = opstina
      ..glasao = glasao;

    if (birackoMesto != null) {
      glasac.birackoMesto = birackoMesto;
    }

    glasaci.add(glasac);
    return glasac;
  }

  PolitickaStranka createPolitickaStranka({
    required String naziv,
    required String skraceniNaziv,
    required DateTime datumOsnivanja,
    required String ideologija,
    required String predsednik,
    required int brojClanova,
    bool manjinskaStranka = false,
    String? nacionalnaManjina,
    bool registrovana = true,
  }) {
    final stranka = PolitickaStranka(politickeStranke.concept)
      ..naziv = naziv
      ..skraceniNaziv = skraceniNaziv
      ..datumOsnivanja = datumOsnivanja
      ..ideologija = ideologija
      ..predsednik = predsednik
      ..brojClanova = brojClanova
      ..manjinskaStranka = manjinskaStranka
      ..registrovana = registrovana;

    if (nacionalnaManjina != null) {
      stranka.nacionalnaManjina = nacionalnaManjina;
    }

    politickeStranke.add(stranka);
    return stranka;
  }

  Koalicija createKoalicija({
    required String naziv,
    required DateTime datumFormiranja,
    required String nosiocKoalicije,
    List<PolitickaStranka> clanice = const [],
  }) {
    final koalicija = Koalicija(koalicije.concept)
      ..naziv = naziv
      ..datumFormiranja = datumFormiranja
      ..nosiocKoalicije = nosiocKoalicije;

    koalicije.add(koalicija);

    // Dodavanje članica koalicije
    koalicija.dodajStranke(clanice);

    return koalicija;
  }

  IzbornaLista createIzbornaLista({
    required String naziv,
    required int redniBroj,
    PolitickaStranka? stranka,
    Koalicija? koalicija,
    bool manjinskaLista = false,
  }) {
    final lista = IzbornaLista(izborneListe.concept)
      ..naziv = naziv
      ..redniBroj = redniBroj
      ..manjinskaLista = manjinskaLista;

    if (stranka != null) {
      lista.stranka = stranka;
    }

    if (koalicija != null) {
      lista.koalicija = koalicija;
    }

    izborneListe.add(lista);
    return lista;
  }

  Kandidat createKandidat({
    required String ime,
    required String prezime,
    required DateTime datumRodjenja,
    required String jmbg,
    required String zanimanje,
    required String prebivaliste,
    required int pozicijaNaListi,
    required PolitickaStranka stranka,
    required IzbornaLista izbornaLista,
    bool nosilacListe = false,
    String? biografija,
  }) {
    final kandidat = Kandidat(kandidati.concept)
      ..ime = ime
      ..prezime = prezime
      ..datumRodjenja = datumRodjenja
      ..jmbg = jmbg
      ..zanimanje = zanimanje
      ..prebivaliste = prebivaliste
      ..pozicijaNaListi = pozicijaNaListi
      ..nosilacListe = nosilacListe
      ..stranka = stranka
      ..izbornaLista = izbornaLista;

    if (biografija != null) {
      kandidat.biografija = biografija;
    }

    kandidati.add(kandidat);
    return kandidat;
  }

  IzbornaJedinica createIzbornaJedinica({
    required String naziv,
    required String sifra,
    required String nivo,
    required int brojStanovnika,
    required int brojUpisanihBiraca,
    int brojGlasalih = 0,
    int brojMandata = 0,
    double izlaznost = 0.0,
    IzbornaJedinica? nadredjenaJedinica,
  }) {
    final jedinica = IzbornaJedinica(izborneJedinice.concept)
      ..naziv = naziv
      ..sifra = sifra
      ..nivo = nivo
      ..brojStanovnika = brojStanovnika
      ..brojUpisanihBiraca = brojUpisanihBiraca
      ..brojGlasalih = brojGlasalih
      ..brojMandata = brojMandata
      ..izlaznost = izlaznost;

    if (nadredjenaJedinica != null) {
      jedinica.nadredjenaJedinica = nadredjenaJedinica;
    }

    izborneJedinice.add(jedinica);
    return jedinica;
  }

  Glas createGlas({
    required Glasac glasac,
    required IzbornaLista izbornaLista,
    required DateTime datumGlasanja,
    required IzbornaJedinica birackoMesto,
    String? vreme,
  }) {
    final glas = Glas(glasovi.concept)
      ..glasac = glasac
      ..izbornaLista = izbornaLista
      ..birackoMesto = birackoMesto
      ..datumGlasanja = datumGlasanja;

    if (vreme != null) {
      glas.vreme = vreme;
    }

    glasovi.add(glas);
    return glas;
  }

  /// Generator za JMBG (Jedinstveni matični broj građana)
  String generateJMBG({
    required DateTime birthDate,
    required String gender,
    required int region,
  }) {
    // Dan, mesec i godina rođenja
    String day = birthDate.day.toString().padLeft(2, '0');
    String month = birthDate.month.toString().padLeft(2, '0');
    String year = birthDate.year.toString().substring(1, 3);

    // Pol (kod muškaraca se dodaje 0, kod žena 5 na redni broj dana)
    int genderOffset = gender == 'Muški' ? 0 : 5;
    int dayWithGender = birthDate.day + (genderOffset * 10);
    String dayWithGenderStr = dayWithGender.toString().padLeft(3, '0');

    // Region rođenja
    String regionCode = region.toString().padLeft(2, '0');

    // Slučajan jedinstveni broj
    String uniqueNum =
        (birthDate.millisecondsSinceEpoch % 1000).toString().padLeft(3, '0');

    // Osnova JMBG-a
    String jmbgBase = '$day$month$year$regionCode$uniqueNum';

    // Kontrolna cifra
    int sum = 0;
    for (int i = 0; i < jmbgBase.length; i++) {
      sum += int.parse(jmbgBase[i]) * (7 - i % 7);
    }
    int checksum = 11 - (sum % 11);
    if (checksum > 9) checksum = 0;

    return '$day$month$year$regionCode$uniqueNum$checksum';
  }

  /// Raspodela mandata koristeći D'Hontov metod
  List<IzbornaLista> raspodelaMandataDontovomMetodom(
    List<IzbornaLista> liste,
    int ukupnoMandata, {
    double cenzus = 0.03,
  }) {
    // Kreiranje rezultata lista za D'Hont kalkulator
    final rezultati = <RezultatListe>[];

    // Izračunavanje ukupnog broja validnih glasova
    int ukupnoGlasova = 0;
    for (final lista in liste) {
      ukupnoGlasova += lista.brojGlasova ?? 0;
    }

    // Kreiranje RezultatListe objekata za D'Hont kalkulator
    for (final lista in liste) {
      rezultati.add(
        RezultatListe(
          lista.naziv,
          lista.brojGlasova ?? 0,
          manjinskaLista: lista.manjinskaLista,
        ),
      );
    }

    // Izračunavanje mandata koristeći D'Hont metod
    final kalkulator = DontKalkulator();
    final rezultatiSaMandatima = kalkulator.izracunajMandate(
      rezultati,
      ukupnoMandata,
      cenzus: cenzus,
    );

    // Ažuriranje lista sa brojem mandata
    for (var i = 0; i < liste.length; i++) {
      liste[i].brojMandata = rezultati[i].brojMandata;
    }

    return liste;
  }

  /// Kreira izbore
  Izbori createIzbori({
    required String naziv,
    required DateTime datumOdrzavanja,
    required DateTime datumRaspisivanja,
    required String nivoVlasti,
    required int brojUpisanihBiraca,
    bool redovni = true,
    int brojGlasalih = 0,
    int brojNevazecihListica = 0,
    double izlaznost = 0.0,
    TipIzbora? tipIzbora,
    IzbornaKomisija? izbornaKomisija,
    IzborniZakon? izborniZakon,
    IzborniSistem? izborniSistem,
  }) {
    final izboriObj = Izbori(izbori.concept)
      ..naziv = naziv
      ..datumOdrzavanja = datumOdrzavanja
      ..datumRaspisivanja = datumRaspisivanja
      ..nivoVlasti = nivoVlasti
      ..brojUpisanihBiraca = brojUpisanihBiraca
      ..redovni = redovni
      ..brojGlasalih = brojGlasalih
      ..brojNevazecihListica = brojNevazecihListica
      ..izlaznost = izlaznost;

    if (tipIzbora != null) {
      izboriObj.tipIzbora = tipIzbora;
    }

    if (izbornaKomisija != null) {
      izboriObj.izbornaKomisija = izbornaKomisija;
    }

    if (izborniZakon != null) {
      izboriObj.izborniZakon = izborniZakon;
    }

    if (izborniSistem != null) {
      izboriObj.izborniSistem = izborniSistem;
    }

    izbori.add(izboriObj);
    return izboriObj;
  }

  /// Kreira izborni zakon
  IzborniZakon createIzborniZakon({
    required String naziv,
    required String tipZakona,
    required DateTime datumDonosenja,
    required String nivoVlasti,
    bool naSnazi = true,
    String? opisZakona,
    double cenzus = 0.03,
    bool cenzusZaManjine = false,
    double kvoraZene = 0.4,
  }) {
    // Get the concept directly from the model instead of the collection
    final model = entries.model;
    final izborniZakonConcept =
        model.concepts.singleWhereCode(SerbianElectionModel.IZBORNI_ZAKON);

    if (izborniZakonConcept == null) {
      throw Exception('IzborniZakon concept not found in model');
    }

    final zakon = IzborniZakon(izborniZakonConcept)
      ..naziv = naziv
      ..tipZakona = tipZakona
      ..datumDonosenja = datumDonosenja
      ..nivoVlasti = nivoVlasti
      ..naSnazi = naSnazi
      ..cenzus = cenzus
      ..cenzusZaManjine = cenzusZaManjine
      ..kvoraZene = kvoraZene;

    if (opisZakona != null) {
      zakon.opisZakona = opisZakona;
    }

    izborniZakoni.add(zakon);
    return zakon;
  }

  /// Kreira izbornu komisiju
  IzbornaKomisija createIzbornaKomisija({
    required String naziv,
    required String nivo,
    required int brojClanova,
    required String predsednik,
  }) {
    // Get the concept directly from the model
    final model = entries.model;
    final izbornaKomisijaConcept =
        model.concepts.singleWhereCode(SerbianElectionModel.IZBORNA_KOMISIJA);

    if (izbornaKomisijaConcept == null) {
      throw Exception('IzbornaKomisija concept not found in model');
    }

    final komisija = IzbornaKomisija(izbornaKomisijaConcept)
      ..naziv = naziv
      ..nivo = nivo
      ..brojClanova = brojClanova
      ..predsednik = predsednik;

    izborneKomisije.add(komisija);
    return komisija;
  }

  /// Kreira tip izbora
  TipIzbora createTipIzbora({
    required String naziv,
    required String nivoVlasti,
    required int periodMandataGodina,
    String? opis,
  }) {
    // Get the concept directly from the model
    final model = entries.model;
    final tipIzboraConcept =
        model.concepts.singleWhereCode(SerbianElectionModel.TIP_IZBORA);

    if (tipIzboraConcept == null) {
      throw Exception('TipIzbora concept not found in model');
    }

    final tip = TipIzbora(tipIzboraConcept)
      ..naziv = naziv
      ..nivoVlasti = nivoVlasti
      ..periodMandataGodina = periodMandataGodina;

    if (opis != null) {
      tip.opis = opis;
    }

    tipoviIzbora.add(tip);
    return tip;
  }

  /// Kreira izborni sistem
  IzborniSistem createIzborniSistem({
    required String naziv,
    required String nivoVlasti,
    bool proporcionalni = true,
    bool vecinskiPrvi = false,
    String metoda = 'DHont',
    double cenzus = 0.03,
    String? opis,
  }) {
    // Get the concept directly from the model
    final model = entries.model;
    final izborniSistemConcept =
        model.concepts.singleWhereCode(SerbianElectionModel.IZBORNI_SISTEM);

    if (izborniSistemConcept == null) {
      throw Exception('IzborniSistem concept not found in model');
    }

    final sistem = IzborniSistem(izborniSistemConcept)
      ..naziv = naziv
      ..nivoVlasti = nivoVlasti
      ..proporcionalni = proporcionalni
      ..vecinskiPrvi = vecinskiPrvi
      ..metoda = metoda
      ..cenzus = cenzus;

    if (opis != null) {
      sistem.opis = opis;
    }

    izborniSistemi.add(sistem);
    return sistem;
  }
}
