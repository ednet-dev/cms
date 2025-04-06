import '../lib/serbian_election.dart';

// SERBIAN ELECTORAL SYSTEM SIMULATION - ALL GOVERNANCE LEVELS

void main() {
  // Initialize repository and domain
  final repo = SerbianElectionRepo();
  final domain =
      repo.getDomainModels('SerbianElection') as SerbianElectionDomain;

  //==========================================================================
  // 1. MUNICIPALITY LEVEL (OPŠTINA) - LOWEST GOVERNANCE LEVEL
  //==========================================================================
  print('\n=== MUNICIPALITY ELECTION (OPŠTINA VRAČAR) ===');

  // 1.1 Create electoral laws and systems for municipal level
  final municipalLaw = domain.createIzborniZakon(
    naziv: 'Zakon o lokalnim izborima',
    tipZakona: 'Lokalni',
    datumDonosenja: DateTime(2022, 2, 4),
    nivoVlasti: 'Opština',
    cenzus: 0.03, // 3% threshold
    cenzusZaManjine: false, // No threshold for minority parties
    kvoraZene: 0.4, // 40% quota for women
    opisZakona: 'Zakon koji reguliše lokalne izbore na nivou opština',
  );

  final municipalSystem = domain.createIzborniSistem(
    naziv: 'Proporcionalni sistem za lokalne izbore',
    nivoVlasti: 'Opština',
    proporcionalni: true,
    metoda: 'DHont',
    cenzus: 0.03, // 3% threshold for regular parties
  );

  // 1.2 Create electoral commission for municipal level
  final municipalCommission = domain.createIzbornaKomisija(
    naziv: 'Opštinska izborna komisija Vračar',
    nivo: 'Opština',
    brojClanova: 7,
    predsednik: 'Ana Petrović',
  );

  // 1.3 Create election type for municipal level
  final municipalElectionType = domain.createTipIzbora(
    naziv: 'Lokalni izbori za skupštinu opštine',
    nivoVlasti: 'Opština',
    periodMandataGodina: 4,
    opis: 'Izbori za lokalnu skupštinu opštine',
  );

  // 1.4 Create municipality electoral unit
  final vracarMunicipality = domain.createIzbornaJedinica(
    naziv: 'Opština Vračar',
    sifra: 'BG-VRACAR',
    nivo: 'Opština',
    brojStanovnika: 56000,
    brojUpisanihBiraca: 45000,
    brojMandata: 35, // Smaller municipality - fewer mandates
  );

  // 1.5 Create the election
  final municipalElection = domain.createIzbori(
    naziv: 'Lokalni izbori za Opštinu Vračar 2022',
    datumOdrzavanja: DateTime(2022, 4, 3),
    datumRaspisivanja: DateTime(2022, 2, 15),
    nivoVlasti: 'Opština',
    brojUpisanihBiraca: vracarMunicipality.brojUpisanihBiraca,
    tipIzbora: municipalElectionType,
    izbornaKomisija: municipalCommission,
    izborniZakon: municipalLaw,
    izborniSistem: municipalSystem,
  );

  // 1.6 Create local parties for municipal election
  final localSNS = domain.createPolitickaStranka(
    naziv: 'Srpska napredna stranka - Ogranak Vračar',
    skraceniNaziv: 'SNS Vračar',
    datumOsnivanja: DateTime(2008, 10, 21),
    ideologija: 'Konzervativizam',
    predsednik: 'Milan Nedeljković',
    brojClanova: 2500,
  );

  final localSPS = domain.createPolitickaStranka(
    naziv: 'Socijalistička partija Srbije - Ogranak Vračar',
    skraceniNaziv: 'SPS Vračar',
    datumOsnivanja: DateTime(1990, 7, 17),
    ideologija: 'Socijalizam',
    predsednik: 'Petar Jovanović',
    brojClanova: 1000,
  );

  final localOpposition = domain.createPolitickaStranka(
    naziv: 'Lokalna opozicija Vračar',
    skraceniNaziv: 'LOV',
    datumOsnivanja: DateTime(2020, 3, 15),
    ideologija: 'Građanski liberalizam',
    predsednik: 'Jovana Simić',
    brojClanova: 1200,
  );

  final localRoma = domain.createPolitickaStranka(
    naziv: 'Romska stranka Vračar',
    skraceniNaziv: 'RSV',
    datumOsnivanja: DateTime(2015, 5, 20),
    ideologija: 'Manjinska prava',
    predsednik: 'Dejan Stanković',
    brojClanova: 300,
    manjinskaStranka: true,
    nacionalnaManjina: 'Romska',
  );

  // 1.7 Create electoral lists
  final localSNSList = domain.createIzbornaLista(
    naziv: 'SNS - Za bolji Vračar',
    redniBroj: 1,
    stranka: localSNS,
  );

  final localSPSList = domain.createIzbornaLista(
    naziv: 'SPS - Socijalistička opcija',
    redniBroj: 2,
    stranka: localSPS,
  );

  final localOppositionList = domain.createIzbornaLista(
    naziv: 'LOV - Lokalna opozicija Vračar',
    redniBroj: 3,
    stranka: localOpposition,
  );

  final localRomaList = domain.createIzbornaLista(
    naziv: 'Romska stranka Vračar',
    redniBroj: 4,
    stranka: localRoma,
    manjinskaLista: true,
  );

  // 1.8 Simulate voting (small municipality)
  localSNSList.brojGlasova = 15000; // 33.3%
  localSPSList.brojGlasova = 8000; // 17.8%
  localOppositionList.brojGlasova = 13000; // 28.9%
  localRomaList.brojGlasova = 1000; // 2.2% (below threshold but minority)

  // 1.9 Calculate mandates using D'Hondt method
  final municipalLists = [
    localSNSList,
    localSPSList,
    localOppositionList,
    localRomaList
  ];
  domain.raspodelaMandataDontovomMetodom(
    municipalLists,
    vracarMunicipality.brojMandata,
    cenzus: 0.03,
  );

  // 1.10 Output municipal election results
  print('REZULTATI LOKALNIH IZBORA - OPŠTINA VRAČAR:');
  print('Ukupno mandata: ${vracarMunicipality.brojMandata}');
  for (final lista in municipalLists) {
    print('${lista.naziv}: ${lista.brojMandata} mandata');
  }

  //==========================================================================
  // 2. CITY LEVEL (GRAD)
  //==========================================================================
  print('\n=== CITY ELECTION (GRAD BEOGRAD) ===');

  // 2.1 Create electoral laws and systems for city level
  final cityLaw = domain.createIzborniZakon(
    naziv: 'Zakon o lokalnim izborima za gradove',
    tipZakona: 'Gradski',
    datumDonosenja: DateTime(2022, 2, 4),
    nivoVlasti: 'Grad',
    cenzus: 0.03,
    cenzusZaManjine: false,
    kvoraZene: 0.4,
  );

  final citySystem = domain.createIzborniSistem(
    naziv: 'Proporcionalni sistem za gradske izbore',
    nivoVlasti: 'Grad',
    proporcionalni: true,
    metoda: 'DHont',
    cenzus: 0.03,
  );

  // 2.2 Create electoral commission for city level
  final cityCommission = domain.createIzbornaKomisija(
    naziv: 'Gradska izborna komisija Beograd',
    nivo: 'Grad',
    brojClanova: 15,
    predsednik: 'Miloš Kovačević',
  );

  // 2.3 Create election type for city level
  final cityElectionType = domain.createTipIzbora(
    naziv: 'Izbori za skupštinu grada',
    nivoVlasti: 'Grad',
    periodMandataGodina: 4,
  );

  // 2.4 Create city electoral unit
  final belgradeCityUnit = domain.createIzbornaJedinica(
    naziv: 'Grad Beograd',
    sifra: 'BG',
    nivo: 'Grad',
    brojStanovnika: 1700000,
    brojUpisanihBiraca: 1400000,
    brojMandata: 110,
  );

  // 2.5 Create the election
  final cityElection = domain.createIzbori(
    naziv: 'Izbori za Skupštinu grada Beograda 2022',
    datumOdrzavanja: DateTime(2022, 4, 3),
    datumRaspisivanja: DateTime(2022, 2, 15),
    nivoVlasti: 'Grad',
    brojUpisanihBiraca: belgradeCityUnit.brojUpisanihBiraca,
    tipIzbora: cityElectionType,
    izbornaKomisija: cityCommission,
    izborniZakon: cityLaw,
    izborniSistem: citySystem,
  );

  // 2.6 Create political parties and coalitions for city election
  final citySNS = domain.createPolitickaStranka(
    naziv: 'Srpska napredna stranka - Beograd',
    skraceniNaziv: 'SNS BG',
    datumOsnivanja: DateTime(2008, 10, 21),
    ideologija: 'Konzervativizam',
    predsednik: 'Aleksandar Šapić',
    brojClanova: 65000,
  );

  final citySPS = domain.createPolitickaStranka(
    naziv: 'Socijalistička partija Srbije - Beograd',
    skraceniNaziv: 'SPS BG',
    datumOsnivanja: DateTime(1990, 7, 17),
    ideologija: 'Socijalizam',
    predsednik: 'Nikola Nikodijević',
    brojClanova: 30000,
  );

  // City coalition
  final cityCoalition = domain.createKoalicija(
    naziv: 'Za naš Beograd',
    datumFormiranja: DateTime(2022, 1, 15),
    nosiocKoalicije: 'SNS BG',
    clanice: [citySNS, citySPS],
  );

  final cityDS = domain.createPolitickaStranka(
    naziv: 'Demokratska stranka - Beograd',
    skraceniNaziv: 'DS BG',
    datumOsnivanja: DateTime(1990, 2, 3),
    ideologija: 'Socijaldemokratija',
    predsednik: 'Zoran Lutovac',
    brojClanova: 18000,
  );

  final citySSP = domain.createPolitickaStranka(
    naziv: 'Stranka slobode i pravde - Beograd',
    skraceniNaziv: 'SSP BG',
    datumOsnivanja: DateTime(2019, 4, 19),
    ideologija: 'Progresivizam',
    predsednik: 'Dragan Đilas',
    brojClanova: 12000,
  );

  // Opposition coalition
  final cityOppositionCoalition = domain.createKoalicija(
    naziv: 'Ujedinjeni za Beograd',
    datumFormiranja: DateTime(2022, 1, 5),
    nosiocKoalicije: 'SSP BG',
    clanice: [cityDS, citySSP],
  );

  // Hungarian minority party (city branch)
  final citySVM = domain.createPolitickaStranka(
    naziv: 'Savez vojvođanskih Mađara - Beograd',
    skraceniNaziv: 'SVM BG',
    datumOsnivanja: DateTime(1994, 6, 18),
    ideologija: 'Manjinska prava',
    predsednik: 'Ištvan Pastor',
    brojClanova: 2000,
    manjinskaStranka: true,
    nacionalnaManjina: 'Mađarska',
  );

  // 2.7 Create electoral lists
  final cityCoalitionList = domain.createIzbornaLista(
    naziv: 'Za naš Beograd',
    redniBroj: 1,
    koalicija: cityCoalition,
  );

  final cityOppositionList = domain.createIzbornaLista(
    naziv: 'Ujedinjeni za Beograd',
    redniBroj: 2,
    koalicija: cityOppositionCoalition,
  );

  final citySVMList = domain.createIzbornaLista(
    naziv: 'Savez vojvođanskih Mađara',
    redniBroj: 3,
    stranka: citySVM,
    manjinskaLista: true,
  );

  // 2.8 Simulate voting (city level)
  cityCoalitionList.brojGlasova = 560000; // 40%
  cityOppositionList.brojGlasova = 490000; // 35%
  citySVMList.brojGlasova = 28000; // 2% (below threshold but minority)

  // 2.9 Calculate mandates using D'Hondt method
  final cityLists = [cityCoalitionList, cityOppositionList, citySVMList];
  domain.raspodelaMandataDontovomMetodom(
    cityLists,
    belgradeCityUnit.brojMandata,
    cenzus: 0.03,
  );

  // 2.10 Output city election results
  print('REZULTATI GRADSKIH IZBORA - GRAD BEOGRAD:');
  print('Ukupno mandata: ${belgradeCityUnit.brojMandata}');
  for (final lista in cityLists) {
    print('${lista.naziv}: ${lista.brojMandata} mandata');
  }

  //==========================================================================
  // 3. PROVINCIAL LEVEL (POKRAJINA VOJVODINA)
  //==========================================================================
  print('\n=== PROVINCIAL ELECTION (AP VOJVODINA) ===');

  // 3.1 Create electoral laws and systems for provincial level
  final provincialLaw = domain.createIzborniZakon(
    naziv: 'Pokrajinska skupštinska odluka o izboru poslanika',
    tipZakona: 'Pokrajinski',
    datumDonosenja: DateTime(2020, 8, 20),
    nivoVlasti: 'Pokrajina',
    cenzus: 0.03,
    cenzusZaManjine: false, // No threshold for minority lists
  );

  final provincialSystem = domain.createIzborniSistem(
    naziv: 'Mešoviti sistem za pokrajinske izbore',
    nivoVlasti: 'Pokrajina',
    proporcionalni: true,
    vecinskiPrvi:
        false, // Vojvodina has a mixed system (60 proportional, 60 majoritarian)
    metoda: 'DHont',
    cenzus: 0.03,
  );

  // 3.2 Create electoral commission for provincial level
  final provincialCommission = domain.createIzbornaKomisija(
    naziv: 'Pokrajinska izborna komisija',
    nivo: 'Pokrajina',
    brojClanova: 18,
    predsednik: 'Milovan Trbojević',
  );

  // 3.3 Create election type for provincial level
  final provincialElectionType = domain.createTipIzbora(
    naziv: 'Izbori za Skupštinu AP Vojvodine',
    nivoVlasti: 'Pokrajina',
    periodMandataGodina: 4,
  );

  // 3.4 Create provincial electoral unit
  final vojvodinaProvincialUnit = domain.createIzbornaJedinica(
    naziv: 'AP Vojvodina',
    sifra: 'APV',
    nivo: 'Pokrajina',
    brojStanovnika: 1800000,
    brojUpisanihBiraca: 1500000,
    brojMandata: 120, // 120 seats in Vojvodina Assembly
  );

  // 3.5 Create the election
  final provincialElection = domain.createIzbori(
    naziv: 'Izbori za Skupštinu AP Vojvodine 2022',
    datumOdrzavanja: DateTime(2022, 4, 3),
    datumRaspisivanja: DateTime(2022, 2, 15),
    nivoVlasti: 'Pokrajina',
    brojUpisanihBiraca: vojvodinaProvincialUnit.brojUpisanihBiraca,
    tipIzbora: provincialElectionType,
    izbornaKomisija: provincialCommission,
    izborniZakon: provincialLaw,
    izborniSistem: provincialSystem,
  );

  // 3.6 Create provincial political parties and coalitions
  final provincialSNS = domain.createPolitickaStranka(
    naziv: 'Srpska napredna stranka - Vojvodina',
    skraceniNaziv: 'SNS APV',
    datumOsnivanja: DateTime(2008, 10, 21),
    ideologija: 'Konzervativizam',
    predsednik: 'Igor Mirović',
    brojClanova: 75000,
  );

  final provincialSPS = domain.createPolitickaStranka(
    naziv: 'Socijalistička partija Srbije - Vojvodina',
    skraceniNaziv: 'SPS APV',
    datumOsnivanja: DateTime(1990, 7, 17),
    ideologija: 'Socijalizam',
    predsednik: 'Dušan Bajatović',
    brojClanova: 35000,
  );

  final provincialCoalition = domain.createKoalicija(
    naziv: 'Za našu Vojvodinu',
    datumFormiranja: DateTime(2022, 1, 20),
    nosiocKoalicije: 'SNS APV',
    clanice: [provincialSNS, provincialSPS],
  );

  final provincialOpposition = domain.createPolitickaStranka(
    naziv: 'Vojvođanski front',
    skraceniNaziv: 'VF',
    datumOsnivanja: DateTime(2018, 6, 12),
    ideologija: 'Regionalizam, Građanski liberalizam',
    predsednik: 'Nenad Čanak',
    brojClanova: 20000,
  );

  // Hungarian minority party - important in Vojvodina
  final provincialSVM = domain.createPolitickaStranka(
    naziv: 'Savez vojvođanskih Mađara',
    skraceniNaziv: 'SVM',
    datumOsnivanja: DateTime(1994, 6, 18),
    ideologija: 'Manjinska prava, Regionalni interesi',
    predsednik: 'Ištvan Pastor',
    brojClanova: 15000,
    manjinskaStranka: true,
    nacionalnaManjina: 'Mađarska',
  );

  // Slovak minority party - significant in Vojvodina
  final provincialSlovak = domain.createPolitickaStranka(
    naziv: 'Slovačka stranka',
    skraceniNaziv: 'SS',
    datumOsnivanja: DateTime(1995, 9, 22),
    ideologija: 'Manjinska prava',
    predsednik: 'Pavel Surovi',
    brojClanova: 6000,
    manjinskaStranka: true,
    nacionalnaManjina: 'Slovačka',
  );

  // 3.7 Create electoral lists
  final provincialCoalitionList = domain.createIzbornaLista(
    naziv: 'Za našu Vojvodinu',
    redniBroj: 1,
    koalicija: provincialCoalition,
  );

  final provincialOppositionList = domain.createIzbornaLista(
    naziv: 'Vojvođanski front',
    redniBroj: 2,
    stranka: provincialOpposition,
  );

  final provincialSVMList = domain.createIzbornaLista(
    naziv: 'Savez vojvođanskih Mađara',
    redniBroj: 3,
    stranka: provincialSVM,
    manjinskaLista: true,
  );

  final provincialSlovakList = domain.createIzbornaLista(
    naziv: 'Slovačka stranka',
    redniBroj: 4,
    stranka: provincialSlovak,
    manjinskaLista: true,
  );

  // 3.8 Simulate voting (provincial level)
  provincialCoalitionList.brojGlasova = 580000; // 38.7%
  provincialOppositionList.brojGlasova = 380000; // 25.3%
  provincialSVMList.brojGlasova = 70000; // 4.7%
  provincialSlovakList.brojGlasova =
      20000; // 1.3% (below threshold but minority)

  // 3.9 Calculate mandates using D'Hondt method for 60 proportional seats
  // Note: In Vojvodina, 60 seats are elected by proportional system and 60 by majoritarian
  // For this simulation, we're calculating only the proportional part
  final provincialLists = [
    provincialCoalitionList,
    provincialOppositionList,
    provincialSVMList,
    provincialSlovakList
  ];

  domain.raspodelaMandataDontovomMetodom(
    provincialLists,
    60, // Only 60 mandates allocated proportionally
    cenzus: 0.03,
  );

  // 3.10 Output provincial election results
  print('REZULTATI POKRAJINSKIH IZBORA - AP VOJVODINA (proporcionalni deo):');
  print('Ukupno mandata (proporcionalni deo): 60');
  for (final lista in provincialLists) {
    print('${lista.naziv}: ${lista.brojMandata} mandata');
  }

  //==========================================================================
  // 4. NATIONAL LEVEL (REPUBLIKA SRBIJA) - HIGHEST GOVERNANCE LEVEL
  //==========================================================================
  print('\n=== NATIONAL ELECTION (REPUBLIKA SRBIJA) ===');

  // 4.1 Create electoral laws and systems for national level
  final nationalLaw = domain.createIzborniZakon(
    naziv: 'Zakon o izboru narodnih poslanika',
    tipZakona: 'Republički',
    datumDonosenja: DateTime(2022, 2, 4),
    nivoVlasti: 'Država',
    cenzus: 0.03, // 3% since 2022 (was 5% before 2020, then 3% in 2020)
    cenzusZaManjine: false, // No threshold for minority lists
    kvoraZene: 0.4, // 40% women's quota
  );

  final nationalSystem = domain.createIzborniSistem(
    naziv: 'Proporcionalni sistem sa zatvorenim listama',
    nivoVlasti: 'Država',
    proporcionalni: true,
    metoda: 'DHont',
    cenzus: 0.03,
  );

  // 4.2 Create electoral commission for national level
  final nationalCommission = domain.createIzbornaKomisija(
    naziv: 'Republička izborna komisija',
    nivo: 'Država',
    brojClanova: 21, // 17 regular members + president + deputy + 2 non-voting
    predsednik: 'Vladimir Dimitrijević',
  );

  // 4.3 Create election type for national level
  final nationalElectionType = domain.createTipIzbora(
    naziv: 'Parlamentarni izbori',
    nivoVlasti: 'Država',
    periodMandataGodina: 4,
    opis: 'Izbori za Narodnu skupštinu Republike Srbije',
  );

  // 4.4 Create national electoral unit (Serbia as a single electoral unit)
  final serbiaUnit = domain.createIzbornaJedinica(
    naziv: 'Republika Srbija',
    sifra: 'RS',
    nivo: 'Država',
    brojStanovnika: 6750000,
    brojUpisanihBiraca: 6500000,
    brojMandata: 250, // 250 seats in National Assembly
  );

  // 4.5 Create the election
  final nationalElection = domain.createIzbori(
    naziv: 'Parlamentarni izbori Republike Srbije 2022',
    datumOdrzavanja: DateTime(2022, 4, 3),
    datumRaspisivanja: DateTime(2022, 2, 15),
    nivoVlasti: 'Država',
    brojUpisanihBiraca: serbiaUnit.brojUpisanihBiraca,
    tipIzbora: nationalElectionType,
    izbornaKomisija: nationalCommission,
    izborniZakon: nationalLaw,
    izborniSistem: nationalSystem,
  );

  // 4.6 Create national political parties and coalitions
  final nationalSNS = domain.createPolitickaStranka(
    naziv: 'Srpska napredna stranka',
    skraceniNaziv: 'SNS',
    datumOsnivanja: DateTime(2008, 10, 21),
    ideologija: 'Konzervativizam, Nacionalizam',
    predsednik: 'Miloš Vučević',
    brojClanova: 750000,
  );

  final nationalSPS = domain.createPolitickaStranka(
    naziv: 'Socijalistička partija Srbije',
    skraceniNaziv: 'SPS',
    datumOsnivanja: DateTime(1990, 7, 17),
    ideologija: 'Socijalizam, Levica',
    predsednik: 'Ivica Dačić',
    brojClanova: 120000,
  );

  final nationalCoalition = domain.createKoalicija(
    naziv: 'Aleksandar Vučić - Zajedno možemo sve',
    datumFormiranja: DateTime(2022, 1, 25),
    nosiocKoalicije: 'SNS',
    clanice: [nationalSNS, nationalSPS],
  );

  final nationalSDS = domain.createPolitickaStranka(
    naziv: 'Stranka demokratske akcije',
    skraceniNaziv: 'SDA',
    datumOsnivanja: DateTime(1990, 5, 26),
    ideologija: 'Manjinska prava, Bošnjački nacionalizam',
    predsednik: 'Sulejman Ugljanin',
    brojClanova: 25000,
    manjinskaStranka: true,
    nacionalnaManjina: 'Bošnjačka',
  );

  final nationalAlbanian = domain.createPolitickaStranka(
    naziv: 'Albanska demokratska alternativa',
    skraceniNaziv: 'ADA',
    datumOsnivanja: DateTime(2004, 9, 10),
    ideologija: 'Manjinska prava, Albanski nacionalizam',
    predsednik: 'Šaip Kamberi',
    brojClanova: 10000,
    manjinskaStranka: true,
    nacionalnaManjina: 'Albanska',
  );

  // Opposition
  final nationalSSP = domain.createPolitickaStranka(
    naziv: 'Stranka slobode i pravde',
    skraceniNaziv: 'SSP',
    datumOsnivanja: DateTime(2019, 4, 19),
    ideologija: 'Liberalizam, Evropske integracije',
    predsednik: 'Dragan Đilas',
    brojClanova: 40000,
  );

  final nationalDS = domain.createPolitickaStranka(
    naziv: 'Demokratska stranka',
    skraceniNaziv: 'DS',
    datumOsnivanja: DateTime(1989, 2, 3),
    ideologija: 'Socijaldemokratija, Liberalizam',
    predsednik: 'Zoran Lutovac',
    brojClanova: 30000,
  );

  final nationalOppositionCoalition = domain.createKoalicija(
    naziv: 'Ujedinjeni za pobedu Srbije',
    datumFormiranja: DateTime(2022, 1, 10),
    nosiocKoalicije: 'SSP',
    clanice: [nationalSSP, nationalDS],
  );

  // 4.7 Create electoral lists
  final nationalCoalitionList = domain.createIzbornaLista(
    naziv: 'Aleksandar Vučić - Zajedno možemo sve',
    redniBroj: 1,
    koalicija: nationalCoalition,
  );

  final nationalOppositionList = domain.createIzbornaLista(
    naziv: 'Ujedinjeni za pobedu Srbije',
    redniBroj: 2,
    koalicija: nationalOppositionCoalition,
  );

  final nationalSDAList = domain.createIzbornaLista(
    naziv: 'SDA Sandžaka',
    redniBroj: 3,
    stranka: nationalSDS,
    manjinskaLista: true,
  );

  final nationalAlbanianList = domain.createIzbornaLista(
    naziv: 'Albanska demokratska alternativa',
    redniBroj: 4,
    stranka: nationalAlbanian,
    manjinskaLista: true,
  );

  // 4.8 Simulate voting (national election)
  nationalCoalitionList.brojGlasova = 2500000; // 38.5%
  nationalOppositionList.brojGlasova = 1500000; // 23.1%
  nationalSDAList.brojGlasova = 42000; // 0.65% (below threshold but minority)
  nationalAlbanianList.brojGlasova =
      35000; // 0.54% (below threshold but minority)

  // 4.9 Calculate mandates using D'Hondt method
  final nationalLists = [
    nationalCoalitionList,
    nationalOppositionList,
    nationalSDAList,
    nationalAlbanianList
  ];

  domain.raspodelaMandataDontovomMetodom(
    nationalLists,
    serbiaUnit.brojMandata,
    cenzus: 0.03,
  );

  // 4.10 Output national election results
  print('REZULTATI PARLAMENTARNIH IZBORA - REPUBLIKA SRBIJA:');
  print('Ukupno mandata: ${serbiaUnit.brojMandata}');
  for (final lista in nationalLists) {
    print('${lista.naziv}: ${lista.brojMandata} mandata');
  }
}
