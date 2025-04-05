import 'package:test/test.dart';
import '../lib/serbian_election.dart';

void main() {
  group('DontKalkulator Tests', () {
    late DontKalkulator kalkulator;
    late SerbianElectionRepo repo;
    late SerbianElectionDomain domain;

    setUp(() {
      kalkulator = DontKalkulator();
      repo = SerbianElectionRepo();
      domain = repo.getDomainModels('SerbianElection') as SerbianElectionDomain;
    });

    test('Osnovna raspodela mandata sa dve liste', () {
      final liste = [
        RezultatListe('Lista A', 60000),
        RezultatListe('Lista B', 40000),
      ];

      final rezultati = kalkulator.izracunajMandate(liste, 10, cenzus: 0.03);

      expect(rezultati.length, equals(2));
      expect(
        rezultati.firstWhere((p) => p.naziv == 'Lista A').brojMandata,
        equals(6),
      );
      expect(
        rezultati.firstWhere((p) => p.naziv == 'Lista B').brojMandata,
        equals(4),
      );
    });

    test('Raspodela mandata sa listama ispod cenzusa', () {
      final liste = [
        RezultatListe('Velika Lista', 80000),
        RezultatListe('Srednja Lista', 1500), // Ispod 3% cenzusa
        RezultatListe('Mala Lista', 500), // Ispod 3% cenzusa
      ];

      final rezultati = kalkulator.izracunajMandate(liste, 10, cenzus: 0.03);

      // Očekujemo da samo Velika Lista dobije mandate
      expect(
        rezultati.firstWhere((p) => p.naziv == 'Velika Lista').brojMandata,
        equals(10),
      );
      expect(
        rezultati.firstWhere((p) => p.naziv == 'Srednja Lista').brojMandata,
        equals(0),
      );
      expect(
        rezultati.firstWhere((p) => p.naziv == 'Mala Lista').brojMandata,
        equals(0),
      );
    });

    test('Granični slučaj: Jedna lista dobija sve mandate', () {
      final liste = [RezultatListe('Jedina Lista', 100000)];

      final rezultati = kalkulator.izracunajMandate(liste, 10, cenzus: 0.03);

      expect(rezultati.length, equals(1));
      expect(
        rezultati.firstWhere((p) => p.naziv == 'Jedina Lista').brojMandata,
        equals(10),
      );
    });

    test('Granični slučaj: Jednaki glasovi između lista', () {
      final liste = [
        RezultatListe('Lista A', 50000),
        RezultatListe('Lista B', 50000),
      ];

      final rezultati = kalkulator.izracunajMandate(liste, 10, cenzus: 0.03);

      expect(rezultati.length, equals(2));
      // Trebalo bi da podele mandate ravnomerno
      expect(
        rezultati.firstWhere((p) => p.naziv == 'Lista A').brojMandata,
        equals(5),
      );
      expect(
        rezultati.firstWhere((p) => p.naziv == 'Lista B').brojMandata,
        equals(5),
      );
    });

    test('Kompleksan scenario sa različitim listama', () {
      final liste = [
        RezultatListe('Velika Lista A', 450000),
        RezultatListe('Velika Lista B', 350000),
        RezultatListe('Velika Lista C', 200000),
      ];

      final rezultati = kalkulator.izracunajMandate(liste, 100, cenzus: 0.03);

      // Provera da ukupan broj mandata iznosi 100
      final ukupnoMandata = rezultati.fold<int>(
        0,
        (sum, lista) => sum + (lista.brojMandata ?? 0),
      );
      expect(ukupnoMandata, equals(100));
    });
  });
}
