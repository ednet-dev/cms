import 'dart:math';
import '../lib/serbian_election.dart';

/// Simulacija srpskog izbornog sistema
void main() {
  print('=============================================================');
  print('SIMULACIJA SRPSKOG IZBORNOG SISTEMA - PARLAMENTARNI IZBORI');
  print('=============================================================');

  try {
    // 1. Inicijalizacija repozitorijuma
    final repo = SerbianElectionRepo();
    final domain = repo.getDomainModels(SerbianElectionModel.MODEL_DOMAIN)
        as SerbianElectionDomain?;
    if (domain == null) {
      print('Greška: Domen nije inicijalizovan');
      return;
    }

    print('Repozitorijum uspešno inicijalizovan\n');

    // 2. Kreiranje političkih stranaka
    print('Kreiranje političkih stranaka...');

    final sns = domain.createPolitickaStranka(
      naziv: 'Srpska napredna stranka',
      skraceniNaziv: 'SNS',
      datumOsnivanja: DateTime(2008, 10, 21),
      ideologija: 'Konzervativizam, nacionalizam',
      predsednik: 'Miloš Vučević',
      brojClanova: 750000,
    );

    final sps = domain.createPolitickaStranka(
      naziv: 'Socijalistička partija Srbije',
      skraceniNaziv: 'SPS',
      datumOsnivanja: DateTime(1990, 7, 17),
      ideologija: 'Socijaldemokratija, levi centar',
      predsednik: 'Ivica Dačić',
      brojClanova: 120000,
    );

    final ds = domain.createPolitickaStranka(
      naziv: 'Demokratska stranka',
      skraceniNaziv: 'DS',
      datumOsnivanja: DateTime(1990, 2, 3),
      ideologija: 'Socijaldemokratija, liberalizam',
      predsednik: 'Zoran Lutovac',
      brojClanova: 50000,
    );

    final pss = domain.createPolitickaStranka(
      naziv: 'Pokret slobodnih građana',
      skraceniNaziv: 'PSG',
      datumOsnivanja: DateTime(2017, 1, 21),
      ideologija: 'Liberalizam, građanski aktivizam',
      predsednik: 'Pavle Grbović',
      brojClanova: 20000,
    );

    final svm = domain.createPolitickaStranka(
      naziv: 'Savez vojvođanskih Mađara',
      skraceniNaziv: 'SVM',
      datumOsnivanja: DateTime(1994, 6, 18),
      ideologija: 'Manjinska stranka, regionalni interesi',
      predsednik: 'Ištvan Pastor',
      brojClanova: 15000,
      manjinskaStranka: true,
    );

    final zeleni = domain.createPolitickaStranka(
      naziv: 'Zelena ekološka partija - Zeleni',
      skraceniNaziv: 'Zeleni',
      datumOsnivanja: DateTime(2007, 10, 15),
      ideologija: 'Zelena politika, ekologija',
      predsednik: 'Ivan Karić',
      brojClanova: 8000,
    );

    print('Kreirano ${domain.politickeStranke.length} stranaka\n');

    // 3. Kreiranje koalicija
    print('Kreiranje koalicija...');

    final opozicijaKoalicija = domain.createKoalicija(
      naziv: 'Ujedinjena opozicija',
      datumFormiranja: DateTime(2022, 11, 15),
      nosiocKoalicije: 'Demokratska stranka',
      clanice: [ds, pss, zeleni],
    );

    print(
        'Kreirana koalicija: ${opozicijaKoalicija.naziv} sa ${opozicijaKoalicija.clanice.length} članica\n');

    // 4. Kreiranje izbornih jedinica
    print('Kreiranje izbornih jedinica...');

    // Kreiramo celu Srbiju kao glavnu izbornu jedinicu
    final srbija = domain.createIzbornaJedinica(
      naziv: 'Republika Srbija',
      sifra: 'RS-000',
      nivo: 'država',
      brojStanovnika: 6900000,
      brojUpisanihBiraca: 6500000,
    );

    // Kreiramo regione
    final vojvodina = domain.createIzbornaJedinica(
      naziv: 'AP Vojvodina',
      sifra: 'RS-VOJ',
      nivo: 'pokrajina',
      brojStanovnika: 1800000,
      brojUpisanihBiraca: 1650000,
      nadredjenaJedinica: srbija,
    );

    final beograd = domain.createIzbornaJedinica(
      naziv: 'Grad Beograd',
      sifra: 'RS-BG',
      nivo: 'grad',
      brojStanovnika: 1400000,
      brojUpisanihBiraca: 1300000,
      nadredjenaJedinica: srbija,
    );

    final juznaIstocna = domain.createIzbornaJedinica(
      naziv: 'Južna i Istočna Srbija',
      sifra: 'RS-JIS',
      nivo: 'region',
      brojStanovnika: 1500000,
      brojUpisanihBiraca: 1400000,
      nadredjenaJedinica: srbija,
    );

    final sumadijaZapad = domain.createIzbornaJedinica(
      naziv: 'Šumadija i Zapadna Srbija',
      sifra: 'RS-SZS',
      nivo: 'region',
      brojStanovnika: 1900000,
      brojUpisanihBiraca: 1800000,
      nadredjenaJedinica: srbija,
    );

    // Kreiramo nekoliko opština u Beogradu kao primer
    final noviBeogad = domain.createIzbornaJedinica(
      naziv: 'Novi Beograd',
      sifra: 'RS-BG-NB',
      nivo: 'opština',
      brojStanovnika: 220000,
      brojUpisanihBiraca: 200000,
      nadredjenaJedinica: beograd,
    );

    final vracar = domain.createIzbornaJedinica(
      naziv: 'Vračar',
      sifra: 'RS-BG-VR',
      nivo: 'opština',
      brojStanovnika: 60000,
      brojUpisanihBiraca: 55000,
      nadredjenaJedinica: beograd,
    );

    // Kreiramo nekoliko opština u Vojvodini
    final noviSad = domain.createIzbornaJedinica(
      naziv: 'Novi Sad',
      sifra: 'RS-VOJ-NS',
      nivo: 'grad',
      brojStanovnika: 380000,
      brojUpisanihBiraca: 350000,
      nadredjenaJedinica: vojvodina,
    );

    final subotica = domain.createIzbornaJedinica(
      naziv: 'Subotica',
      sifra: 'RS-VOJ-SU',
      nivo: 'grad',
      brojStanovnika: 140000,
      brojUpisanihBiraca: 125000,
      nadredjenaJedinica: vojvodina,
    );

    print('Kreirano ${domain.izborneJedinice.length} izbornih jedinica\n');

    // 5. Kreiranje izbornih lista
    print('Kreiranje izbornih lista...');

    final snsLista = domain.createIzbornaLista(
      naziv: 'Aleksandar Vučić - Srbija ne sme da stane',
      redniBroj: 1,
      stranka: sns,
    );

    final spsLista = domain.createIzbornaLista(
      naziv: 'SPS - Jedinstvena Srbija',
      redniBroj: 2,
      stranka: sps,
    );

    final opozicijaLista = domain.createIzbornaLista(
      naziv: 'Ujedinjeni za pobedu Srbije',
      redniBroj: 3,
      koalicija: opozicijaKoalicija,
    );

    final svmLista = domain.createIzbornaLista(
      naziv: 'Savez vojvođanskih Mađara - Ištvan Pastor',
      redniBroj: 4,
      stranka: svm,
      manjinskaLista: true,
    );

    print('Kreirano ${domain.izborneListe.length} izbornih lista\n');

    // 6. Kreiranje kandidata
    print('Kreiranje kandidata na listama...');

    // Nekoliko kandidata na SNS listi
    domain.createKandidat(
      ime: 'Miloš',
      prezime: 'Vučević',
      datumRodjenja: DateTime(1974, 12, 10),
      jmbg: domain.generateJMBG(
        birthDate: DateTime(1974, 12, 10),
        gender: 'Muški',
        region: 11,
      ),
      zanimanje: 'Pravnik',
      prebivaliste: 'Novi Sad',
      pozicijaNaListi: 1,
      stranka: sns,
      izbornaLista: snsLista,
      nosilacListe: true,
      biografija: 'Predsednik SNS i bivši gradonačelnik Novog Sada.',
    );

    // Nekoliko kandidata na opozicionoj listi
    domain.createKandidat(
      ime: 'Zoran',
      prezime: 'Lutovac',
      datumRodjenja: DateTime(1964, 3, 15),
      jmbg: domain.generateJMBG(
        birthDate: DateTime(1964, 3, 15),
        gender: 'Muški',
        region: 11,
      ),
      zanimanje: 'Politikolog',
      prebivaliste: 'Beograd',
      pozicijaNaListi: 1,
      stranka: ds,
      izbornaLista: opozicijaLista,
      nosilacListe: true,
    );

    domain.createKandidat(
      ime: 'Pavle',
      prezime: 'Grbović',
      datumRodjenja: DateTime(1989, 10, 2),
      jmbg: domain.generateJMBG(
        birthDate: DateTime(1989, 10, 2),
        gender: 'Muški',
        region: 11,
      ),
      zanimanje: 'Sociolog',
      prebivaliste: 'Beograd',
      pozicijaNaListi: 2,
      stranka: pss,
      izbornaLista: opozicijaLista,
      nosilacListe: false,
    );

    print('Kreirano ${domain.kandidati.length} kandidata\n');

    // 7. Kreiranje glasača
    print('Kreiranje glasača...');

    // Generišemo 100 glasača za potrebe simulacije
    final opstine = [noviBeogad, vracar, noviSad, subotica];
    final random = Random();
    final polovi = ['Muški', 'Ženski'];

    for (int i = 0; i < 1000; i++) {
      final godina = 1940 + random.nextInt(62); // Starost od 18 do 80 godina
      final mesec = 1 + random.nextInt(12);
      final dan = 1 + random.nextInt(28);
      final datumRodjenja = DateTime(godina, mesec, dan);

      final pol = polovi[random.nextInt(polovi.length)];
      final opstina = opstine[random.nextInt(opstine.length)];

      domain.createGlasac(
        ime: 'Glasač${i + 1}',
        jmbg: domain.generateJMBG(
          birthDate: datumRodjenja,
          gender: pol,
          region: 10 + random.nextInt(10),
        ),
        datumRodjenja: datumRodjenja,
        pol: pol,
        opstina: opstina.naziv,
        birackoMesto: opstina,
      );
    }

    print('Kreirano ${domain.glasaci.length} glasača\n');

    // 8. Simulacija glasanja
    print('Simulacija glasanja...');

    // Distribucija glasova po listama
    final listeDistribucija = {
      snsLista: 0.40, // 40% glasova za SNS
      spsLista: 0.12, // 12% glasova za SPS
      opozicijaLista: 0.38, // 38% glasova za opoziciju
      svmLista: 0.05, // 5% za SVM
    };

    final listeNiz = listeDistribucija.keys.toList();
    final danas = DateTime.now();

    // Birači izlaze na glasanje
    for (final glasac in domain.glasaci) {
      if (random.nextDouble() < 0.60) {
        // Izlaznost 60%
        // Odredimo za koju listu glasa
        double kumulativnaVerovatnoca = 0.0;
        final slucajniBroj = random.nextDouble();
        IzbornaLista izabranaLista = listeNiz.first;

        for (int i = 0; i < listeNiz.length; i++) {
          kumulativnaVerovatnoca += listeDistribucija[listeNiz[i]]!;
          if (slucajniBroj <= kumulativnaVerovatnoca) {
            izabranaLista = listeNiz[i];
            break;
          }
        }

        // Kreiramo glas
        domain.createGlas(
          glasac: glasac,
          izbornaLista: izabranaLista,
          datumGlasanja: danas,
          birackoMesto: glasac.birackoMesto!,
          vreme:
              '${random.nextInt(12) + 8}:${random.nextInt(60).toString().padLeft(2, '0')}',
        );

        // Ažuriramo podatak da je glasač glasao
        glasac.glasao = true;

        // Uvećamo broj glasova za izbornu listu
        izabranaLista.brojGlasova = (izabranaLista.brojGlasova ?? 0) + 1;

        // Uvećamo broj glasalih u izbornoj jedinici
        glasac.birackoMesto!.brojGlasalih++;
      }
    }

    final ukupnoGlasalo = domain.glasovi.length;
    print(
        'Ukupno glasalo: $ukupnoGlasalo glasača (${(ukupnoGlasalo / domain.glasaci.length * 100).toStringAsFixed(2)}% izlaznost)\n');

    // 9. Računanje rezultata izbora
    print('=============================================================');
    print('REZULTATI IZBORA');
    print('=============================================================');

    // Raspodela mandata koristeći D'Hontov metod
    final liste = domain.izborneListe.toList();
    final cenzus = 0.03; // 3% cenzus
    final ukupnoMandata = 250; // Ukupno mandata u Narodnoj skupštini

    domain.raspodelaMandataDontovomMetodom(liste, ukupnoMandata,
        cenzus: cenzus);

    // Prikaz rezultata
    print('Ukupno važećih glasova: ${domain.glasovi.length}');
    print('-------------------------------------------------------------');
    for (final lista in liste) {
      final procenat = ((lista.brojGlasova ?? 0) / domain.glasovi.length * 100)
          .toStringAsFixed(2);
      print(
          '${lista.naziv}: ${lista.brojGlasova} glasova ($procenat%) - ${lista.brojMandata} mandata');
    }
    print('=============================================================');
  } catch (e, stackTrace) {
    print('Greška: $e');
    print('Stack trace: $stackTrace');
  }
}
