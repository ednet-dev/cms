import 'dart:math';
import 'domain.dart';
import 'entities.dart';

/// Generator demografskih podataka za izbore u Srbiji
/// Implementiran kao deo EDNet Core domenske infrastrukture
class SrbijaDemografskiGenerator {
  final SerbianElectionDomain _domain;
  final Random _random = Random();

  // Raspoloživi podaci za generisanje
  final DemografskaRaspodela _raspodele = DemografskaRaspodela();

  SrbijaDemografskiGenerator(this._domain);

  /// Generiše populaciju glasača sa realističnom demografskom distribucijom
  List<Glasac> generisiPopulaciju(
    int brojGlasaca, {
    Map<IzbornaJedinica, int>? raspodelaPoJedinicama,
  }) {
    final glasaci = <Glasac>[];

    if (raspodelaPoJedinicama != null) {
      // Raspodeli glasače po izbornim jedinicama
      int preostaliGlasaci = brojGlasaca;

      for (final jedinica in raspodelaPoJedinicama.entries) {
        final izbornaJedinica = jedinica.key;
        final brojZaJedinicu = jedinica.value;

        // Proveravamo da ne premašimo ukupan broj glasača
        final stvarniBroj = brojZaJedinicu < preostaliGlasaci
            ? brojZaJedinicu
            : preostaliGlasaci;

        for (var i = 0; i < stvarniBroj; i++) {
          glasaci.add(_generisiGlasaca(birackoMesto: izbornaJedinica));
        }

        preostaliGlasaci -= stvarniBroj;
        if (preostaliGlasaci <= 0) break;
      }
    } else {
      // Generisanje bez specifične raspodele
      for (var i = 0; i < brojGlasaca; i++) {
        glasaci.add(_generisiGlasaca());
      }
    }

    return glasaci;
  }

  /// Generiše jednog glasača sa realističnim demografskim podacima
  Glasac _generisiGlasaca({IzbornaJedinica? birackoMesto}) {
    // Izbor regiona i opštine
    final region =
        _izaberiNaOsnovuRaspodele(_raspodele.raspodelaPoBrojuStanovnika);
    final opstine = _raspodele.opstinePoRegionima[region] ?? [];
    final opstina = opstine.isEmpty
        ? 'Nepoznato'
        : opstine[_random.nextInt(opstine.length)];

    // Izbor pola
    final pol = _izaberiNaOsnovuRaspodele(_raspodele.raspodelaPoPolu);

    // Generisanje datuma rođenja na osnovu starosne raspodele
    final datumRodjenja = _generisiDatumRodjenja();

    // Generisanje imena
    final String ime = _generisiIme(pol);

    // Generisanje JMBG
    final jmbg = _generisiJMBG(datumRodjenja, pol, region, opstina);

    // Kreiranje entiteta glasača kroz domenski model
    return _domain.createGlasac(
      ime: ime,
      jmbg: jmbg,
      datumRodjenja: datumRodjenja,
      pol: pol,
      opstina: opstina,
      birackoMesto: birackoMesto,
    );
  }

  /// Generiše JMBG prema pravilima za Srbiju
  String _generisiJMBG(
      DateTime datumRodjenja, String pol, String region, String opstina) {
    final dan = datumRodjenja.day.toString().padLeft(2, '0');
    final mesec = datumRodjenja.month.toString().padLeft(2, '0');
    final godina = datumRodjenja.year.toString().substring(1, 3);

    // Kod za pol (muški 000-499, ženski 500-999)
    final polOffset = pol == 'Muški' ? 0 : 5;
    final danSaPolom = datumRodjenja.day + (polOffset * 10);
    final danSaPolStr = danSaPolom.toString().padLeft(3, '0');

    // Regionalni kod
    final regionKod = _raspodele.regionskiKodovi[region]?[opstina] ??
        _raspodele.regionskiKodovi[region]?['default'] ??
        70;

    // Slučajan jedinstveni broj
    final randomBroj = (100 + _random.nextInt(900)).toString();

    // Osnova JMBG-a bez kontrolne cifre
    final osnovaJmbg = '$dan$mesec$godina$regionKod$randomBroj';

    // Izračunavanje kontrolne cifre
    int suma = 0;
    for (int i = 0; i < 13; i++) {
      if (i < osnovaJmbg.length) {
        suma += int.parse(osnovaJmbg[i]) * (7 - i % 7);
      }
    }
    final kontrolnaCifra = 11 - (suma % 11);
    final kontrolniKarakter =
        kontrolnaCifra > 9 ? '0' : kontrolnaCifra.toString();

    return '$osnovaJmbg$kontrolniKarakter';
  }

  /// Generiše datum rođenja na osnovu starosne raspodele
  DateTime _generisiDatumRodjenja() {
    final danas = DateTime.now();
    final starosnaGrupa =
        _izaberiNaOsnovuRaspodele(_raspodele.raspodelaPogodinama);

    int minGodina = 18;
    int maxGodina = 30;

    switch (starosnaGrupa) {
      case '18-30':
        minGodina = 18;
        maxGodina = 30;
        break;
      case '31-45':
        minGodina = 31;
        maxGodina = 45;
        break;
      case '46-60':
        minGodina = 46;
        maxGodina = 60;
        break;
      case '61-75':
        minGodina = 61;
        maxGodina = 75;
        break;
      case '76+':
        minGodina = 76;
        maxGodina = 100;
        break;
    }

    final godine = minGodina + _random.nextInt(maxGodina - minGodina + 1);
    final meseci = _random.nextInt(12) + 1;
    final dani = _random.nextInt(28) + 1; // Pojednostavljeno zbog februara

    return DateTime(
      danas.year - godine,
      meseci,
      dani,
    );
  }

  /// Generiše puno ime na osnovu pola
  String _generisiIme(String pol) {
    if (pol == 'Muški') {
      final ime =
          _raspodele.muskaImena[_random.nextInt(_raspodele.muskaImena.length)];
      final prezime =
          _raspodele.prezimena[_random.nextInt(_raspodele.prezimena.length)];
      return '$ime $prezime';
    } else {
      final ime = _raspodele
          .zenskaImena[_random.nextInt(_raspodele.zenskaImena.length)];
      final prezime =
          _raspodele.prezimena[_random.nextInt(_raspodele.prezimena.length)];
      return '$ime $prezime';
    }
  }

  /// Bira vrednost iz raspodele verovatnoće
  String _izaberiNaOsnovuRaspodele(Map<String, double> raspodela) {
    final vrednost = _random.nextDouble();
    double kumulativno = 0.0;

    for (final unos in raspodela.entries) {
      kumulativno += unos.value;
      if (vrednost <= kumulativno) {
        return unos.key;
      }
    }

    return raspodela.keys.first;
  }

  /// Simulira glasanje sa zadatom raspodelom glasova po izbornim listama
  void simulirajGlasanje(
    List<Glasac> glasaci,
    Map<IzbornaLista, double> raspodelaGlasova,
  ) {
    // Validacija raspodele
    double ukupanProcenat =
        raspodelaGlasova.values.fold(0, (sum, value) => sum + value);
    if (ukupanProcenat < 0.99 || ukupanProcenat > 1.01) {
      throw Exception('Zbir procenata glasova mora biti približno 1.0 (100%)');
    }

    // Evidentiranje glasova
    for (final glasac in glasaci) {
      if (glasac.glasao) continue; // Preskoči ako je već glasao

      final izbornaLista = _izaberiIzbornuListu(raspodelaGlasova);

      if (izbornaLista != null && glasac.birackoMesto != null) {
        // Kreiranje glasa kroz domenski model
        _domain.createGlas(
          glasac: glasac,
          izbornaLista: izbornaLista,
          datumGlasanja: DateTime.now(),
          birackoMesto: glasac.birackoMesto!,
          vreme: '${DateTime.now().hour}:${DateTime.now().minute}',
        );

        // Ažuriranje statusa glasača
        glasac.glasao = true;

        // Ažuriranje brojača glasova
        izbornaLista.brojGlasova = (izbornaLista.brojGlasova ?? 0) + 1;
        glasac.birackoMesto!.brojGlasalih += 1;
      }
    }
  }

  /// Izbor izborne liste na osnovu raspodele verovatnoće
  IzbornaLista? _izaberiIzbornuListu(Map<IzbornaLista, double> raspodela) {
    final vrednost = _random.nextDouble();
    double kumulativno = 0.0;

    for (final unos in raspodela.entries) {
      kumulativno += unos.value;
      if (vrednost <= kumulativno) {
        return unos.key;
      }
    }

    return null;
  }
}

/// Klasa koja enkapsulira demografske podatke za generisanje
class DemografskaRaspodela {
  // Raspodela stanovništva po regionima
  final Map<String, double> raspodelaPoBrojuStanovnika = {
    'Vojvodina': 0.265,
    'Beograd': 0.235,
    'Šumadija i Zapadna Srbija': 0.285,
    'Južna i Istočna Srbija': 0.215,
    'Kosovo i Metohija': 0.0, // Nije uključeno u izborni sistem
  };

  // Starosna raspodela prema popisu 2022
  final Map<String, double> raspodelaPogodinama = {
    '18-30': 0.173,
    '31-45': 0.260,
    '46-60': 0.252,
    '61-75': 0.224,
    '76+': 0.091,
  };

  // Rodna raspodela
  final Map<String, double> raspodelaPoPolu = {
    'Ženski': 0.51,
    'Muški': 0.49,
  };

  // Opštine po regionima
  final Map<String, List<String>> opstinePoRegionima = {
    'Beograd': [
      'Stari Grad',
      'Savski Venac',
      'Vračar',
      'Novi Beograd',
      'Zemun',
      'Čukarica',
      'Rakovica',
      'Voždovac',
      'Zvezdara',
      'Palilula',
      'Surčin',
      'Barajevo',
      'Grocka',
      'Lazarevac',
      'Obrenovac',
      'Mladenovac',
      'Sopot',
    ],
    'Vojvodina': [
      'Novi Sad',
      'Subotica',
      'Zrenjanin',
      'Pančevo',
      'Sombor',
      'Kikinda',
      'Vršac',
      'Sremska Mitrovica',
      'Bačka Palanka',
      'Inđija',
      'Ruma',
      'Bačka Topola',
      'Kula',
      'Vrbas',
      'Bečej',
      'Senta',
      'Apatin',
      'Temerin',
      'Kanjiža',
    ],
    'Šumadija i Zapadna Srbija': [
      'Kragujevac',
      'Čačak',
      'Kraljevo',
      'Užice',
      'Valjevo',
      'Kruševac',
      'Novi Pazar',
      'Jagodina',
      'Šabac',
      'Požarevac',
      'Smederevo',
      'Paraćin',
      'Gornji Milanovac',
      'Aranđelovac',
      'Loznica',
      'Vrnjačka Banja',
      'Ivanjica',
      'Knić',
      'Topola',
    ],
    'Južna i Istočna Srbija': [
      'Niš',
      'Leskovac',
      'Vranje',
      'Pirot',
      'Zaječar',
      'Bor',
      'Prokuplje',
      'Aleksinac',
      'Dimitrovgrad',
      'Negotin',
      'Knjaževac',
      'Surdulica',
      'Kuršumlija',
      'Lebane',
      'Babušnica',
      'Bosilegrad',
      'Vladičin Han',
      'Vlasotince',
      'Medveđa',
    ],
  };

  // Srpska muška imena
  final List<String> muskaImena = [
    'Aleksandar',
    'Stefan',
    'Nikola',
    'Marko',
    'Miloš',
    'Lazar',
    'Nemanja',
    'Jovan',
    'Uroš',
    'Vuk',
    'Milan',
    'Mihajlo',
    'Dušan',
    'Filip',
    'Petar',
    'Luka',
    'Đorđe',
    'Pavle',
    'Vladimir',
    'Igor',
    'Dragan',
    'Zoran',
    'Dejan',
    'Goran',
    'Branko',
    'Slobodan',
    'Nenad',
    'Srđan',
    'Bojan',
    'Saša',
  ];

  // Srpska ženska imena
  final List<String> zenskaImena = [
    'Ana',
    'Jovana',
    'Milica',
    'Jelena',
    'Marija',
    'Aleksandra',
    'Katarina',
    'Teodora',
    'Sara',
    'Kristina',
    'Tamara',
    'Dragana',
    'Snežana',
    'Marina',
    'Ivana',
    'Zorana',
    'Nataša',
    'Maja',
    'Nevena',
    'Tijana',
    'Slađana',
    'Vesna',
    'Mirjana',
    'Dušanka',
    'Milena',
    'Gordana',
    'Jasmina',
    'Ljiljana',
    'Olivera',
    'Svetlana',
  ];

  // Srpska prezimena
  final List<String> prezimena = [
    'Petrović',
    'Jovanović',
    'Nikolić',
    'Marković',
    'Đorđević',
    'Stojanović',
    'Pavlović',
    'Ilić',
    'Stanković',
    'Popović',
    'Todorović',
    'Janković',
    'Kostić',
    'Cvetković',
    'Lazarević',
    'Đukić',
    'Milošević',
    'Kovačević',
    'Savić',
    'Simić',
    'Živković',
    'Vasić',
    'Bogdanović',
    'Radovanović',
    'Stevanović',
    'Stanojević',
    'Nedeljković',
    'Tomić',
    'Obradović',
    'Krstić',
  ];

  // Regionalni kodovi za JMBG
  final Map<String, Map<String, int>> regionskiKodovi = {
    'Beograd': {
      'Stari Grad': 71,
      'Savski Venac': 71,
      'Vračar': 71,
      'Novi Beograd': 71,
      'Zemun': 71,
      'default': 71,
    },
    'Vojvodina': {
      'Novi Sad': 80,
      'Subotica': 81,
      'Zrenjanin': 82,
      'Pančevo': 83,
      'Sombor': 84,
      'default': 80,
    },
    'Šumadija i Zapadna Srbija': {
      'Kragujevac': 91,
      'Čačak': 92,
      'Kraljevo': 93,
      'Užice': 94,
      'Valjevo': 95,
      'Šabac': 96,
      'default': 91,
    },
    'Južna i Istočna Srbija': {
      'Niš': 70,
      'Leskovac': 72,
      'Vranje': 73,
      'Pirot': 74,
      'Zaječar': 75,
      'default': 70,
    },
  };
}
