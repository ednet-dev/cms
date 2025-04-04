part of '../serbian_election_core.dart';

class SerbianElectionModel extends Model {
  SerbianElectionModel(Domain domain) : super(domain, 'SerbianElection') {
    // Glasac concept
    var glasacConcept =
        Concept(this, 'Glasac')
          ..entry = true
          ..code = 'Glasac';

    var imeAttr = Attribute(glasacConcept, 'ime')
      ..type = domain.getType('String');
    var jmbgAttr = Attribute(glasacConcept, 'jmbg')
      ..type = domain.getType('String');
    var datumRodjenjaAttr = Attribute(glasacConcept, 'datumRodjenja')
      ..type = domain.getType('DateTime');
    var polAttr = Attribute(glasacConcept, 'pol')
      ..type = domain.getType('String');
    var opstinaAttr = Attribute(glasacConcept, 'opstina')
      ..type = domain.getType('String');

    concepts.add(glasacConcept);

    // PolitickaStranka concept
    var politickaStrankaConcept =
        Concept(this, 'PolitickaStranka')
          ..entry = true
          ..code = 'PolitickaStranka';

    var nazivAttr = Attribute(politickaStrankaConcept, 'naziv')
      ..type = domain.getType('String');
    var skraceniNazivAttr = Attribute(politickaStrankaConcept, 'skraceniNaziv')
      ..type = domain.getType('String');
    var datumOsnivanjaAttr = Attribute(
      politickaStrankaConcept,
      'datumOsnivanja',
    )..type = domain.getType('DateTime');
    var ideologijaAttr = Attribute(politickaStrankaConcept, 'ideologija')
      ..type = domain.getType('String');
    var predsednikAttr = Attribute(politickaStrankaConcept, 'predsednik')
      ..type = domain.getType('String');
    var brojClanovaAttr = Attribute(politickaStrankaConcept, 'brojClanova')
      ..type = domain.getType('int');
    var manjinskaStrankaAttr = Attribute(
      politickaStrankaConcept,
      'manjinskaStranka',
    )..type = domain.getType('bool');

    concepts.add(politickaStrankaConcept);

    // Koalicija concept
    var koalicijaConcept =
        Concept(this, 'Koalicija')
          ..entry = true
          ..code = 'Koalicija';

    var koalicijaNazivAttr = Attribute(koalicijaConcept, 'naziv')
      ..type = domain.getType('String');
    var datumFormiranjaAttr = Attribute(koalicijaConcept, 'datumFormiranja')
      ..type = domain.getType('DateTime');
    var nosiocKoalicijeAttr = Attribute(koalicijaConcept, 'nosiocKoalicije')
      ..type = domain.getType('String');

    concepts.add(koalicijaConcept);

    // IzbornaLista concept
    var izbornaListaConcept =
        Concept(this, 'IzbornaLista')
          ..entry = true
          ..code = 'IzbornaLista';

    var listaNazivAttr = Attribute(izbornaListaConcept, 'naziv')
      ..type = domain.getType('String');
    var redniBrojAttr = Attribute(izbornaListaConcept, 'redniBroj')
      ..type = domain.getType('int');
    var manjinskaListaAttr = Attribute(izbornaListaConcept, 'manjinskaLista')
      ..type = domain.getType('bool');

    concepts.add(izbornaListaConcept);

    // IzbornaJedinica concept
    var izbornaJedinicaConcept =
        Concept(this, 'IzbornaJedinica')
          ..entry = true
          ..code = 'IzbornaJedinica';

    var jedinicaNazivAttr = Attribute(izbornaJedinicaConcept, 'naziv')
      ..type = domain.getType('String');
    var sifraAttr = Attribute(izbornaJedinicaConcept, 'sifra')
      ..type = domain.getType('String');
    var nivoAttr = Attribute(izbornaJedinicaConcept, 'nivo')
      ..type = domain.getType('String');
    var brojStanovnikaAttr = Attribute(izbornaJedinicaConcept, 'brojStanovnika')
      ..type = domain.getType('int');
    var brojUpisanihBiracaAttr = Attribute(
      izbornaJedinicaConcept,
      'brojUpisanihBiraca',
    )..type = domain.getType('int');

    concepts.add(izbornaJedinicaConcept);

    // Glas concept
    var glasConcept =
        Concept(this, 'Glas')
          ..entry = true
          ..code = 'Glas';

    var datumGlasanjaAttr = Attribute(glasConcept, 'datumGlasanja')
      ..type = domain.getType('DateTime');

    concepts.add(glasConcept);

    // Relationships
    glasacConcept.parents..add(Parent(izbornaJedinicaConcept, 'birackoMesto'));

    koalicijaConcept.children..add(Child(politickaStrankaConcept, 'clanice'));

    izbornaListaConcept.parents
      ..add(Parent(politickaStrankaConcept, 'stranka'))
      ..add(Parent(koalicijaConcept, 'koalicija'));

    izbornaJedinicaConcept.parents
      ..add(Parent(izbornaJedinicaConcept, 'nadredjenaJedinica'));

    glasConcept.parents
      ..add(Parent(glasacConcept, 'glasac'))
      ..add(Parent(izbornaListaConcept, 'izbornaLista'))
      ..add(Parent(izbornaJedinicaConcept, 'birackoMesto'));
  }
}
