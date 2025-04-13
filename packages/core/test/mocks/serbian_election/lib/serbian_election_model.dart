library serbian_election_model;

import 'package:ednet_core/ednet_core.dart';

/// Model koji definiše srpski izborni sistem
class SerbianElectionModel extends Model {
  SerbianElectionModel(Domain domain) : super(domain, 'SerbianElection') {
    createConcepts();
  }

  /// Kreira koncepte modela
  void createConcepts() {
    // Glasac - birač sa pravom glasa
    var glasacConcept = Concept(this, 'Glasac')..entry = true;
    glasacConcept.code = 'Glasac';

    var imeAttr = Attribute(glasacConcept, 'ime')
      ..type = domain.getType('String')
      ..required = true;
    var jmbgAttr = Attribute(glasacConcept, 'jmbg')
      ..type = domain.getType('String')
      ..required = true;
    var datumRodjenjaAttr = Attribute(glasacConcept, 'datumRodjenja')
      ..type = domain.getType('DateTime')
      ..required = true;
    var polAttr = Attribute(glasacConcept, 'pol')
      ..type = domain.getType('String')
      ..required = true;
    var opstinaAttr = Attribute(glasacConcept, 'opstina')
      ..type = domain.getType('String')
      ..required = true;
    var glasaoAttr = Attribute(glasacConcept, 'glasao')
      ..type = domain.getType('bool')
      ..init = 'false';

    concepts.add(glasacConcept);

    // PolitickaStranka - politička stranka koja učestvuje na izborima
    var politickaStrankaConcept = Concept(this, 'PolitickaStranka')
      ..entry = true;
    politickaStrankaConcept.code = 'PolitickaStranka';

    var nazivStrankeAttr = Attribute(politickaStrankaConcept, 'naziv')
      ..type = domain.getType('String')
      ..required = true;
    var skraceniNazivAttr = Attribute(politickaStrankaConcept, 'skraceniNaziv')
      ..type = domain.getType('String')
      ..required = true;
    var datumOsnivanjaAttr =
        Attribute(politickaStrankaConcept, 'datumOsnivanja')
          ..type = domain.getType('DateTime')
          ..required = true;
    var ideologijaAttr = Attribute(politickaStrankaConcept, 'ideologija')
      ..type = domain.getType('String')
      ..required = true;
    var predsednikAttr = Attribute(politickaStrankaConcept, 'predsednik')
      ..type = domain.getType('String')
      ..required = true;
    var brojClanovaAttr = Attribute(politickaStrankaConcept, 'brojClanova')
      ..type = domain.getType('int')
      ..required = true;
    var manjinskaStrankaAttr =
        Attribute(politickaStrankaConcept, 'manjinskaStranka')
          ..type = domain.getType('bool')
          ..init = 'false';

    concepts.add(politickaStrankaConcept);

    // Koalicija - koalicija političkih stranaka
    var koalicijaConcept = Concept(this, 'Koalicija')..entry = true;
    koalicijaConcept.code = 'Koalicija';

    var nazivKoalicijeAttr = Attribute(koalicijaConcept, 'naziv')
      ..type = domain.getType('String')
      ..required = true;
    var datumFormiranjaAttr = Attribute(koalicijaConcept, 'datumFormiranja')
      ..type = domain.getType('DateTime')
      ..required = true;
    var nosiocKoalicijeAttr = Attribute(koalicijaConcept, 'nosiocKoalicije')
      ..type = domain.getType('String')
      ..required = true;

    concepts.add(koalicijaConcept);

    // IzbornaLista - izborna lista koja učestvuje na izborima
    var izbornaListaConcept = Concept(this, 'IzbornaLista')..entry = true;
    izbornaListaConcept.code = 'IzbornaLista';

    var nazivListeAttr = Attribute(izbornaListaConcept, 'naziv')
      ..type = domain.getType('String')
      ..required = true;
    var redniBrojAttr = Attribute(izbornaListaConcept, 'redniBroj')
      ..type = domain.getType('int')
      ..required = true;
    var brojGlasovaAttr = Attribute(izbornaListaConcept, 'brojGlasova')
      ..type = domain.getType('int')
      ..init = '0';
    var brojMandataAttr = Attribute(izbornaListaConcept, 'brojMandata')
      ..type = domain.getType('int')
      ..init = '0';
    var manjinskaListaAttr = Attribute(izbornaListaConcept, 'manjinskaLista')
      ..type = domain.getType('bool')
      ..init = 'false';

    concepts.add(izbornaListaConcept);

    // Kandidat - kandidat na izbornoj listi
    var kandidatConcept = Concept(this, 'Kandidat')..entry = true;
    kandidatConcept.code = 'Kandidat';

    var imeKandidataAttr = Attribute(kandidatConcept, 'ime')
      ..type = domain.getType('String')
      ..required = true;
    var prezimeAttr = Attribute(kandidatConcept, 'prezime')
      ..type = domain.getType('String')
      ..required = true;
    var datumRodjenjaKandidataAttr = Attribute(kandidatConcept, 'datumRodjenja')
      ..type = domain.getType('DateTime')
      ..required = true;
    var jmbgKandidataAttr = Attribute(kandidatConcept, 'jmbg')
      ..type = domain.getType('String')
      ..required = true;
    var zanimanjeAttr = Attribute(kandidatConcept, 'zanimanje')
      ..type = domain.getType('String')
      ..required = true;
    var prebivalisteAttr = Attribute(kandidatConcept, 'prebivaliste')
      ..type = domain.getType('String')
      ..required = true;
    var pozicijaNaListiAttr = Attribute(kandidatConcept, 'pozicijaNaListi')
      ..type = domain.getType('int')
      ..required = true;
    var nosilacListeAttr = Attribute(kandidatConcept, 'nosilacListe')
      ..type = domain.getType('bool')
      ..init = 'false';
    var biografijaAttr = Attribute(kandidatConcept, 'biografija')
      ..type = domain.getType('String');

    concepts.add(kandidatConcept);

    // IzbornaJedinica - izborna jedinica (biračko mesto, opština, okrug, itd.)
    var izbornaJedinicaConcept = Concept(this, 'IzbornaJedinica')..entry = true;
    izbornaJedinicaConcept.code = 'IzbornaJedinica';

    var nazivJediniceAttr = Attribute(izbornaJedinicaConcept, 'naziv')
      ..type = domain.getType('String')
      ..required = true;
    var sifraAttr = Attribute(izbornaJedinicaConcept, 'sifra')
      ..type = domain.getType('String')
      ..required = true;
    var nivoAttr = Attribute(izbornaJedinicaConcept, 'nivo')
      ..type = domain.getType('String')
      ..required = true;
    var brojStanovnikaAttr = Attribute(izbornaJedinicaConcept, 'brojStanovnika')
      ..type = domain.getType('int')
      ..required = true;
    var brojUpisanihBiracaAttr =
        Attribute(izbornaJedinicaConcept, 'brojUpisanihBiraca')
          ..type = domain.getType('int')
          ..required = true;
    var brojGlasalihAttr = Attribute(izbornaJedinicaConcept, 'brojGlasalih')
      ..type = domain.getType('int')
      ..init = '0';

    concepts.add(izbornaJedinicaConcept);

    // Glas - pojedinačni glas birača
    var glasConcept = Concept(this, 'Glas')..entry = true;
    glasConcept.code = 'Glas';

    var datumGlasanjaAttr = Attribute(glasConcept, 'datumGlasanja')
      ..type = domain.getType('DateTime')
      ..required = true;
    var vremeAttr = Attribute(glasConcept, 'vreme')
      ..type = domain.getType('String');

    concepts.add(glasConcept);

    // Relationships
    // Glasac -> IzbornaJedinica (birackoMesto)
    glasacConcept.parents.add(
      Parent(glasacConcept, izbornaJedinicaConcept, 'birackoMesto'),
    );

    // Koalicija -> PolitickeStranke (clanice)
    koalicijaConcept.children.add(
      Child(koalicijaConcept, politickaStrankaConcept, 'clanice'),
    );

    // IzbornaLista -> PolitickaStranka (stranka)
    // IzbornaLista -> Koalicija (koalicija)
    izbornaListaConcept.parents
      ..add(Parent(izbornaListaConcept, politickaStrankaConcept, 'stranka'))
      ..add(Parent(izbornaListaConcept, koalicijaConcept, 'koalicija'));

    // Kandidat -> PolitickaStranka (stranka)
    // Kandidat -> IzbornaLista (izbornaLista)
    kandidatConcept.parents
      ..add(Parent(kandidatConcept, politickaStrankaConcept, 'stranka'))
      ..add(Parent(kandidatConcept, izbornaListaConcept, 'izbornaLista'));

    // IzbornaJedinica -> IzbornaJedinica (nadredjenaJedinica)
    izbornaJedinicaConcept.parents
      ..add(
        Parent(
          izbornaJedinicaConcept,
          izbornaJedinicaConcept,
          'nadredjenaJedinica',
        ),
      );

    // Glas -> Glasac (glasac)
    // Glas -> IzbornaLista (izbornaLista)
    // Glas -> IzbornaJedinica (birackoMesto)
    glasConcept.parents
      ..add(Parent(glasConcept, glasacConcept, 'glasac'))
      ..add(Parent(glasConcept, izbornaListaConcept, 'izbornaLista'))
      ..add(Parent(glasConcept, izbornaJedinicaConcept, 'birackoMesto'));
  }
}

/// YAML definicija srpskog izbornog modela za potrebe generisanja modela
const String serbianElectionModelYaml = '''
model:
  name: SerbianElection
  description: Model srpskog izbornog sistema
  concepts:
    - name: Glasac
      description: Birač sa pravom glasa
      attributes:
        - name: ime
          type: String
          required: true
        - name: jmbg
          type: String
          required: true
        - name: datumRodjenja
          type: DateTime
          required: true
        - name: pol
          type: String
          required: true
        - name: opstina
          type: String
          required: true
        - name: glasao
          type: bool
          init: false
      parents:
        - name: birackoMesto
          concept: IzbornaJedinica
    
    - name: PolitickaStranka
      description: Politička stranka koja učestvuje na izborima
      attributes:
        - name: naziv
          type: String
          required: true
        - name: skraceniNaziv
          type: String
          required: true
        - name: datumOsnivanja
          type: DateTime
          required: true
        - name: ideologija
          type: String
          required: true
        - name: predsednik
          type: String
          required: true
        - name: brojClanova
          type: int
          required: true
        - name: manjinskaStranka
          type: bool
          init: false
    
    - name: Koalicija
      description: Koalicija političkih stranaka
      attributes:
        - name: naziv
          type: String
          required: true
        - name: datumFormiranja
          type: DateTime
          required: true
        - name: nosiocKoalicije
          type: String
          required: true
      children:
        - name: clanice
          concept: PolitickaStranka
    
    - name: IzbornaLista
      description: Izborna lista koja učestvuje na izborima
      attributes:
        - name: naziv
          type: String
          required: true
        - name: redniBroj
          type: int
          required: true
        - name: brojGlasova
          type: int
          init: 0
        - name: brojMandata
          type: int
          init: 0
        - name: manjinskaLista
          type: bool
          init: false
      parents:
        - name: stranka
          concept: PolitickaStranka
        - name: koalicija
          concept: Koalicija
    
    - name: Kandidat
      description: Kandidat na izbornoj listi
      attributes:
        - name: ime
          type: String
          required: true
        - name: prezime
          type: String
          required: true
        - name: datumRodjenja
          type: DateTime
          required: true
        - name: jmbg
          type: String
          required: true
        - name: zanimanje
          type: String
          required: true
        - name: prebivaliste
          type: String
          required: true
        - name: pozicijaNaListi
          type: int
          required: true
        - name: nosilacListe
          type: bool
          init: false
        - name: biografija
          type: String
      parents:
        - name: stranka
          concept: PolitickaStranka
        - name: izbornaLista
          concept: IzbornaLista
    
    - name: IzbornaJedinica
      description: Izborna jedinica (biračko mesto, opština, okrug, itd.)
      attributes:
        - name: naziv
          type: String
          required: true
        - name: sifra
          type: String
          required: true
        - name: nivo
          type: String
          required: true
        - name: brojStanovnika
          type: int
          required: true
        - name: brojUpisanihBiraca
          type: int
          required: true
        - name: brojGlasalih
          type: int
          init: 0
      parents:
        - name: nadredjenaJedinica
          concept: IzbornaJedinica
    
    - name: Glas
      description: Pojedinačni glas birača
      attributes:
        - name: datumGlasanja
          type: DateTime
          required: true
        - name: vreme
          type: String
      parents:
        - name: glasac
          concept: Glasac
        - name: izbornaLista
          concept: IzbornaLista
        - name: birackoMesto
          concept: IzbornaJedinica
''';
