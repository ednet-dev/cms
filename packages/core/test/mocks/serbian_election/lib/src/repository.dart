import 'package:ednet_core/ednet_core.dart';
import 'model.dart';
import 'domain.dart';
import 'entities.dart' hide SerbianElectionEntries;

/// Serbian election repository
class SerbianElectionRepo extends CoreRepository {
  static const String repo = 'SerbianElectionRepo';

  SerbianElectionRepo([String code = repo]) : super(code) {
    // Create domain for Serbian election
    final srbDomain = Domain(SerbianElectionModel.MODEL_DOMAIN);
    domains.add(srbDomain);

    // Initialize model with all concepts
    final serbianElectionModel = SerbianElectionModel.initModel(srbDomain);

    // Create entries - we use our custom implementation that initializes all collections
    final serbianElectionEntries = SerbianElectionEntries(serbianElectionModel);

    // Make sure all entity collections are created with proper concepts
    for (final concept in serbianElectionModel.concepts) {
      if (concept.entry) {
        // This will instantiate all entity collections
        serbianElectionEntries.getEntry(concept.code);
      }
    }

    // Add domain models with initialized entries
    add(SerbianElectionDomain(srbDomain, serbianElectionEntries));
  }
}

/// Serbian election model entries
class SerbianElectionEntries extends ModelEntries {
  // Access to entity collections
  late Glasaci glasaci;
  late PolitickeStranke politickeStranke;
  late Koalicije koalicije;
  late IzborneListe izborneListe;
  late Kandidati kandidati;
  late IzborneJedinice izborneJedinice;
  late Glasovi glasovi;
  late Izboris izbori;
  late IzborniZakons izborniZakoni;
  late IzbornaKomisijas izborneKomisije;
  late TipIzboras tipoviIzbora;
  late IzborniSistems izborniSistemi;

  SerbianElectionEntries(Model model) : super(model) {
    // Initialize entity collections
    var entriesMap = newEntries();

    // Set references to entity collections
    glasaci = entriesMap[SerbianElectionModel.GLASAC] as Glasaci;
    politickeStranke =
        entriesMap[SerbianElectionModel.POLITICKA_STRANKA] as PolitickeStranke;
    koalicije = entriesMap[SerbianElectionModel.KOALICIJA] as Koalicije;
    izborneListe =
        entriesMap[SerbianElectionModel.IZBORNA_LISTA] as IzborneListe;
    kandidati = entriesMap[SerbianElectionModel.KANDIDAT] as Kandidati;
    izborneJedinice =
        entriesMap[SerbianElectionModel.IZBORNA_JEDINICA] as IzborneJedinice;
    glasovi = entriesMap[SerbianElectionModel.GLAS] as Glasovi;
    izbori = entriesMap[SerbianElectionModel.IZBORI] as Izboris;
    izborniZakoni =
        entriesMap[SerbianElectionModel.IZBORNI_ZAKON] as IzborniZakons;
    izborneKomisije =
        entriesMap[SerbianElectionModel.IZBORNA_KOMISIJA] as IzbornaKomisijas;
    tipoviIzbora = entriesMap[SerbianElectionModel.TIP_IZBORA] as TipIzboras;
    izborniSistemi =
        entriesMap[SerbianElectionModel.IZBORNI_SISTEM] as IzborniSistems;
  }

  @override
  Map<String, Entities> newEntries() {
    final entries = <String, Entities>{};

    // We'll create entries for each concept
    for (final concept in model.concepts) {
      if (concept.code == SerbianElectionModel.GLASAC) {
        entries[concept.code] = Glasaci(concept);
      } else if (concept.code == SerbianElectionModel.POLITICKA_STRANKA) {
        entries[concept.code] = PolitickeStranke(concept);
      } else if (concept.code == SerbianElectionModel.KOALICIJA) {
        entries[concept.code] = Koalicije(concept);
      } else if (concept.code == SerbianElectionModel.IZBORNA_LISTA) {
        entries[concept.code] = IzborneListe(concept);
      } else if (concept.code == SerbianElectionModel.KANDIDAT) {
        entries[concept.code] = Kandidati(concept);
      } else if (concept.code == SerbianElectionModel.IZBORNA_JEDINICA) {
        entries[concept.code] = IzborneJedinice(concept);
      } else if (concept.code == SerbianElectionModel.GLAS) {
        entries[concept.code] = Glasovi(concept);
      } else if (concept.code == SerbianElectionModel.IZBORI) {
        entries[concept.code] = Izboris(concept);
      } else if (concept.code == SerbianElectionModel.IZBORNI_ZAKON) {
        entries[concept.code] = IzborniZakons(concept);
      } else if (concept.code == SerbianElectionModel.IZBORNA_KOMISIJA) {
        entries[concept.code] = IzbornaKomisijas(concept);
      } else if (concept.code == SerbianElectionModel.TIP_IZBORA) {
        entries[concept.code] = TipIzboras(concept);
      } else if (concept.code == SerbianElectionModel.IZBORNI_SISTEM) {
        entries[concept.code] = IzborniSistems(concept);
      }
    }

    return entries;
  }
}
