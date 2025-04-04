import 'package:test/test.dart';
import 'old_serbian_electoral_system_simulation/serbian_election_domain.dart';

void main() {
  group('Serbian Election Simulation Tests', () {
    late SerbianElectionDomain domen;

    setUp(() {
      domen = SerbianElectionDomain();
      domen.init();
    });

    test('Domain initialization', () {
      expect(domen.glasacConcept, isNotNull);
      expect(domen.politickaStrankaConcept, isNotNull);
      expect(domen.koalicijaConcept, isNotNull);
      expect(domen.izbornaListaConcept, isNotNull);
      expect(domen.kandidatConcept, isNotNull);
      expect(domen.izbornaJedinicaConcept, isNotNull);
      expect(domen.glasConcept, isNotNull);

      expect(domen.glasaci, isNotNull);
      expect(domen.politickeStranke, isNotNull);
      expect(domen.koalicije, isNotNull);
      expect(domen.izborneListe, isNotNull);
      expect(domen.kandidati, isNotNull);
      expect(domen.izborneJedinice, isNotNull);
      expect(domen.glasovi, isNotNull);
    });

    test('Create and verify voter', () {
      final glasac = domen.createGlasac(
        ime: 'Petar',
        jmbg: domen.generateJMBG(
          birthDate: DateTime(1980, 5, 15),
          gender: 'muški',
          region: 'Beograd',
        ),
        datumRodjenja: DateTime(1980, 5, 15),
        pol: 'muški',
        opstina: 'Novi Beograd',
      );

      expect(glasac, isNotNull);
      expect(glasac.ime, equals('Petar'));
      expect(glasac.pol, equals('muški'));
      expect(glasac.opstina, equals('Novi Beograd'));
      expect(glasac.glasao, isFalse);
    });

    test('Create and verify political party', () {
      final stranka = domen.createPolitickaStranka(
        naziv: 'Srpska Napredna Stranka',
        skraceniNaziv: 'SNS',
        datumOsnivanja: DateTime(2008, 10, 21),
        ideologija: 'Konzervativizam',
        manjinskaStranka: false,
        predsednik: 'Miloš Vučević',
        brojClanova: 750000,
      );

      expect(stranka, isNotNull);
      expect(stranka.naziv, equals('Srpska Napredna Stranka'));
      expect(stranka.skraceniNaziv, equals('SNS'));
      expect(stranka.manjinskaStranka, isFalse);
    });

    test('Create electoral unit hierarchy', () {
      final okrug = domen.createIzbornaJedinica(
        naziv: 'Beograd',
        sifra: 'BG',
        nivo: 'okrug',
        brojStanovnika: 1700000,
        brojUpisanihBiraca: 1200000,
      );

      final opstina = domen.createIzbornaJedinica(
        naziv: 'Novi Beograd',
        sifra: 'NBG',
        nivo: 'opstina',
        brojStanovnika: 250000,
        brojUpisanihBiraca: 180000,
        nadredjenaJedinica: okrug,
      );

      final birackoMesto = domen.createIzbornaJedinica(
        naziv: 'OŠ "Jovan Dučić"',
        sifra: 'NBG-042',
        nivo: 'biracko_mesto',
        brojStanovnika: 2500,
        brojUpisanihBiraca: 1800,
        nadredjenaJedinica: opstina,
      );

      expect(opstina.nadredjenaJedinica, equals(okrug));
      expect(birackoMesto.nadredjenaJedinica, equals(opstina));
    });

    test('Simulate 2022 election results', () {
      // Create parties
      final sns = domen.createPolitickaStranka(
        naziv: 'Srpska Napredna Stranka',
        skraceniNaziv: 'SNS',
        datumOsnivanja: DateTime(2008, 10, 21),
        ideologija: 'Konzervativizam',
        manjinskaStranka: false,
        predsednik: 'Miloš Vučević',
        brojClanova: 750000,
      );
      expect(domen.politickeStranke.add(sns), isTrue);

      final sps = domen.createPolitickaStranka(
        naziv: 'Socijalistička Partija Srbije',
        skraceniNaziv: 'SPS',
        datumOsnivanja: DateTime(1990, 7, 17),
        ideologija: 'Socijalizam',
        manjinskaStranka: false,
        predsednik: 'Ivica Dačić',
        brojClanova: 200000,
      );
      expect(domen.politickeStranke.add(sps), isTrue);

      final svm = domen.createPolitickaStranka(
        naziv: 'Savez Vojvođanskih Mađara',
        skraceniNaziv: 'SVM',
        datumOsnivanja: DateTime(1994, 6, 18),
        ideologija: 'Manjinska stranka',
        manjinskaStranka: true,
        predsednik: 'István Pásztor',
        brojClanova: 75000,
      );
      expect(domen.politickeStranke.add(svm), isTrue);

      // Create electoral lists
      final snsSpsKoalicija = domen.createIzbornaLista(
        naziv: 'Aleksandar Vučić - Zajedno možemo sve',
        redniBroj: 1,
        brojGlasova: 1637003,
        manjinskaLista: false,
        stranka: sns,
      );
      expect(domen.izborneListe.add(snsSpsKoalicija), isTrue);

      final opozicija = domen.createPolitickaStranka(
        naziv: 'Ujedinjena Opozicija',
        skraceniNaziv: 'UO',
        datumOsnivanja: DateTime(2022, 1, 1),
        ideologija: 'Koalicija',
        manjinskaStranka: false,
        predsednik: 'Razni lideri',
        brojClanova: 350000,
      );
      expect(domen.politickeStranke.add(opozicija), isTrue);

      final ujedinjenaOpozicija = domen.createIzbornaLista(
        naziv: 'Ujedinjeni za pobedu Srbije',
        redniBroj: 2,
        brojGlasova: 581385,
        manjinskaLista: false,
        stranka: opozicija,
      );
      expect(domen.izborneListe.add(ujedinjenaOpozicija), isTrue);

      final svmLista = domen.createIzbornaLista(
        naziv: 'Savez Vojvođanskih Mađara - István Pásztor',
        redniBroj: 3,
        brojGlasova: 60000,
        manjinskaLista: true,
        stranka: svm,
      );
      expect(domen.izborneListe.add(svmLista), isTrue);

      // Allocate seats
      final seatAllocation = domen.allocateSeats(domen.izborneListe.toList());

      // Verify results
      expect(
        seatAllocation[snsSpsKoalicija]! +
            seatAllocation[ujedinjenaOpozicija]! +
            seatAllocation[svmLista]!,
        equals(250),
      );

      // Verify minority party got seats despite being below threshold
      expect(seatAllocation[svmLista]!, greaterThan(0));
    });

    test('Simulate multiple minority parties scenario', () {
      // Create parties
      final svm = domen.createPolitickaStranka(
        naziv: 'Savez Vojvođanskih Mađara',
        skraceniNaziv: 'SVM',
        datumOsnivanja: DateTime(1994, 6, 18),
        ideologija: 'Manjinska stranka',
        manjinskaStranka: true,
        predsednik: 'István Pásztor',
        brojClanova: 75000,
      );
      expect(domen.politickeStranke.add(svm), isTrue);

      final sdaSandzak = domen.createPolitickaStranka(
        naziv: 'Stranka Demokratske Akcije Sandžaka',
        skraceniNaziv: 'SDA',
        datumOsnivanja: DateTime(1990, 7, 29),
        ideologija: 'Manjinska stranka',
        manjinskaStranka: true,
        predsednik: 'Sulejman Ugljanin',
        brojClanova: 40000,
      );
      expect(domen.politickeStranke.add(sdaSandzak), isTrue);

      final albanianParty = domen.createPolitickaStranka(
        naziv: 'Partia Demokratike e Shqiptarëve',
        skraceniNaziv: 'PDS',
        datumOsnivanja: DateTime(1990, 8, 15),
        ideologija: 'Manjinska stranka',
        manjinskaStranka: true,
        predsednik: 'Ragmi Mustafa',
        brojClanova: 30000,
      );
      expect(domen.politickeStranke.add(albanianParty), isTrue);

      final majorityParty = domen.createPolitickaStranka(
        naziv: 'Većinska Stranka',
        skraceniNaziv: 'VS',
        datumOsnivanja: DateTime(2020, 1, 1),
        ideologija: 'Centrizam',
        manjinskaStranka: false,
        predsednik: 'Petar Petrović',
        brojClanova: 500000,
      );
      expect(domen.politickeStranke.add(majorityParty), isTrue);

      final majorityList = domen.createIzbornaLista(
        naziv: 'Većinska Lista',
        redniBroj: 1,
        brojGlasova: 1500000,
        manjinskaLista: false,
        stranka: majorityParty,
      );
      expect(domen.izborneListe.add(majorityList), isTrue);

      final svmList = domen.createIzbornaLista(
        naziv: 'SVM - Magyar Összefogás',
        redniBroj: 2,
        brojGlasova: 60000,
        manjinskaLista: true,
        stranka: svm,
      );
      expect(domen.izborneListe.add(svmList), isTrue);

      final sdaList = domen.createIzbornaLista(
        naziv: 'SDA Sandžaka',
        redniBroj: 3,
        brojGlasova: 30000,
        manjinskaLista: true,
        stranka: sdaSandzak,
      );
      expect(domen.izborneListe.add(sdaList), isTrue);

      final albanianList = domen.createIzbornaLista(
        naziv: 'Koalicija Albanaca',
        redniBroj: 4,
        brojGlasova: 25000,
        manjinskaLista: true,
        stranka: albanianParty,
      );
      expect(domen.izborneListe.add(albanianList), isTrue);

      // Allocate seats
      final seatAllocation = domen.allocateSeats(domen.izborneListe.toList());

      // Verify results
      var totalSeats = 0;
      for (var list in domen.izborneListe) {
        totalSeats += seatAllocation[list]!;
      }
      expect(totalSeats, equals(250));

      // Verify all minority parties got seats despite being below threshold
      expect(seatAllocation[svmList]!, greaterThan(0));
      expect(seatAllocation[sdaList]!, greaterThan(0));
      expect(seatAllocation[albanianList]!, greaterThan(0));
    });
  });
}
