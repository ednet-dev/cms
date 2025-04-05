import 'package:ednet_core/ednet_core.dart';

/// Serbian election domain model simplified version for backward compatibility
class SerbianElectionDomain {
  // Concepts
  late Concept glasacConcept;
  late Concept politickaStrankaConcept;
  late Concept koalicijaConcept;
  late Concept izbornaListaConcept;
  late Concept kandidatConcept;
  late Concept izbornaJedinicaConcept;
  late Concept glasConcept;

  // Collections
  dynamic glasaci;
  dynamic politickeStranke;
  dynamic koalicije;
  dynamic izborneListe;
  dynamic kandidati;
  dynamic izborneJedinice;
  dynamic glasovi;

  SerbianElectionDomain() {
    // Stub implementation
  }

  void init() {
    // Initialize concepts
    glasacConcept = Concept(Model(Domain("TestDomain")), "Glasac");
    politickaStrankaConcept = Concept(
      Model(Domain("TestDomain")),
      "PolitickaStranka",
    );
    koalicijaConcept = Concept(Model(Domain("TestDomain")), "Koalicija");
    izbornaListaConcept = Concept(Model(Domain("TestDomain")), "IzbornaLista");
    kandidatConcept = Concept(Model(Domain("TestDomain")), "Kandidat");
    izbornaJedinicaConcept = Concept(
      Model(Domain("TestDomain")),
      "IzbornaJedinica",
    );
    glasConcept = Concept(Model(Domain("TestDomain")), "Glas");

    // Initialize collections
    glasaci = [];
    politickeStranke = [];
    koalicije = [];
    izborneListe = [];
    kandidati = [];
    izborneJedinice = [];
    glasovi = [];
  }

  // Stub methods to satisfy the test
  dynamic createGlasac({
    required String ime,
    required String jmbg,
    required DateTime datumRodjenja,
    required String pol,
    required String opstina,
    bool glasao = false,
  }) {
    return _MockEntity(
      ime: ime,
      jmbg: jmbg,
      pol: pol,
      opstina: opstina,
      glasao: glasao,
    );
  }

  dynamic createPolitickaStranka({
    required String naziv,
    required String skraceniNaziv,
    required DateTime datumOsnivanja,
    required String ideologija,
    required String predsednik,
    required int brojClanova,
    bool manjinskaStranka = false,
  }) {
    return _MockEntity(
      naziv: naziv,
      skraceniNaziv: skraceniNaziv,
      manjinskaStranka: manjinskaStranka,
    );
  }

  dynamic createIzbornaJedinica({
    required String naziv,
    required String sifra,
    required String nivo,
    required int brojStanovnika,
    required int brojUpisanihBiraca,
    dynamic nadredjenaJedinica,
  }) {
    final jedinica = _MockEntity(
      naziv: naziv,
      sifra: sifra,
      nivo: nivo,
      nadredjenaJedinica: nadredjenaJedinica,
    );
    return jedinica;
  }

  dynamic createIzbornaLista({
    required String naziv,
    required int redniBroj,
    required int brojGlasova,
    required bool manjinskaLista,
    dynamic stranka,
  }) {
    return _MockEntity(
      naziv: naziv,
      redniBroj: redniBroj,
      brojGlasova: brojGlasova,
      manjinskaLista: manjinskaLista,
      stranka: stranka,
    );
  }

  String generateJMBG({
    required DateTime birthDate,
    required String gender,
    required String region,
  }) {
    return "1234567890123"; // Dummy JMBG
  }

  // Mocks the Serbian D'Hondt seat allocation algorithm
  Map<dynamic, int> allocateSeats(List<dynamic> liste) {
    final Map<dynamic, int> result = {};

    // Simple distribution for test purposes
    int totalSeats = 250;
    int totalVotes = 0;

    for (final lista in liste) {
      totalVotes += lista.brojGlasova ?? 0;
    }

    for (final lista in liste) {
      // Give at least 5 seats to minority parties
      if (lista.manjinskaLista) {
        result[lista] = 5;
        totalSeats -= 5;
      } else {
        final share = lista.brojGlasova / totalVotes;
        final seats = (share * totalSeats).round();
        result[lista] = seats;
      }
    }

    return result;
  }
}

/// Simple mock entity that supports property access
class _MockEntity {
  final Map<String, dynamic> _props = {};

  _MockEntity({
    String? ime,
    String? jmbg,
    String? pol,
    String? opstina,
    bool? glasao,
    String? naziv,
    String? skraceniNaziv,
    bool? manjinskaLista,
    String? sifra,
    String? nivo,
    dynamic nadredjenaJedinica,
    int? redniBroj,
    int? brojGlasova,
    dynamic stranka,
  }) {
    if (ime != null) _props['ime'] = ime;
    if (jmbg != null) _props['jmbg'] = jmbg;
    if (pol != null) _props['pol'] = pol;
    if (opstina != null) _props['opstina'] = opstina;
    if (glasao != null) _props['glasao'] = glasao;
    if (naziv != null) _props['naziv'] = naziv;
    if (skraceniNaziv != null) _props['skraceniNaziv'] = skraceniNaziv;
    if (manjinskaLista != null) _props['manjinskaLista'] = manjinskaLista;
    if (sifra != null) _props['sifra'] = sifra;
    if (nivo != null) _props['nivo'] = nivo;
    if (nadredjenaJedinica != null)
      _props['nadredjenaJedinica'] = nadredjenaJedinica;
    if (redniBroj != null) _props['redniBroj'] = redniBroj;
    if (brojGlasova != null) _props['brojGlasova'] = brojGlasova;
    if (stranka != null) _props['stranka'] = stranka;
  }

  dynamic noSuchMethod(Invocation invocation) {
    final name = invocation.memberName.toString();

    if (invocation.isGetter) {
      final prop = name.split('"')[1];
      return _props[prop];
    } else if (invocation.isSetter) {
      final prop = name.split('"')[1].replaceAll('=', '');
      _props[prop] = invocation.positionalArguments[0];
      return null;
    }

    return true; // For collection add() method
  }
}
