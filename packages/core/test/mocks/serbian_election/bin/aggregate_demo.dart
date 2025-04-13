import '../lib/serbian_election.dart';

/// This demonstration shows how to use the AggregateRoot pattern to ensure
/// proper relationship integrity in the Serbian election model
void main() {
  print('\n=== AGGREGATE ROOT DEMONSTRATION ===\n');

  // Create the repository with the domain model
  final repo = SerbianElectionRepo();
  final domain = repo.getDomainModels(SerbianElectionModel.MODEL_DOMAIN);
  final srbDomain = domain as SerbianElectionDomain;

  // Setup electoral system components
  print('Setting up electoral components...');

  // Create electoral law
  final zakon = srbDomain.createIzborniZakon(
    naziv: 'Zakon o lokalnim izborima',
    tipZakona: 'Lokalni',
    datumDonosenja: DateTime(2022, 2, 1),
    nivoVlasti: 'Opština',
    cenzus: 0.03,
    cenzusZaManjine: true,
  );

  // Create electoral commission
  final komisija = srbDomain.createIzbornaKomisija(
    naziv: 'Opštinska izborna komisija Vračar',
    nivo: 'Opština',
    brojClanova: 15,
    predsednik: 'Milan Petrović',
  );

  // Create electoral system definition
  final sistem = srbDomain.createIzborniSistem(
    naziv: 'Proporcionalni sistem sa D\'Hont metodom',
    nivoVlasti: 'Opština',
    metoda: 'DHont',
    cenzus: 0.03,
  );

  // Create election type
  final tipIzbora = srbDomain.createTipIzbora(
    naziv: 'Lokalni izbori',
    nivoVlasti: 'Opština',
    periodMandataGodina: 4,
  );

  // Create an AGGREGATE ROOT for the election
  // This is the key difference from the previous examples!
  print('\nCreating election as an Aggregate Root...');
  final izboriAggregate = srbDomain.createIzboriAggregate(
    naziv: 'Lokalni izbori Vračar 2022',
    datumOdrzavanja: DateTime(2022, 4, 3),
    datumRaspisivanja: DateTime(2022, 2, 15),
    nivoVlasti: 'Opština',
    brojUpisanihBiraca: 58000,
    tipIzbora: tipIzbora,
    izbornaKomisija: komisija,
    izborniZakon: zakon,
    izborniSistem: sistem,
  );

  // Create electoral unit
  final izbJedinica = srbDomain.createIzbornaJedinica(
    naziv: 'Opština Vračar',
    sifra: 'VR-2022',
    nivo: 'Opština',
    brojStanovnika: 68000,
    brojUpisanihBiraca: 58000,
    brojMandata: 35,
  );

  // Explicitly add the electoral unit to the aggregate
  // This establishes the parent-child relationship automatically
  print('Adding electoral unit to the aggregate...');
  izboriAggregate.addIzbornaJedinica(izbJedinica);

  // Create political parties
  final sns = srbDomain.createPolitickaStranka(
    naziv: 'Srpska napredna stranka',
    skraceniNaziv: 'SNS',
    datumOsnivanja: DateTime(2008, 10, 21),
    ideologija: 'Konzervativizam',
    predsednik: 'Aleksandar Vučić',
    brojClanova: 750000,
  );

  final sps = srbDomain.createPolitickaStranka(
    naziv: 'Socijalistička partija Srbije',
    skraceniNaziv: 'SPS',
    datumOsnivanja: DateTime(1990, 7, 17),
    ideologija: 'Socijalizam',
    predsednik: 'Ivica Dačić',
    brojClanova: 120000,
  );

  final opozicija = srbDomain.createPolitickaStranka(
    naziv: 'Lokalna opozicija Vračar',
    skraceniNaziv: 'LOV',
    datumOsnivanja: DateTime(2020, 3, 15),
    ideologija: 'Liberalizam',
    predsednik: 'Jovana Jovanović',
    brojClanova: 3500,
  );

  final romska = srbDomain.createPolitickaStranka(
    naziv: 'Romska stranka Vračar',
    skraceniNaziv: 'RSV',
    datumOsnivanja: DateTime(2018, 6, 10),
    ideologija: 'Socijalni liberalizam',
    predsednik: 'Dejan Nikolić',
    brojClanova: 850,
    manjinskaStranka: true,
    nacionalnaManjina: 'Romska',
  );

  // Create electoral lists
  final snsLista = srbDomain.createIzbornaLista(
    naziv: 'SNS - Za bolji Vračar',
    redniBroj: 1,
    stranka: sns,
  );

  final spsLista = srbDomain.createIzbornaLista(
    naziv: 'SPS - Socijalistička opcija',
    redniBroj: 2,
    stranka: sps,
  );

  final opozicijaLista = srbDomain.createIzbornaLista(
    naziv: 'LOV - Lokalna opozicija Vračar',
    redniBroj: 3,
    stranka: opozicija,
  );

  final romskaLista = srbDomain.createIzbornaLista(
    naziv: 'Romska stranka Vračar',
    redniBroj: 4,
    stranka: romska,
    manjinskaLista: true,
  );

  // Add lists to the aggregate
  print('Adding electoral lists to the aggregate...');
  izboriAggregate.addIzbornaLista(snsLista);
  izboriAggregate.addIzbornaLista(spsLista);
  izboriAggregate.addIzbornaLista(opozicijaLista);
  izboriAggregate.addIzbornaLista(romskaLista);

  // Create voters
  final glasac1 = srbDomain.createGlasac(
    ime: 'Petar Petrović',
    jmbg: '0101985710123',
    datumRodjenja: DateTime(1985, 1, 1),
    pol: 'Muški',
    opstina: 'Vračar',
    birackoMesto: izbJedinica,
  );

  final glasac2 = srbDomain.createGlasac(
    ime: 'Marija Marković',
    jmbg: '1505990715123',
    datumRodjenja: DateTime(1990, 5, 15),
    pol: 'Ženski',
    opstina: 'Vračar',
    birackoMesto: izbJedinica,
  );

  // Create votes
  final glas1 = srbDomain.createGlas(
    glasac: glasac1,
    izbornaLista: snsLista,
    datumGlasanja: DateTime(2022, 4, 3),
    birackoMesto: izbJedinica,
  );

  final glas2 = srbDomain.createGlas(
    glasac: glasac2,
    izbornaLista: opozicijaLista,
    datumGlasanja: DateTime(2022, 4, 3),
    birackoMesto: izbJedinica,
  );

  // Add votes to the aggregate
  print('Adding votes to the aggregate...');
  izboriAggregate.addGlas(glas1);
  izboriAggregate.addGlas(glas2);

  // Simulate election results
  snsLista.brojGlasova = 12500;
  spsLista.brojGlasova = 6500;
  opozicijaLista.brojGlasova = 10000;
  romskaLista.brojGlasova = 1200;

  // Calculate total votes
  int ukupnoGlasova = snsLista.brojGlasova! +
      spsLista.brojGlasova! +
      opozicijaLista.brojGlasova! +
      romskaLista.brojGlasova!;

  // Update election statistics
  izboriAggregate.entity.brojGlasalih = ukupnoGlasova;
  izboriAggregate.entity.izlaznost =
      ukupnoGlasova / izboriAggregate.entity.brojUpisanihBiraca;

  // Distribute mandates
  final kalkulator = DontKalkulator();
  final rezultati = [
    RezultatListe(snsLista.naziv, snsLista.brojGlasova!),
    RezultatListe(spsLista.naziv, spsLista.brojGlasova!),
    RezultatListe(opozicijaLista.naziv, opozicijaLista.brojGlasova!),
    RezultatListe(romskaLista.naziv, romskaLista.brojGlasova!,
        manjinskaLista: true),
  ];

  // Apply D'Hondt method
  final rezultatiSaMandatima = kalkulator.izracunajMandate(
    rezultati,
    izbJedinica.brojMandata,
    cenzus: zakon.cenzus,
  );

  // Update mandate counts
  snsLista.brojMandata = rezultatiSaMandatima[0].brojMandata;
  spsLista.brojMandata = rezultatiSaMandatima[1].brojMandata;
  opozicijaLista.brojMandata = rezultatiSaMandatima[2].brojMandata;
  romskaLista.brojMandata = rezultatiSaMandatima[3].brojMandata;

  // Print results
  print('\n=== ELECTION RESULTS ===');
  print('Election: ${izboriAggregate.entity.naziv}');
  print(
      'Date: ${izboriAggregate.entity.datumOdrzavanja.toIso8601String().substring(0, 10)}');
  print(
      'Turnout: ${(izboriAggregate.entity.izlaznost * 100).toStringAsFixed(2)}%');
  print('\nMandate distribution (${izbJedinica.brojMandata} total mandates):');
  print('${snsLista.naziv}: ${snsLista.brojMandata} mandates');
  print('${spsLista.naziv}: ${spsLista.brojMandata} mandates');
  print('${opozicijaLista.naziv}: ${opozicijaLista.brojMandata} mandates');
  print('${romskaLista.naziv}: ${romskaLista.brojMandata} mandates');

  // The critical difference: validation with the Aggregate Root
  print('\n=== VALIDATING RELATIONSHIPS ===');
  final validationErrors = izboriAggregate.validateRelationships();

  if (validationErrors.isEmpty) {
    print('✓ All required relationships are properly established!');
    print(
        '  Using the AggregateRoot pattern has fixed the validation warnings.');
  } else {
    print('⨯ There are still validation issues:');
    // Use the toString() method which iterates through all exceptions
    print(validationErrors.toString());
  }

  // Check business rules
  print('\n=== VALIDATING BUSINESS INVARIANTS ===');
  final businessErrors = izboriAggregate.validateBusinessInvariants();

  if (businessErrors.isEmpty) {
    print('✓ All business rules are satisfied!');
  } else {
    print('⨯ There are business rule violations:');
    // Use the toString() method which iterates through all exceptions
    print(businessErrors.toString());
  }
}
