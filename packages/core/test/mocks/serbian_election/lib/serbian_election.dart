library serbian_election;

import 'package:ednet_core/ednet_core.dart';
import 'dart:math';

// Import entities
import 'gen/entities.dart';

// Parts
part 'repository.dart';
part 'domain.dart';
part 'core/dhondt_calculator.dart';
part 'gen/model_entries.dart';

// The Serbian election model
class SerbianElectionModel {
  static const String MODEL_DOMAIN = 'SerbianElection';

  // Concept codes
  static const String GLASAC = 'Glasac';
  static const String POLITICKA_STRANKA = 'PolitickaStranka';
  static const String KOALICIJA = 'Koalicija';
  static const String IZBORNA_LISTA = 'IzbornaLista';
  static const String KANDIDAT = 'Kandidat';
  static const String IZBORNA_JEDINICA = 'IzbornaJedinica';
  static const String GLAS = 'Glas';

  // Internal relationship names
  static const String BIRACKO_MESTO = 'birackoMesto';
  static const String CLANICE = 'clanice';
  static const String STRANKA = 'stranka';
  static const String KOALICIJA_REL = 'koalicija';
  static const String IZBORNA_LISTA_REL = 'izbornaLista';
  static const String NADREDJENA_JEDINICA = 'nadredjenaJedinica';
  static const String GLASAC_REL = 'glasac';

  // Initialize model
  static Model initModel(Domain domain) {
    final model = Model(domain, MODEL_DOMAIN);

    // === Glasac ===
    var glasacConcept = Concept(model, GLASAC)..entry = true;

    Attribute(glasacConcept, 'ime')
      ..type = domain.getType('String')
      ..required = true;
    Attribute(glasacConcept, 'jmbg')
      ..type = domain.getType('String')
      ..required = true;
    Attribute(glasacConcept, 'datumRodjenja')
      ..type = domain.getType('DateTime')
      ..required = true;
    Attribute(glasacConcept, 'pol')
      ..type = domain.getType('String')
      ..required = true;
    Attribute(glasacConcept, 'opstina')
      ..type = domain.getType('String')
      ..required = true;
    Attribute(glasacConcept, 'glasao')
      ..type = domain.getType('bool')
      ..init = 'false';

    model.concepts.add(glasacConcept);

    // === PolitickaStranka ===
    var politickaStrankaConcept = Concept(model, POLITICKA_STRANKA)
      ..entry = true;

    Attribute(politickaStrankaConcept, 'naziv')
      ..type = domain.getType('String')
      ..required = true;
    Attribute(politickaStrankaConcept, 'skraceniNaziv')
      ..type = domain.getType('String')
      ..required = true;
    Attribute(politickaStrankaConcept, 'datumOsnivanja')
      ..type = domain.getType('DateTime')
      ..required = true;
    Attribute(politickaStrankaConcept, 'ideologija')
      ..type = domain.getType('String')
      ..required = true;
    Attribute(politickaStrankaConcept, 'predsednik')
      ..type = domain.getType('String')
      ..required = true;
    Attribute(politickaStrankaConcept, 'brojClanova')
      ..type = domain.getType('int')
      ..required = true;
    Attribute(politickaStrankaConcept, 'manjinskaStranka')
      ..type = domain.getType('bool')
      ..init = 'false';

    model.concepts.add(politickaStrankaConcept);

    // === Koalicija ===
    var koalicijaConcept = Concept(model, KOALICIJA)..entry = true;

    Attribute(koalicijaConcept, 'naziv')
      ..type = domain.getType('String')
      ..required = true;
    Attribute(koalicijaConcept, 'datumFormiranja')
      ..type = domain.getType('DateTime')
      ..required = true;
    Attribute(koalicijaConcept, 'nosiocKoalicije')
      ..type = domain.getType('String')
      ..required = true;

    model.concepts.add(koalicijaConcept);

    // === IzbornaLista ===
    var izbornaListaConcept = Concept(model, IZBORNA_LISTA)..entry = true;

    Attribute(izbornaListaConcept, 'naziv')
      ..type = domain.getType('String')
      ..required = true;
    Attribute(izbornaListaConcept, 'redniBroj')
      ..type = domain.getType('int')
      ..required = true;
    Attribute(izbornaListaConcept, 'brojGlasova')
      ..type = domain.getType('int')
      ..init = '0';
    Attribute(izbornaListaConcept, 'brojMandata')
      ..type = domain.getType('int')
      ..init = '0';
    Attribute(izbornaListaConcept, 'manjinskaLista')
      ..type = domain.getType('bool')
      ..init = 'false';

    model.concepts.add(izbornaListaConcept);

    // === Kandidat ===
    var kandidatConcept = Concept(model, KANDIDAT)..entry = true;

    Attribute(kandidatConcept, 'ime')
      ..type = domain.getType('String')
      ..required = true;
    Attribute(kandidatConcept, 'prezime')
      ..type = domain.getType('String')
      ..required = true;
    Attribute(kandidatConcept, 'datumRodjenja')
      ..type = domain.getType('DateTime')
      ..required = true;
    Attribute(kandidatConcept, 'jmbg')
      ..type = domain.getType('String')
      ..required = true;
    Attribute(kandidatConcept, 'zanimanje')
      ..type = domain.getType('String')
      ..required = true;
    Attribute(kandidatConcept, 'prebivaliste')
      ..type = domain.getType('String')
      ..required = true;
    Attribute(kandidatConcept, 'pozicijaNaListi')
      ..type = domain.getType('int')
      ..required = true;
    Attribute(kandidatConcept, 'nosilacListe')
      ..type = domain.getType('bool')
      ..init = 'false';
    Attribute(kandidatConcept, 'biografija')..type = domain.getType('String');

    model.concepts.add(kandidatConcept);

    // === IzbornaJedinica ===
    var izbornaJedinicaConcept = Concept(model, IZBORNA_JEDINICA)..entry = true;

    Attribute(izbornaJedinicaConcept, 'naziv')
      ..type = domain.getType('String')
      ..required = true;
    Attribute(izbornaJedinicaConcept, 'sifra')
      ..type = domain.getType('String')
      ..required = true;
    Attribute(izbornaJedinicaConcept, 'nivo')
      ..type = domain.getType('String')
      ..required = true;
    Attribute(izbornaJedinicaConcept, 'brojStanovnika')
      ..type = domain.getType('int')
      ..required = true;
    Attribute(izbornaJedinicaConcept, 'brojUpisanihBiraca')
      ..type = domain.getType('int')
      ..required = true;
    Attribute(izbornaJedinicaConcept, 'brojGlasalih')
      ..type = domain.getType('int')
      ..init = '0';

    model.concepts.add(izbornaJedinicaConcept);

    // === Glas ===
    var glasConcept = Concept(model, GLAS)..entry = true;

    Attribute(glasConcept, 'datumGlasanja')
      ..type = domain.getType('DateTime')
      ..required = true;
    Attribute(glasConcept, 'vreme')..type = domain.getType('String');

    model.concepts.add(glasConcept);

    // === Relationships ===
    // Glasac -> IzbornaJedinica (birackoMesto)
    final glasacParent = Parent(
      glasacConcept,
      izbornaJedinicaConcept,
      BIRACKO_MESTO,
    );
    glasacParent.required = false; // Not required
    glasacConcept.parents.add(glasacParent);

    // Koalicija -> PolitickeStranke (clanice)
    final koalicijaChild = Child(
      koalicijaConcept,
      politickaStrankaConcept,
      CLANICE,
    );
    koalicijaChild.required = false; // Not required
    koalicijaConcept.children.add(koalicijaChild);

    // IzbornaLista -> PolitickaStranka (stranka)
    // IzbornaLista -> Koalicija (koalicija)
    final izbornaListaToStrankaParent = Parent(
      izbornaListaConcept,
      politickaStrankaConcept,
      STRANKA,
    );
    izbornaListaToStrankaParent.required =
        false; // One of these should be present, but not both required
    izbornaListaConcept.parents.add(izbornaListaToStrankaParent);

    final izbornaListaToKoalicijaParent = Parent(
      izbornaListaConcept,
      koalicijaConcept,
      KOALICIJA_REL,
    );
    izbornaListaToKoalicijaParent.required =
        false; // One of these should be present, but not both required
    izbornaListaConcept.parents.add(izbornaListaToKoalicijaParent);

    // Kandidat -> PolitickaStranka (stranka)
    // Kandidat -> IzbornaLista (izbornaLista)
    final kandidatToStrankaParent = Parent(
      kandidatConcept,
      politickaStrankaConcept,
      STRANKA,
    );
    kandidatToStrankaParent.required = false;
    kandidatConcept.parents.add(kandidatToStrankaParent);

    final kandidatToIzbornaListaParent = Parent(
      kandidatConcept,
      izbornaListaConcept,
      IZBORNA_LISTA_REL,
    );
    kandidatToIzbornaListaParent.required = false;
    kandidatConcept.parents.add(kandidatToIzbornaListaParent);

    // IzbornaJedinica -> IzbornaJedinica (nadredjenaJedinica)
    final izbornaJedinicaToIzbornaJedinicaParent = Parent(
      izbornaJedinicaConcept,
      izbornaJedinicaConcept,
      NADREDJENA_JEDINICA,
    );
    izbornaJedinicaToIzbornaJedinicaParent.required =
        false; // Top-level units don't have parent
    izbornaJedinicaConcept.parents.add(izbornaJedinicaToIzbornaJedinicaParent);

    // Glas -> Glasac (glasac)
    // Glas -> IzbornaLista (izbornaLista)
    // Glas -> IzbornaJedinica (birackoMesto)
    final glasToGlasacParent = Parent(glasConcept, glasacConcept, GLASAC_REL);
    glasToGlasacParent.required = true; // This one is required
    glasConcept.parents.add(glasToGlasacParent);

    final glasToIzbornaListaParent = Parent(
      glasConcept,
      izbornaListaConcept,
      IZBORNA_LISTA_REL,
    );
    glasToIzbornaListaParent.required = true; // This one is required
    glasConcept.parents.add(glasToIzbornaListaParent);

    final glasToIzbornaJedinicaParent = Parent(
      glasConcept,
      izbornaJedinicaConcept,
      BIRACKO_MESTO,
    );
    glasToIzbornaJedinicaParent.required = true; // This one is required
    glasConcept.parents.add(glasToIzbornaJedinicaParent);

    return model;
  }
}
