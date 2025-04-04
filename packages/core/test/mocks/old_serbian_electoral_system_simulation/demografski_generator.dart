part of '../serbian_election_core.dart';

import 'dart:math';

/// Generator demografskih podataka za potrebe simulacije izbora u Srbiji
class DemografskiGenerator {
  final Random random = Random();

  // Raspodela stanovništva po regionima (približni procenti)
  final Map<String, double> raspodelaPoBrojuStanovnika = {
    'Vojvodina': 0.265,
    'Beograd': 0.235,
    'Šumadija i Zapadna Srbija': 0.285,
    'Južna i Istočna Srbija': 0.215,
    'Kosovo i Metohija': 0.0, // Napomena: Trenutno nije uključeno u izborni sistem
  };

  // Starosna raspodela prema podacima iz popisa 2022. (približni procenti)
  final Map<String, double> raspodelaPogodinama = {
    '18-30': 0.173,
    '31-45': 0.260,
    '46-60': 0.252,
    '61-75': 0.224,
    '76+': 0.091,
  };

  // Rodna raspodela (približno 51% žena, 49% muškaraca)
  final Map<String, double> raspodelaPoPolu = {'Ženski': 0.51, 'Muški': 0.49};

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

  // Česta srpska imena
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

  // Česta srpska prezimena
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

  // Regionalni kodovi za generisanje JMBG
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

  /// Generiše veliki broj glasača sa realističnom demografskom distribucijom
  List<Glasac> generisiPopulaciju(
    SerbianElectionDomain domain,
    int brojGlasaca, {
    Map<IzbornaJedinica, int>? raspodelaGlasacaPoJedinicama,
    Map<PolitickaStranka, double>? raspodelaPoStrankama,
  }) {
    final glasaci = <Glasac>[];

    // Ako je zadata raspodela po izbornim jedinicama
    if (raspodelaGlasacaPoJedinicama != null) {
      int preostaliGlasaci = brojGlasaca;

      for (final unos in raspodelaGlasacaPoJedinicama.entries) {
        final izbornaJedinica = unos.key;
        final brojGlasaca = unos.value;

        final stvarniBroj = brojGlasaca < preostaliGlasaci ? brojGlasaca : preostaliGlasaci;

        for (var i = 0; i < stvarniBroj; i++) {
          final glasac = _generisiGlasaca(domain, izbornaJedinica: izbornaJedinica);
          glasaci.add(glasac);
        }

        preostaliGlasaci -= stvarniBroj;
        if (preostaliGlasaci <= 0) break;
      }
    } else {
      // Generišemo glasače bez dodeljene izborne jedinice
      for (var i = 0; i < brojGlasaca; i++) {
        final glasac = _generisiGlasaca(domain);
        glasaci.add(glasac);
      }
    }

    return glasaci;
  }

  /// Generiše jednog glasača sa realističnim demografskim podacima
  Glasac _generisiGlasaca(
    SerbianElectionDomain domain, {
    IzbornaJedinica? izbornaJedinica,
  }) {
    // Izaberi region i opštinu
    final region = _izaberiNaOsnovuRaspodele(raspodelaPoBrojuStanovnika);

    final opstine = opstinePoRegionima[region] ?? [];
    final opstina = opstine.isEmpty
        ? 'Nepoznato'
        : opstine[random.nextInt(opstine.length)];

    // Izaberi pol
    final pol = _izaberiNaOsnovuRaspodele(raspodelaPoPolu);

    // Generiši datum rođenja na osnovu starosne raspodele
    final DateTime datumRodjenja = _generisiDatumRodjenja();

    // Generiši ime i prezime
    final String ime = _generisiIme(pol);

    // Generiši JMBG
    final String jmbg = domain.generateJMBG(
      birthDate: datumRodjenja,
      gender: pol,
      region: regionskiKodovi[region]?[opstina] ?? regionskiKodovi[region]?['default'] ?? 70,
    );

    // Kreiraj glasača
    return domain.createGlasac(
      ime: ime,
      jmbg: jmbg,
      datumRodjenja: datumRodjenja,
      pol: pol,
      opstina: opstina,
      birackoMesto: izbornaJedinica,
    );
  }

  /// Izaberi vrednost iz mape na osnovu verovatnoće
  String _izaberiNaOsnovuRaspodele(Map<String, double> raspodela) {
    final vrednost = random.nextDouble();
    double kumulativnaVerovatnoca = 0.0;

    for (final unos in raspodela.entries) {
      kumulativnaVerovatnoca += unos.value;
      if (vrednost <= kumulativnaVerovatnoca) {
        return unos.key;
      }
    }

    return raspodela.keys.first; // Podrazumevana vrednost ako algoritam zataji
  }

  /// Generiši datum rođenja na osnovu starosne raspodele
  DateTime _generisiDatumRodjenja() {
    final danasnjica = DateTime.now();
    final starosnaGrupa = _izaberiNaOsnovuRaspodele(raspodelaPogodinama);

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

    final godine = minGodina + random.nextInt(maxGodina - minGodina + 1);
    final meseci = random.nextInt(12);
    final dani = random.nextInt(28) + 1; // Pojednostavljeno - max 28 dana da bismo izbegli probleme sa februarom

    return DateTime(
      danasnjica.year - godine,
      danasnjica.month - meseci,
      dani,
    );
  }

  /// Generiši puno ime na osnovu pola
  String _generisiIme(String pol) {
    if (pol == 'Muški') {
      final ime = muskaImena[random.nextInt(muskaImena.length)];
      final prezime = prezimena[random.nextInt(prezimena.length)];
      return '$ime $prezime';
    } else {
      final ime = zenskaImena[random.nextInt(zenskaImena.length)];
      final prezime = prezimena[random.nextInt(prezimena.length)];
      return '$ime $prezime';
    }
  }
} 