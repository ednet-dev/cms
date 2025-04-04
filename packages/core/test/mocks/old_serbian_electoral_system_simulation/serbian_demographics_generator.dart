import 'dart:math';
import 'serbian_election_domain.dart';

/// Utility class to generate realistic Serbian demographic data
class SerbianDemographicsGenerator {
  final SerbianElectionDomain domain;
  final Random random = Random();

  // Region population distribution (approximate percentages)
  final Map<String, double> regionDistribution = {
    'Vojvodina': 0.265,
    'Belgrade': 0.235,
    'Šumadija and Western Serbia': 0.285,
    'Southern and Eastern Serbia': 0.215,
    'Kosovo and Metohija':
        0.0, // Note: Not included in current Serbian elections
  };

  // Age distribution based on 2022 census data (approximate percentages)
  final Map<String, double> ageDistribution = {
    '18-30': 0.173,
    '31-45': 0.260,
    '46-60': 0.252,
    '61-75': 0.224,
    '76+': 0.091,
  };

  // Gender distribution (approximately 51% female, 49% male)
  final Map<String, double> genderDistribution = {'Female': 0.51, 'Male': 0.49};

  // Region to municipality mapping
  final Map<String, List<String>> regionMunicipalities = {
    'Belgrade': [
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
    'Šumadija and Western Serbia': [
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
    'Southern and Eastern Serbia': [
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

  // Common Serbian first names
  final List<String> maleFirstNames = [
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
    'Miroslav',
    'Predrag',
    'Nebojša',
    'Miodrag',
    'Dalibor',
    'Vladan',
    'Novak',
    'Bogdan',
    'Vojislav',
    'Željko',
    'Darko',
    'Boško',
    'Strahinja',
    'Ljubomir',
    'Milovan',
    'Vasilije',
    'Radovan',
    'Danilo',
    'Momčilo',
    'Veljko',
    'Borislav',
    'Dragomir',
    'Veselin',
    'Milenko',
  ];

  final List<String> femaleFirstNames = [
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
    'Dijana',
    'Danijela',
    'Jovanа',
    'Nikolina',
    'Sofija',
    'Anđela',
    'Tara',
    'Danica',
    'Mila',
    'Dunja',
    'Isidora',
    'Bojana',
    'Sandra',
    'Magdalena',
    'Valentina',
    'Dejana',
    'Branka',
    'Sanja',
    'Lena',
    'Tanja',
    'Miona',
    'Olga',
  ];

  // Common Serbian last names
  final List<String> lastNames = [
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
    'Vučković',
    'Milenković',
    'Marinković',
    'Radojević',
    'Vujović',
    'Đurić',
    'Mihajlović',
    'Gajić',
    'Arsić',
    'Lukić',
    'Novaković',
    'Živić',
    'Perić',
    'Janić',
    'Blagojević',
    'Vidović',
    'Stefanović',
    'Zdravković',
    'Ljubojević',
    'Tanasković',
    'Vojnović',
    'Matić',
    'Gavrilović',
    'Ivković',
    'Stojković',
    'Milojević',
    'Sretović',
    'Antić',
    'Jakovljević',
    'Dragojević',
    'Veličković',
    'Martinović',
    'Radivojević',
    'Adamović',
    'Božović',
    'Filipović',
    'Čolić',
    'Mitić',
    'Bojović',
    'Tadić',
  ];

  // Region codes for JMBG generation
  final Map<String, Map<String, int>> regionCodes = {
    'Belgrade': {
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
    'Šumadija and Western Serbia': {
      'Kragujevac': 91,
      'Čačak': 92,
      'Kraljevo': 93,
      'Užice': 94,
      'Valjevo': 95,
      'Šabac': 96,
      'default': 91,
    },
    'Southern and Eastern Serbia': {
      'Niš': 70,
      'Leskovac': 72,
      'Vranje': 73,
      'Pirot': 74,
      'Zaječar': 75,
      'default': 70,
    },
  };

  SerbianDemographicsGenerator(this.domain);

  /// Generate a random Serbian citizen with realistic demographic attributes
  SerbianCitizen generateCitizen({
    ElectoralUnit? pollingStation,
    PoliticalParty? politicalPreference,
  }) {
    // Select region and municipality
    final region = _selectRandomByDistribution(regionDistribution);

    final municipalities = regionMunicipalities[region] ?? [];
    final municipality =
        municipalities.isEmpty
            ? 'Unknown'
            : municipalities[random.nextInt(municipalities.length)];

    // Select gender
    final gender = _selectRandomByDistribution(genderDistribution);

    // Generate birth date based on age distribution
    final DateTime birthDate = _generateBirthDate();

    // Generate name
    final String name = _generateName(gender);

    // Generate JMBG
    final String jmbg = _generateJMBG(birthDate, gender, region, municipality);

    // Create citizen entity
    return domain.createCitizen(
      name: name,
      jmbg: jmbg,
      birthDate: birthDate,
      gender: gender,
      municipality: municipality,
      pollingStation: pollingStation,
      politicalPreference: politicalPreference,
    );
  }

  /// Generate multiple citizens with realistic demographic distributions
  List<SerbianCitizen> generatePopulation(
    int count, {
    Map<ElectoralUnit, int>? voterDistribution,
    Map<PoliticalParty, double>? partyPreferenceDistribution,
  }) {
    final citizens = <SerbianCitizen>[];

    // If voter distribution is provided, allocate citizens to polling stations
    if (voterDistribution != null) {
      int remainingCitizens = count;

      for (final entry in voterDistribution.entries) {
        final pollingStation = entry.key;
        final voterCount = entry.value;

        // Ensure we don't exceed the total count
        final actualCount =
            voterCount < remainingCitizens ? voterCount : remainingCitizens;

        for (int i = 0; i < actualCount; i++) {
          // Generate political preference if available
          PoliticalParty? preference;
          if (partyPreferenceDistribution != null) {
            preference = _selectRandomPartyByDistribution(
              partyPreferenceDistribution,
            );
          }

          final citizen = generateCitizen(
            pollingStation: pollingStation,
            politicalPreference: preference,
          );

          citizens.add(citizen);
        }

        remainingCitizens -= actualCount;
        if (remainingCitizens <= 0) break;
      }
    } else {
      // If no distribution provided, just generate the requested count
      for (int i = 0; i < count; i++) {
        // Generate political preference if available
        PoliticalParty? preference;
        if (partyPreferenceDistribution != null) {
          preference = _selectRandomPartyByDistribution(
            partyPreferenceDistribution,
          );
        }

        final citizen = generateCitizen(politicalPreference: preference);

        citizens.add(citizen);
      }
    }

    return citizens;
  }

  /// Create a complete hierarchy of electoral units for Serbia
  Map<String, dynamic> generateElectoralStructure({
    int totalRegisteredVoters = 6500000,
    bool includeKosovo = false,
  }) {
    final districts = <ElectoralUnit>[];
    final municipalities = <ElectoralUnit>[];
    final pollingStations = <ElectoralUnit>[];

    // Distribution of registered voters by region
    final Map<String, double> votersByRegion = {
      'Vojvodina': 0.265,
      'Belgrade': 0.235,
      'Šumadija and Western Serbia': 0.285,
      'Southern and Eastern Serbia': 0.215,
    };

    if (includeKosovo) {
      // Adjust distribution to include Kosovo
      votersByRegion.forEach((key, value) {
        votersByRegion[key] = value * 0.95; // Scale down other regions
      });
      votersByRegion['Kosovo and Metohija'] = 0.05;
    }

    // Create districts (major regions)
    int districtCode = 1;
    for (final region in votersByRegion.keys) {
      final regionVoters =
          (totalRegisteredVoters * votersByRegion[region]!).round();

      final district = domain.createElectoralUnit(
        name: region,
        code: 'D${districtCode.toString().padLeft(2, '0')}',
        level: 'District',
        population:
            (regionVoters * 1.2).round(), // Approximate population from voters
        registeredVoters: regionVoters,
      );

      districts.add(district);
      districtCode++;

      // Create municipalities for each district
      final regionMunis = regionMunicipalities[region] ?? [];
      // Calculate voters per municipality with some randomness
      final baseVotersPerMunicipality = regionVoters / regionMunis.length;

      int municipalityCode = 1;
      for (final muni in regionMunis) {
        // Add some random variation (±20%)
        final municipalityVoters =
            (baseVotersPerMunicipality * (0.8 + random.nextDouble() * 0.4))
                .round();

        final municipality = domain.createElectoralUnit(
          name: muni,
          code:
              '${district.getAttribute('code')}-M${municipalityCode.toString().padLeft(2, '0')}',
          level: 'Municipality',
          population: (municipalityVoters * 1.25).round(),
          registeredVoters: municipalityVoters,
          parentUnit: district,
        );

        municipalities.add(municipality);
        municipalityCode++;

        // Create polling stations for each municipality
        // Typically between 1000-2000 voters per polling station
        final votersPerStation = 1500;
        final stationCount = (municipalityVoters / votersPerStation).ceil();

        for (int i = 1; i <= stationCount; i++) {
          // Last station might have fewer voters
          final stationVoters =
              i < stationCount
                  ? votersPerStation
                  : municipalityVoters -
                      (votersPerStation * (stationCount - 1));

          final pollingStation = domain.createElectoralUnit(
            name: '$muni Polling Station $i',
            code:
                '${municipality.getAttribute('code')}-PS${i.toString().padLeft(3, '0')}',
            level: 'Polling Station',
            population: (stationVoters * 1.2).round(),
            registeredVoters: stationVoters,
            parentUnit: municipality,
          );

          pollingStations.add(pollingStation);
        }
      }
    }

    return {
      'districts': districts,
      'municipalities': municipalities,
      'pollingStations': pollingStations,
    };
  }

  /// Generate political parties and coalitions based on recent Serbian elections
  Map<String, dynamic> generatePoliticalLandscape() {
    final parties = <PoliticalParty>[];
    final coalitions = <Coalition>[];
    final electoralLists = <ElectoralList>[];

    // Create major political parties
    final sns = domain.createPoliticalParty(
      name: 'Srpska Napredna Stranka',
      abbreviation: 'SNS',
      foundingDate: DateTime(2008, 10, 21),
      ideology: 'Conservative, Populist',
      leaderName: 'Miloš Vučević',
      memberCount: 750000,
    );
    parties.add(sns);

    final sps = domain.createPoliticalParty(
      name: 'Socijalistička Partija Srbije',
      abbreviation: 'SPS',
      foundingDate: DateTime(1990, 7, 27),
      ideology: 'Social democracy, Democratic socialism',
      leaderName: 'Ivica Dačić',
      memberCount: 120000,
    );
    parties.add(sps);

    final js = domain.createPoliticalParty(
      name: 'Jedinstvena Srbija',
      abbreviation: 'JS',
      foundingDate: DateTime(2004, 7, 12),
      ideology: 'Regionalism, Populism',
      leaderName: 'Dragan Marković',
      memberCount: 45000,
    );
    parties.add(js);

    final srs = domain.createPoliticalParty(
      name: 'Srpska Radikalna Stranka',
      abbreviation: 'SRS',
      foundingDate: DateTime(1991, 2, 23),
      ideology: 'Right-wing populism, Serbian nationalism',
      leaderName: 'Vojislav Šešelj',
      memberCount: 70000,
    );
    parties.add(srs);

    final ds = domain.createPoliticalParty(
      name: 'Demokratska Stranka',
      abbreviation: 'DS',
      foundingDate: DateTime(1990, 2, 3),
      ideology: 'Social liberalism, Pro-Europeanism',
      leaderName: 'Zoran Lutovac',
      memberCount: 50000,
    );
    parties.add(ds);

    final pss = domain.createPoliticalParty(
      name: 'Pokret Slobodnih Građana',
      abbreviation: 'PSG',
      foundingDate: DateTime(2017, 1, 21),
      ideology: 'Liberalism, Pro-Europeanism',
      leaderName: 'Pavle Grbović',
      memberCount: 25000,
    );
    parties.add(pss);

    final dss = domain.createPoliticalParty(
      name: 'Demokratska Stranka Srbije',
      abbreviation: 'DSS',
      foundingDate: DateTime(1992, 7, 26),
      ideology: 'Conservatism, Serbian nationalism',
      leaderName: 'Miloš Jovanović',
      memberCount: 40000,
    );
    parties.add(dss);

    final svm = domain.createPoliticalParty(
      name: 'Savez Vojvođanskih Mađara',
      abbreviation: 'SVM',
      foundingDate: DateTime(1994, 6, 18),
      ideology: 'Minority interests, Hungarian minority',
      leaderName: 'István Pásztor',
      memberCount: 15000,
      isMinorityParty: true,
    );
    parties.add(svm);

    final sdas = domain.createPoliticalParty(
      name: 'Stranka Demokratske Akcije Sandžaka',
      abbreviation: 'SDA Sandžaka',
      foundingDate: DateTime(1990, 7, 29),
      ideology: 'Minority interests, Bosniak minority',
      leaderName: 'Sulejman Ugljanin',
      memberCount: 12000,
      isMinorityParty: true,
    );
    parties.add(sdas);

    // Create coalitions
    final snsCoalition = domain.createCoalition(
      name: 'Za Našu Decu',
      formationDate: DateTime(2020, 1, 15),
      leaderParty: 'SNS',
      memberParties: [sns],
    );
    coalitions.add(snsCoalition);

    final spsJsCoalition = domain.createCoalition(
      name: 'SPS-JS',
      formationDate: DateTime(2020, 2, 10),
      leaderParty: 'SPS',
      memberParties: [sps, js],
    );
    coalitions.add(spsJsCoalition);

    // Create electoral lists
    final snsList = domain.createElectoralList(
      name: 'Aleksandar Vučić - Za Našu Decu',
      number: 1,
      coalition: snsCoalition,
    );
    electoralLists.add(snsList);

    final spsList = domain.createElectoralList(
      name: 'Ivica Dačić - SPS, JS',
      number: 2,
      coalition: spsJsCoalition,
    );
    electoralLists.add(spsList);

    final srsList = domain.createElectoralList(
      name: 'Srpska Radikalna Stranka - Dr Vojislav Šešelj',
      number: 3,
      party: srs,
    );
    electoralLists.add(srsList);

    final dsList = domain.createElectoralList(
      name: 'Demokratska Stranka',
      number: 4,
      party: ds,
    );
    electoralLists.add(dsList);

    final svmList = domain.createElectoralList(
      name: 'Savez Vojvođanskih Mađara - István Pásztor',
      number: 5,
      party: svm,
      isMinorityList: true,
    );
    electoralLists.add(svmList);

    final sdasList = domain.createElectoralList(
      name: 'SDA Sandžaka - Dr Sulejman Ugljanin',
      number: 6,
      party: sdas,
      isMinorityList: true,
    );
    electoralLists.add(sdasList);

    return {
      'parties': parties,
      'coalitions': coalitions,
      'electoralLists': electoralLists,
    };
  }

  // Helper methods

  /// Select a random item based on a probability distribution
  String _selectRandomByDistribution(Map<String, double> distribution) {
    final random = this.random.nextDouble();
    double cumulativeProbability = 0.0;

    for (final entry in distribution.entries) {
      cumulativeProbability += entry.value;
      if (random < cumulativeProbability) {
        return entry.key;
      }
    }

    // Default fallback to first item
    return distribution.keys.first;
  }

  /// Generate a random birth date based on realistic age distribution
  DateTime _generateBirthDate() {
    final currentYear = DateTime.now().year;
    final ageGroup = _selectRandomByDistribution(ageDistribution);

    int minYear;
    int maxYear;

    switch (ageGroup) {
      case '18-30':
        minYear = currentYear - 30;
        maxYear = currentYear - 18;
        break;
      case '31-45':
        minYear = currentYear - 45;
        maxYear = currentYear - 31;
        break;
      case '46-60':
        minYear = currentYear - 60;
        maxYear = currentYear - 46;
        break;
      case '61-75':
        minYear = currentYear - 75;
        maxYear = currentYear - 61;
        break;
      case '76+':
        minYear = currentYear - 95; // Assuming 95 as max age
        maxYear = currentYear - 76;
        break;
      default:
        minYear = currentYear - 65;
        maxYear = currentYear - 25;
    }

    final year = minYear + random.nextInt(maxYear - minYear);
    final month = 1 + random.nextInt(12);

    // Determine days in month (accounting for leap years)
    int maxDay;
    if (month == 2) {
      maxDay =
          (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) ? 29 : 28;
    } else if ([4, 6, 9, 11].contains(month)) {
      maxDay = 30;
    } else {
      maxDay = 31;
    }

    final day = 1 + random.nextInt(maxDay);

    return DateTime(year, month, day);
  }

  /// Generate a realistic Serbian name based on gender
  String _generateName(String gender) {
    final firstName =
        gender == 'Male'
            ? maleFirstNames[random.nextInt(maleFirstNames.length)]
            : femaleFirstNames[random.nextInt(femaleFirstNames.length)];

    final lastName = lastNames[random.nextInt(lastNames.length)];

    return '$firstName $lastName';
  }

  /// Generate a JMBG (Unique Master Citizen Number) for a citizen
  String _generateJMBG(
    DateTime birthDate,
    String gender,
    String region,
    String municipality,
  ) {
    // Get region code
    int regionCode;
    final regionInfo = regionCodes[region];

    if (regionInfo != null) {
      if (regionInfo.containsKey(municipality)) {
        regionCode = regionInfo[municipality]!;
      } else if (regionInfo.containsKey('default')) {
        regionCode = regionInfo['default']!;
      } else {
        // Fallback for regions without a default code
        regionCode = 71; // Default to Belgrade
      }
    } else {
      // Default to Belgrade if region not found
      regionCode = 71;
    }

    return domain.generateJMBG(
      birthDate: birthDate,
      gender: gender,
      regionCode: regionCode,
    );
  }

  /// Select a random party based on popularity distribution
  PoliticalParty? _selectRandomPartyByDistribution(
    Map<PoliticalParty, double> distribution,
  ) {
    final random = this.random.nextDouble();
    double cumulativeProbability = 0.0;

    for (final entry in distribution.entries) {
      cumulativeProbability += entry.value;
      if (random < cumulativeProbability) {
        return entry.key;
      }
    }

    // No preference (null) is also a possibility
    return null;
  }
}
