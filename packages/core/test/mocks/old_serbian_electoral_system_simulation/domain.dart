part of 'serbian_election.dart';

class SerbianElectionDomain {
  final Domain domain;
  late Random random;

  // Koncept referencs
  late Concept glasacConcept;
  late Concept politickaStrankaConcept;
  late Concept koalicijaConcept;
  late Concept izbornaListaConcept;
  late Concept kandidatConcept;
  late Concept izbornaJedinicaConcept;
  late Concept glasConcept;

  SerbianElectionDomain(this.domain) {
    random = Random();
  }

  // Helper methods for creating entities
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
    required String predsednik,
    required int brojClanova,
    bool manjinskaStranka = false,
  }) {
    return PolitickaStranka(politickaStrankaConcept)
      ..naziv = naziv
      ..skraceniNaziv = skraceniNaziv
      ..datumOsnivanja = datumOsnivanja
      ..ideologija = ideologija
      ..predsednik = predsednik
      ..brojClanova = brojClanova
      ..manjinskaStranka = manjinskaStranka;
  }

  Koalicija createKoalicija({
    required String naziv,
    required DateTime datumFormiranja,
    required String nosiocKoalicije,
    required List<PolitickaStranka> clanice,
  }) {
    return Koalicija(koalicijaConcept)
      ..naziv = naziv
      ..datumFormiranja = datumFormiranja
      ..nosiocKoalicije = nosiocKoalicije
      ..clanice = clanice;
  }

  IzbornaLista createIzbornaLista({
    required String naziv,
    required int redniBroj,
    PolitickaStranka? stranka,
    Koalicija? koalicija,
    bool manjinskaLista = false,
  }) {
    final lista =
        IzbornaLista(izbornaListaConcept)
          ..naziv = naziv
          ..redniBroj = redniBroj
          ..manjinskaLista = manjinskaLista;

    if (stranka != null) {
      lista.stranka = stranka;
    }
    if (koalicija != null) {
      lista.koalicija = koalicija;
    }

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
    required bool nosilacListe,
    String? biografija,
    required PolitickaStranka stranka,
    required IzbornaLista izbornaLista,
  }) {
    final kandidat =
        Kandidat(kandidatConcept)
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

    return kandidat;
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
    required DateTime datumGlasanja,
    required IzbornaJedinica birackoMesto,
    String? vreme,
  }) {
    final glas =
        Glas(glasConcept)
          ..glasac = glasac
          ..izbornaLista = izbornaLista
          ..datumGlasanja = datumGlasanja
          ..birackoMesto = birackoMesto;

    if (vreme != null) {
      glas.vreme = vreme;
    }

    return glas;
  }

  String generateJMBG({
    required DateTime birthDate,
    required String gender,
    required int region,
  }) {
    // Format JMBG-a: DD MM GGG RR BBB K
    // DD - dan rođenja
    // MM - mesec rođenja
    // GGG - zadnje 3 cifre godine
    // RR - regionalni kod
    // BBB - jedinstveni broj rođenja (000-499 za muškarce, 500-999 za žene)
    // K - kontrolni broj

    String dd = birthDate.day.toString().padLeft(2, '0');
    String mm = birthDate.month.toString().padLeft(2, '0');
    String ggg = birthDate.year.toString().substring(1);
    String rr = region.toString().padLeft(2, '0');

    // Generiši nasumični broj rođenja po polu
    int bbb =
        gender == 'Muški'
            ? random.nextInt(500) // 000-499 za muškarce
            : 500 + random.nextInt(500); // 500-999 za žene
    String bbbStr = bbb.toString().padLeft(3, '0');

    String jmbgBezKontrole = '$dd$mm$ggg$rr$bbbStr';

    // Izračunaj kontrolni broj
    int suma = 0;
    for (int i = 0; i < 12; i++) {
      int cifra = int.parse(jmbgBezKontrole[i]);
      suma += (7 - i) * cifra;
    }
    int k = 11 - (suma % 11);
    if (k == 11) k = 0;
    if (k == 10) {
      // Ako je k 10, broj je nevažeći, pokušajmo ponovo sa drugim brojem rođenja
      return generateJMBG(birthDate: birthDate, gender: gender, region: region);
    }

    return '$jmbgBezKontrole$k';
  }
}
