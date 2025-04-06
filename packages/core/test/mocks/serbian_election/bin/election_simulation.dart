import 'package:ednet_core/ednet_core.dart';
import '../lib/serbian_election.dart';

void main() {
  // Initialize domain and model
  final domain = Domain();
  final model = SerbianElectionModel.initModel(domain);
  final entries = SerbianElectionEntries(model);
  final izbornaSimulacija = SerbianElectionDomain(domain, entries);

  print('🇷🇸 Početak izborne simulacije za Srbiju 🇷🇸');
  print('============================================');

  // Kreiranje izbornih jedinica (biračkih mesta)
  print('\n📍 Kreiranje izbornih jedinica...');
  final bm1 = izbornaSimulacija.createIzbornaJedinica(
    naziv: 'Birački centar Novi Beograd',
    sifra: 'BG-NB-001',
    nivo: 'opština',
    brojStanovnika: 250000,
    brojUpisanihBiraca: 180000,
  );

  final bm2 = izbornaSimulacija.createIzbornaJedinica(
    naziv: 'Birački centar Novi Sad',
    sifra: 'NS-001',
    nivo: 'opština',
    brojStanovnika: 320000,
    brojUpisanihBiraca: 220000,
  );

  final bm3 = izbornaSimulacija.createIzbornaJedinica(
    naziv: 'Birački centar Niš',
    sifra: 'NI-001',
    nivo: 'opština',
    brojStanovnika: 180000,
    brojUpisanihBiraca: 140000,
  );

  print(
      'Kreirano ${izbornaSimulacija.izborneJedinice.length} izbornih jedinica.');

  // Kreiranje stranaka i koalicija
  print('\n🏛️ Kreiranje političkih stranaka i koalicija...');
  final sns = izbornaSimulacija.createPolitickaStranka(
    naziv: 'Srpska napredna stranka',
    skraceniNaziv: 'SNS',
    datumOsnivanja: DateTime(2008, 10, 21),
    ideologija: 'konzervativizam, nacionalizam',
    predsednik: 'Miloš Vučević',
    brojClanova: 750000,
  );

  final sps = izbornaSimulacija.createPolitickaStranka(
    naziv: 'Socijalistička partija Srbije',
    skraceniNaziv: 'SPS',
    datumOsnivanja: DateTime(1990, 7, 16),
    ideologija: 'socijaldemokratija, patriotizam',
    predsednik: 'Ivica Dačić',
    brojClanova: 120000,
  );

  final ssss = izbornaSimulacija.createPolitickaStranka(
    naziv: 'Stranka slobode i pravde',
    skraceniNaziv: 'SSP',
    datumOsnivanja: DateTime(2019, 4, 19),
    ideologija: 'liberalizam, proevropski',
    predsednik: 'Dragan Đilas',
    brojClanova: 35000,
  );

  final ds = izbornaSimulacija.createPolitickaStranka(
    naziv: 'Demokratska stranka',
    skraceniNaziv: 'DS',
    datumOsnivanja: DateTime(1990, 2, 3),
    ideologija: 'socijaldemokratija, proevropski',
    predsednik: 'Zoran Lutovac',
    brojClanova: 50000,
  );

  final svm = izbornaSimulacija.createPolitickaStranka(
    naziv: 'Savez vojvođanskih Mađara',
    skraceniNaziv: 'SVM',
    datumOsnivanja: DateTime(1994, 6, 18),
    ideologija: 'manjinska politika, regionalizam',
    predsednik: 'Ištvan Pastor',
    brojClanova: 14000,
    manjinskaStranka: true,
  );

  // Kreiranje koalicija
  final koalicijaSns = izbornaSimulacija.createKoalicija(
    naziv: 'Za našu decu',
    datumFormiranja: DateTime(2022, 1, 15),
    nosiocKoalicije: 'SNS',
    clanice: [sns, sps],
  );

  final koalicijaOpozicija = izbornaSimulacija.createKoalicija(
    naziv: 'Ujedinjeni za pobedu Srbije',
    datumFormiranja: DateTime(2022, 2, 10),
    nosiocKoalicije: 'SSP',
    clanice: [ssss, ds],
  );

  print(
      'Kreirano ${izbornaSimulacija.politickeStranke.length} stranaka i ${izbornaSimulacija.koalicije.length} koalicija.');

  // Kreiranje izbornih lista
  print('\n📋 Kreiranje izbornih lista...');
  final listaSns = izbornaSimulacija.createIzbornaLista(
    naziv: 'Aleksandar Vučić - Zajedno možemo sve',
    redniBroj: 1,
    koalicija: koalicijaSns,
  );

  final listaOpozicija = izbornaSimulacija.createIzbornaLista(
    naziv: 'Ujedinjeni za pobedu Srbije',
    redniBroj: 2,
    koalicija: koalicijaOpozicija,
  );

  final listaSvm = izbornaSimulacija.createIzbornaLista(
    naziv: 'Savez vojvođanskih Mađara - Ištvan Pastor',
    redniBroj: 3,
    stranka: svm,
    manjinskaLista: true,
  );

  print('Kreirano ${izbornaSimulacija.izborneListe.length} izbornih lista.');

  // Kreiranje demografskog generatora i generisanje stanovništva
  print('\n👨‍👩‍👧‍👦 Generisanje glasača pomoću demografskog generatora...');
  final demografskiGenerator = SrbijaDemografskiGenerator(izbornaSimulacija);

  // Raspodela glasača po biračkim mestima
  final raspodelaBiraca = <IzbornaJedinica, int>{
    bm1: 2000,
    bm2: 1500,
    bm3: 1000,
  };

  final glasaci = demografskiGenerator.generisiPopulaciju(
    4500, // Ukupan broj glasača
    raspodelaPoJedinicama: raspodelaBiraca,
  );

  print('Generisano ${glasaci.length} glasača.');
  print('  - Birača na mestu ${bm1.naziv}: ${bm1.brojUpisanihBiraca}');
  print('  - Birača na mestu ${bm2.naziv}: ${bm2.brojUpisanihBiraca}');
  print('  - Birača na mestu ${bm3.naziv}: ${bm3.brojUpisanihBiraca}');

  // Simuliranje glasanja sa zadatom raspodelom glasova
  print('\n🗳️ Simuliranje glasanja...');

  // Raspodela glasova po listama (ukupno mora biti 1.0)
  final raspodelaGlasova = <IzbornaLista, double>{
    listaSns: 0.55, // 55% glasova
    listaOpozicija: 0.42, // 42% glasova
    listaSvm: 0.03, // 3% glasova
  };

  // Simuliraj glasanje
  demografskiGenerator.simulirajGlasanje(glasaci, raspodelaGlasova);

  // Izveštaj o rezultatima glasanja
  print('\n📊 Rezultati glasanja:');
  int ukupnoGlasalih = 0;
  for (final bm in izbornaSimulacija.izborneJedinice) {
    print(
        '  - ${bm.naziv}: ${bm.brojGlasalih} glasalih od ${bm.brojUpisanihBiraca} upisanih birača');
    ukupnoGlasalih += bm.brojGlasalih;
  }

  print(
      '\nIzlaznost: ${(ukupnoGlasalih / glasaci.length * 100).toStringAsFixed(2)}%');

  print('\nRezultati po listama:');
  for (final lista in izbornaSimulacija.izborneListe) {
    final procenat = (lista.brojGlasova ?? 0) / ukupnoGlasalih * 100;
    print(
        '  - ${lista.naziv}: ${lista.brojGlasova} glasova (${procenat.toStringAsFixed(2)}%)');
  }

  // Raspodela mandata (ukupno 250 poslanika)
  print('\n🏛️ Raspodela mandata u Skupštini Srbije (250 poslanika):');
  final listeZaRaspodelu = izbornaSimulacija.izborneListe.toList();
  final rezultatRaspodele = izbornaSimulacija.raspodelaMandataDontovomMetodom(
    listeZaRaspodelu,
    250, // Ukupan broj mandata u Narodnoj skupštini
    cenzus: 0.03, // 3% cenzus
  );

  for (final lista in rezultatRaspodele) {
    print('  - ${lista.naziv}: ${lista.brojMandata} mandata');
  }

  print('\n🇷🇸 Simulacija završena 🇷🇸');
}
