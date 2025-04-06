import 'package:ednet_core/ednet_core.dart';

/// The Serbian election model
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
  static const String IZBORI = 'Izbori';
  static const String IZBORNI_ZAKON = 'IzborniZakon';
  static const String IZBORNA_KOMISIJA = 'IzbornaKomisija';
  static const String TIP_IZBORA = 'TipIzbora';
  static const String IZBORNI_SISTEM = 'IzborniSistem';

  // Internal relationship names
  static const String BIRACKO_MESTO = 'birackoMesto';
  static const String CLANICE = 'clanice';
  static const String STRANKA = 'stranka';
  static const String KOALICIJA_REL = 'koalicija';
  static const String IZBORNA_LISTA_REL = 'izbornaLista';
  static const String NADREDJENA_JEDINICA = 'nadredjenaJedinica';
  static const String GLASAC_REL = 'glasac';
  static const String IZBORI_REL = 'izbori';
  static const String IZBORNI_ZAKON_REL = 'izborniZakon';
  static const String IZBORNA_KOMISIJA_REL = 'izbornaKomisija';
  static const String TIP_IZBORA_REL = 'tipIzbora';
  static const String IZBORNI_SISTEM_REL = 'izborniSistem';

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
    Attribute(glasacConcept, 'birackoPrevo')
      ..type = domain.getType('bool')
      ..init = 'true';
    Attribute(glasacConcept, 'dijaspora')
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
    Attribute(politickaStrankaConcept, 'nacionalnaManjina')
      ..type = domain.getType('String');
    Attribute(politickaStrankaConcept, 'registrovana')
      ..type = domain.getType('bool')
      ..init = 'true';

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
    Attribute(koalicijaConcept, 'manjinskaKoalicija')
      ..type = domain.getType('bool')
      ..init = 'false';

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
    Attribute(izbornaListaConcept, 'iznadCenzusa')
      ..type = domain.getType('bool')
      ..init = 'false';
    Attribute(izbornaListaConcept, 'procenatGlasova')
      ..type = domain.getType('double')
      ..init = '0.0';

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
    Attribute(kandidatConcept, 'izabran')
      ..type = domain.getType('bool')
      ..init = 'false';

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
    Attribute(izbornaJedinicaConcept, 'brojMandata')
      ..type = domain.getType('int')
      ..required = true;
    Attribute(izbornaJedinicaConcept, 'izlaznost')
      ..type = domain.getType('double')
      ..init = '0.0';

    model.concepts.add(izbornaJedinicaConcept);

    // === Glas ===
    var glasConcept = Concept(model, GLAS)..entry = true;

    Attribute(glasConcept, 'datumGlasanja')
      ..type = domain.getType('DateTime')
      ..required = true;
    Attribute(glasConcept, 'vreme')..type = domain.getType('String');
    Attribute(glasConcept, 'vazeci')
      ..type = domain.getType('bool')
      ..init = 'true';

    model.concepts.add(glasConcept);

    // === Izbori ===
    var izboriConcept = Concept(model, IZBORI)..entry = true;

    Attribute(izboriConcept, 'naziv')
      ..type = domain.getType('String')
      ..required = true;
    Attribute(izboriConcept, 'datumOdrzavanja')
      ..type = domain.getType('DateTime')
      ..required = true;
    Attribute(izboriConcept, 'redovni')
      ..type = domain.getType('bool')
      ..init = 'true';
    Attribute(izboriConcept, 'datumRaspisivanja')
      ..type = domain.getType('DateTime')
      ..required = true;
    Attribute(izboriConcept, 'nivoVlasti')
      ..type = domain.getType('String')
      ..required = true;
    Attribute(izboriConcept, 'brojUpisanihBiraca')
      ..type = domain.getType('int')
      ..required = true;
    Attribute(izboriConcept, 'brojGlasalih')
      ..type = domain.getType('int')
      ..init = '0';
    Attribute(izboriConcept, 'brojNevazecihListica')
      ..type = domain.getType('int')
      ..init = '0';
    Attribute(izboriConcept, 'izlaznost')
      ..type = domain.getType('double')
      ..init = '0.0';

    model.concepts.add(izboriConcept);

    // === IzborniZakon ===
    var izborniZakonConcept = Concept(model, IZBORNI_ZAKON)..entry = true;

    Attribute(izborniZakonConcept, 'naziv')
      ..type = domain.getType('String')
      ..required = true;
    Attribute(izborniZakonConcept, 'tipZakona')
      ..type = domain.getType('String')
      ..required = true;
    Attribute(izborniZakonConcept, 'datumDonosenja')
      ..type = domain.getType('DateTime')
      ..required = true;
    Attribute(izborniZakonConcept, 'naSnazi')
      ..type = domain.getType('bool')
      ..init = 'true';
    Attribute(izborniZakonConcept, 'opisZakona')
      ..type = domain.getType('String');
    Attribute(izborniZakonConcept, 'cenzus')
      ..type = domain.getType('double')
      ..init = '0.03';
    Attribute(izborniZakonConcept, 'cenzusZaManjine')
      ..type = domain.getType('bool')
      ..init = 'false';
    Attribute(izborniZakonConcept, 'kvoraZene')
      ..type = domain.getType('double')
      ..init = '0.4';
    Attribute(izborniZakonConcept, 'nivoVlasti')
      ..type = domain.getType('String')
      ..required = true;

    model.concepts.add(izborniZakonConcept);

    // === IzbornaKomisija ===
    var izbornaKomisijaConcept = Concept(model, IZBORNA_KOMISIJA)..entry = true;

    Attribute(izbornaKomisijaConcept, 'naziv')
      ..type = domain.getType('String')
      ..required = true;
    Attribute(izbornaKomisijaConcept, 'nivo')
      ..type = domain.getType('String')
      ..required = true;
    Attribute(izbornaKomisijaConcept, 'brojClanova')
      ..type = domain.getType('int')
      ..required = true;
    Attribute(izbornaKomisijaConcept, 'predsednik')
      ..type = domain.getType('String')
      ..required = true;

    model.concepts.add(izbornaKomisijaConcept);

    // === TipIzbora ===
    var tipIzboraConcept = Concept(model, TIP_IZBORA)..entry = true;

    Attribute(tipIzboraConcept, 'naziv')
      ..type = domain.getType('String')
      ..required = true;
    Attribute(tipIzboraConcept, 'opis')..type = domain.getType('String');
    Attribute(tipIzboraConcept, 'nivoVlasti')
      ..type = domain.getType('String')
      ..required = true;
    Attribute(tipIzboraConcept, 'periodMandataGodina')
      ..type = domain.getType('int')
      ..required = true;

    model.concepts.add(tipIzboraConcept);

    // === IzborniSistem ===
    var izborniSistemConcept = Concept(model, IZBORNI_SISTEM)..entry = true;

    Attribute(izborniSistemConcept, 'naziv')
      ..type = domain.getType('String')
      ..required = true;
    Attribute(izborniSistemConcept, 'opis')..type = domain.getType('String');
    Attribute(izborniSistemConcept, 'proporcionalni')
      ..type = domain.getType('bool')
      ..init = 'true';
    Attribute(izborniSistemConcept, 'vecinskiPrvi')
      ..type = domain.getType('bool')
      ..init = 'false';
    Attribute(izborniSistemConcept, 'metoda')
      ..type = domain.getType('String')
      ..init = 'DHont';
    Attribute(izborniSistemConcept, 'nivoVlasti')
      ..type = domain.getType('String')
      ..required = true;
    Attribute(izborniSistemConcept, 'cenzus')
      ..type = domain.getType('double')
      ..init = '0.03';

    model.concepts.add(izborniSistemConcept);

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

    // IzbornaLista -> Izbori
    final izbornaListaToIzboriParent = Parent(
      izbornaListaConcept,
      izboriConcept,
      IZBORI_REL,
    );
    izbornaListaToIzboriParent.required = true;
    izbornaListaConcept.parents.add(izbornaListaToIzboriParent);

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

    // IzbornaJedinica -> Izbori
    final izbornaJedinicaToIzboriParent = Parent(
      izbornaJedinicaConcept,
      izboriConcept,
      IZBORI_REL,
    );
    izbornaJedinicaToIzboriParent.required = true;
    izbornaJedinicaConcept.parents.add(izbornaJedinicaToIzboriParent);

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

    // Glas -> Izbori
    final glasToIzboriParent = Parent(
      glasConcept,
      izboriConcept,
      IZBORI_REL,
    );
    glasToIzboriParent.required = true;
    glasConcept.parents.add(glasToIzboriParent);

    // Izbori -> TipIzbora
    final izboriToTipIzboraParent = Parent(
      izboriConcept,
      tipIzboraConcept,
      TIP_IZBORA_REL,
    );
    izboriToTipIzboraParent.required = true;
    izboriConcept.parents.add(izboriToTipIzboraParent);

    // Izbori -> IzbornaKomisija
    final izboriToIzbornaKomisijaParent = Parent(
      izboriConcept,
      izbornaKomisijaConcept,
      IZBORNA_KOMISIJA_REL,
    );
    izboriToIzbornaKomisijaParent.required = true;
    izboriConcept.parents.add(izboriToIzbornaKomisijaParent);

    // Izbori -> IzborniZakon
    final izboriToIzborZakonParent = Parent(
      izboriConcept,
      izborniZakonConcept,
      IZBORNI_ZAKON_REL,
    );
    izboriToIzborZakonParent.required = true;
    izboriConcept.parents.add(izboriToIzborZakonParent);

    // Izbori -> IzborniSistem
    final izboriToIzborniSistemParent = Parent(
      izboriConcept,
      izborniSistemConcept,
      IZBORNI_SISTEM_REL,
    );
    izboriToIzborniSistemParent.required = true;
    izboriConcept.parents.add(izboriToIzborniSistemParent);

    return model;
  }
}
