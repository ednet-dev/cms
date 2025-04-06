// ignore_for_file: unused_local_variable

import 'package:test/test.dart';
import '../lib/serbian_election.dart';

void main() {
  test('Simulacija srpskih izbora', () {
    // Kreiranje repozitorijuma
    final repo = SerbianElectionRepo();
    final serbianElectionDomain =
        repo.getDomainModels('SerbianElection') as SerbianElectionDomain;

    // Kreiranje izbornih jedinica
    print('== Kreiranje izbornih jedinica ==');

    final srbija = serbianElectionDomain.createIzbornaJedinica(
      naziv: 'Republika Srbija',
      sifra: 'RS',
      nivo: 'Država',
      brojStanovnika: 6800000,
      brojUpisanihBiraca: 6400000,
    );

    final vojvodina = serbianElectionDomain.createIzbornaJedinica(
      naziv: 'Vojvodina',
      sifra: 'RS-AP1',
      nivo: 'Pokrajina',
      brojStanovnika: 1800000,
      brojUpisanihBiraca: 1600000,
      nadredjenaJedinica: srbija,
    );

    final beograd = serbianElectionDomain.createIzbornaJedinica(
      naziv: 'Beograd',
      sifra: 'RS-BG',
      nivo: 'Grad',
      brojStanovnika: 1400000,
      brojUpisanihBiraca: 1200000,
      nadredjenaJedinica: srbija,
    );

    final noviSad = serbianElectionDomain.createIzbornaJedinica(
      naziv: 'Novi Sad',
      sifra: 'RS-NS',
      nivo: 'Grad',
      brojStanovnika: 350000,
      brojUpisanihBiraca: 300000,
      nadredjenaJedinica: vojvodina,
    );

    final zemun = serbianElectionDomain.createIzbornaJedinica(
      naziv: 'Zemun',
      sifra: 'RS-BG-ZEM',
      nivo: 'Opština',
      brojStanovnika: 170000,
      brojUpisanihBiraca: 140000,
      nadredjenaJedinica: beograd,
    );

    print('Kreirana izborna jedinica: ${srbija.naziv}');
    print('Kreirana izborna jedinica: ${vojvodina.naziv}');
    print('Kreirana izborna jedinica: ${beograd.naziv}');
    print('Kreirana izborna jedinica: ${noviSad.naziv}');
    print('Kreirana izborna jedinica: ${zemun.naziv}');

    // Kreiranje političkih stranaka
    print('\n== Kreiranje političkih stranaka ==');

    final sns = serbianElectionDomain.createPolitickaStranka(
      naziv: 'Srpska Napredna Stranka',
      skraceniNaziv: 'SNS',
      datumOsnivanja: DateTime(2008, 10, 21),
      ideologija: 'Konzervativizam, Nacionalizam',
      predsednik: 'Miloš Vučević',
      brojClanova: 750000,
    );

    final sps = serbianElectionDomain.createPolitickaStranka(
      naziv: 'Socijalistička Partija Srbije',
      skraceniNaziv: 'SPS',
      datumOsnivanja: DateTime(1990, 7, 17),
      ideologija: 'Socijalizam, Levica',
      predsednik: 'Ivica Dačić',
      brojClanova: 120000,
    );

    final ds = serbianElectionDomain.createPolitickaStranka(
      naziv: 'Demokratska Stranka',
      skraceniNaziv: 'DS',
      datumOsnivanja: DateTime(1989, 2, 3),
      ideologija: 'Liberalna demokratija, Progresivizam',
      predsednik: 'Zoran Lutovac',
      brojClanova: 80000,
    );

    final ssp = serbianElectionDomain.createPolitickaStranka(
      naziv: 'Stranka Slobode i Pravde',
      skraceniNaziv: 'SSP',
      datumOsnivanja: DateTime(2019, 4, 19),
      ideologija: 'Liberalizam, Evropske integracije',
      predsednik: 'Dragan Đilas',
      brojClanova: 60000,
    );

    final svm = serbianElectionDomain.createPolitickaStranka(
      naziv: 'Savez Vojvođanskih Mađara',
      skraceniNaziv: 'SVM',
      datumOsnivanja: DateTime(1994, 6, 18),
      ideologija: 'Manjinska prava, Regionalni interesi',
      predsednik: 'Ištvan Pastor',
      brojClanova: 15000,
      manjinskaStranka: true,
    );

    print('Kreirana stranka: ${sns.naziv} (${sns.skraceniNaziv})');
    print('Kreirana stranka: ${sps.naziv} (${sps.skraceniNaziv})');
    print('Kreirana stranka: ${ds.naziv} (${ds.skraceniNaziv})');
    print('Kreirana stranka: ${ssp.naziv} (${ssp.skraceniNaziv})');
    print(
      'Kreirana stranka: ${svm.naziv} (${svm.skraceniNaziv}) - manjinska: ${svm.manjinskaStranka}',
    );

    // Kreiranje koalicija
    print('\n== Kreiranje koalicija ==');

    final koalicijaZaBuducnost = serbianElectionDomain.createKoalicija(
      naziv: 'Za našu budućnost',
      datumFormiranja: DateTime(2022, 1, 15),
      nosiocKoalicije: 'Srpska Napredna Stranka',
      clanice: [sns, sps],
    );

    final koalicijaUjedinjeni = serbianElectionDomain.createKoalicija(
      naziv: 'Ujedinjeni za pobedu',
      datumFormiranja: DateTime(2022, 1, 5),
      nosiocKoalicije: 'Demokratska Stranka',
      clanice: [ds, ssp],
    );

    print('Kreirana koalicija: ${koalicijaZaBuducnost.naziv}');
    print('Kreirana koalicija: ${koalicijaUjedinjeni.naziv}');

    // Kreiranje izbornih lista
    print('\n== Kreiranje izbornih lista ==');

    final listaZaBuducnost = serbianElectionDomain.createIzbornaLista(
      naziv: 'Za našu budućnost - SNS, SPS',
      redniBroj: 1,
      koalicija: koalicijaZaBuducnost,
    );

    final listaUjedinjeni = serbianElectionDomain.createIzbornaLista(
      naziv: 'Ujedinjeni za pobedu - DS, SSP',
      redniBroj: 2,
      koalicija: koalicijaUjedinjeni,
    );

    final listaSVM = serbianElectionDomain.createIzbornaLista(
      naziv: 'Savez Vojvođanskih Mađara - SVM',
      redniBroj: 3,
      stranka: svm,
      manjinskaLista: true,
    );

    print('Kreirana izborna lista: ${listaZaBuducnost.naziv}');
    print('Kreirana izborna lista: ${listaUjedinjeni.naziv}');
    print(
      'Kreirana izborna lista: ${listaSVM.naziv} - manjinska: ${listaSVM.manjinskaLista}',
    );

    // Kreiranje glasača
    print('\n== Kreiranje glasača ==');

    final glasaci = <Glasac>[];

    final pera = serbianElectionDomain.createGlasac(
      ime: 'Petar Petrović',
      jmbg: serbianElectionDomain.generateJMBG(
        birthDate: DateTime(1985, 5, 15),
        gender: 'Muški',
        region: 71, // Beograd
      ),
      datumRodjenja: DateTime(1985, 5, 15),
      pol: 'Muški',
      opstina: 'Zemun',
      birackoMesto: zemun,
    );
    glasaci.add(pera);

    final mara = serbianElectionDomain.createGlasac(
      ime: 'Marija Marković',
      jmbg: serbianElectionDomain.generateJMBG(
        birthDate: DateTime(1990, 8, 22),
        gender: 'Ženski',
        region: 71, // Beograd
      ),
      datumRodjenja: DateTime(1990, 8, 22),
      pol: 'Ženski',
      opstina: 'Zemun',
      birackoMesto: zemun,
    );
    glasaci.add(mara);

    final joca = serbianElectionDomain.createGlasac(
      ime: 'Jovan Jovanović',
      jmbg: serbianElectionDomain.generateJMBG(
        birthDate: DateTime(1978, 3, 8),
        gender: 'Muški',
        region: 80, // Novi Sad
      ),
      datumRodjenja: DateTime(1978, 3, 8),
      pol: 'Muški',
      opstina: 'Novi Sad',
      birackoMesto: noviSad,
    );
    glasaci.add(joca);

    final ana = serbianElectionDomain.createGlasac(
      ime: 'Ana Anić',
      jmbg: serbianElectionDomain.generateJMBG(
        birthDate: DateTime(1995, 11, 3),
        gender: 'Ženski',
        region: 80, // Novi Sad
      ),
      datumRodjenja: DateTime(1995, 11, 3),
      pol: 'Ženski',
      opstina: 'Novi Sad',
      birackoMesto: noviSad,
    );
    glasaci.add(ana);

    print('Kreirano glasača: ${glasaci.length}');
    for (final glasac in glasaci) {
      print(
        'Glasač: ${glasac.ime}, JMBG: ${glasac.jmbg}, Biračko mesto: ${glasac.birackoMesto!.naziv}',
      );
    }

    // Simulacija glasanja
    print('\n== Simulacija glasanja ==');

    // Petar glasa za SNS koaliciju
    final glasPera = serbianElectionDomain.createGlas(
      glasac: pera,
      izbornaLista: listaZaBuducnost,
      datumGlasanja: DateTime(2023, 6, 1, 10, 15),
      birackoMesto: zemun,
      vreme: '10:15',
    );
    pera.glasao = true;
    zemun.brojGlasalih++;
    listaZaBuducnost.brojGlasova = (listaZaBuducnost.brojGlasova ?? 0) + 1;

    // Marija glasa za opozicionu koaliciju
    final glasMara = serbianElectionDomain.createGlas(
      glasac: mara,
      izbornaLista: listaUjedinjeni,
      datumGlasanja: DateTime(2023, 6, 1, 11, 30),
      birackoMesto: zemun,
      vreme: '11:30',
    );
    mara.glasao = true;
    zemun.brojGlasalih++;
    listaUjedinjeni.brojGlasova = (listaUjedinjeni.brojGlasova ?? 0) + 1;

    // Jovan glasa za SNS koaliciju
    final glasJoca = serbianElectionDomain.createGlas(
      glasac: joca,
      izbornaLista: listaZaBuducnost,
      datumGlasanja: DateTime(2023, 6, 1, 9, 45),
      birackoMesto: noviSad,
      vreme: '9:45',
    );
    joca.glasao = true;
    noviSad.brojGlasalih++;
    listaZaBuducnost.brojGlasova = (listaZaBuducnost.brojGlasova ?? 0) + 1;

    // Ana glasa za manjinsku listu
    final glasAna = serbianElectionDomain.createGlas(
      glasac: ana,
      izbornaLista: listaSVM,
      datumGlasanja: DateTime(2023, 6, 1, 16, 20),
      birackoMesto: noviSad,
      vreme: '16:20',
    );
    ana.glasao = true;
    noviSad.brojGlasalih++;
    listaSVM.brojGlasova = (listaSVM.brojGlasova ?? 0) + 1;

    print('Ukupno glasova po listama:');
    print('${listaZaBuducnost.naziv}: ${listaZaBuducnost.brojGlasova} glasova');
    print('${listaUjedinjeni.naziv}: ${listaUjedinjeni.brojGlasova} glasova');
    print('${listaSVM.naziv}: ${listaSVM.brojGlasova} glasova');

    print('\nIzlaznost po izbornim jedinicama:');
    print(
      '${noviSad.naziv}: ${noviSad.brojGlasalih}/${noviSad.brojUpisanihBiraca} (${(noviSad.brojGlasalih / noviSad.brojUpisanihBiraca * 100).toStringAsFixed(2)}%)',
    );
    print(
      '${zemun.naziv}: ${zemun.brojGlasalih}/${zemun.brojUpisanihBiraca} (${(zemun.brojGlasalih / zemun.brojUpisanihBiraca * 100).toStringAsFixed(2)}%)',
    );

    // Raspodela mandata
    print('\n== Raspodela mandata po D\'Hont-ovoj metodi ==');

    final izborneListe = [listaZaBuducnost, listaUjedinjeni, listaSVM];
    final ukupnoMandata = 10; // Recimo da ima 10 mandata za raspodelu

    // TODO: Manjinske liste trenutno nisu posebno tretirane u D'Hont kalkulatoru.
    // Potrebno je implementirati izuzeće od cenzusa za manjinske liste.
    final raspodela = serbianElectionDomain.raspodelaMandataDontovomMetodom(
      izborneListe,
      ukupnoMandata,
      cenzus: 0.03, // 3% cenzus
    );

    print('Raspodela mandata:');
    for (final lista in izborneListe) {
      print('${lista.naziv}: ${lista.brojMandata} mandata');
    }

    // Ispisivanje rezultata u formatu izveštaja
    print('\n==================================================');
    print('REZULTATI IZBORA');
    print('==================================================');

    // Ukupan broj glasova
    final ukupnoGlasova = izborneListe.fold<int>(
      0,
      (sum, lista) => sum + (lista.brojGlasova ?? 0),
    );

    print('Ukupno važećih glasova: $ukupnoGlasova');
    print('Ukupno raspodeljenih mandata: $ukupnoMandata');
    print('');

    // Sortiraj liste po broju mandata (pa po broju glasova ako je isti broj mandata)
    final sortiraneList = List<IzbornaLista>.from(izborneListe)
      ..sort((a, b) {
        final poredjakMandata = (b.brojMandata ?? 0).compareTo(
          a.brojMandata ?? 0,
        );
        if (poredjakMandata != 0) return poredjakMandata;
        return (b.brojGlasova ?? 0).compareTo(a.brojGlasova ?? 0);
      });

    print('Rang | Lista                      | Glasovi    | %      | Mandati');
    print('-----|----------------------------|------------|--------|--------');

    for (int i = 0; i < sortiraneList.length; i++) {
      final lista = sortiraneList[i];
      final procenat =
          ((lista.brojGlasova ?? 0) / ukupnoGlasova * 100).toStringAsFixed(2);

      print(
        '${(i + 1).toString().padRight(5)}| '
        '${lista.naziv.padRight(28)}| '
        '${(lista.brojGlasova ?? 0).toString().padRight(12)}| '
        '${procenat.padRight(8)}| '
        '${lista.brojMandata ?? 0}',
      );
    }

    print('\n==================================================');
    print('KRAJ SIMULACIJE');
    print('==================================================');
  });
}
