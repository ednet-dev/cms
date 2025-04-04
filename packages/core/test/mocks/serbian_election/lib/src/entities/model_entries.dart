import 'package:ednet_core/ednet_core.dart';
import '../model/serbian_election_model.dart';

import 'glasac.dart';
import 'politicka_stranka.dart';
import 'koalicija.dart';
import 'izborna_lista.dart';
import 'kandidat.dart';
import 'izborna_jedinica.dart';
import 'glas.dart';

/// ModelEntries za srpski izborni sistem
class SerbianElectionModels extends DomainModels {
  SerbianElectionModels(Domain domain) : super(domain) {
    // Kreiramo model sa svim konceptima
    final serbianElectionModel = SerbianElectionModel.initModel(domain);

    // Kreiramo entries za svaki koncept
    final serbianElectionEntries = SerbianElectionEntries(serbianElectionModel);
    add(serbianElectionEntries);
  }

  SerbianElectionEntries? _serbianElectionEntries;
  SerbianElectionEntries get serbianElectionEntries {
    _serbianElectionEntries ??=
        getModelEntries('SerbianElection') as SerbianElectionEntries?;
    assert(
      _serbianElectionEntries != null,
      'SerbianElectionEntries is not defined',
    );
    return _serbianElectionEntries!;
  }

  // Getteri za kolekcije entiteta
  Glasaci get glasaci => serbianElectionEntries.glasaci;
  PolitickeStranke get politickeStranke =>
      serbianElectionEntries.politickeStranke;
  Koalicije get koalicije => serbianElectionEntries.koalicije;
  IzborneListe get izborneListe => serbianElectionEntries.izborneListe;
  Kandidati get kandidati => serbianElectionEntries.kandidati;
  IzborneJedinice get izborneJedinice => serbianElectionEntries.izborneJedinice;
  Glasovi get glasovi => serbianElectionEntries.glasovi;
}

/// Class for accessing Serbian election system entities
class SerbianElectionEntries extends ModelEntries {
  SerbianElectionEntries(Model model) : super(model);

  /// Creates a map of new entity collections for each concept from the model
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
      }
    }

    return entries;
  }

  /// Returns a new entity collection for the given concept
  @override
  Entities? newEntities(String conceptCode) {
    final concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError('$conceptCode concept does not exist.');
    }

    if (concept.code == SerbianElectionModel.GLASAC) {
      return Glasaci(concept);
    }

    if (concept.code == SerbianElectionModel.POLITICKA_STRANKA) {
      return PolitickeStranke(concept);
    }

    if (concept.code == SerbianElectionModel.KOALICIJA) {
      return Koalicije(concept);
    }

    if (concept.code == SerbianElectionModel.IZBORNA_LISTA) {
      return IzborneListe(concept);
    }

    if (concept.code == SerbianElectionModel.KANDIDAT) {
      return Kandidati(concept);
    }

    if (concept.code == SerbianElectionModel.IZBORNA_JEDINICA) {
      return IzborneJedinice(concept);
    }

    if (concept.code == SerbianElectionModel.GLAS) {
      return Glasovi(concept);
    }

    return null;
  }

  /// Returns a new entity for the given concept
  @override
  Entity? newEntity(String conceptCode) {
    final concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError('$conceptCode concept does not exist.');
    }

    if (concept.code == SerbianElectionModel.GLASAC) {
      return Glasac(concept);
    }

    if (concept.code == SerbianElectionModel.POLITICKA_STRANKA) {
      return PolitickaStranka(concept);
    }

    if (concept.code == SerbianElectionModel.KOALICIJA) {
      return Koalicija(concept);
    }

    if (concept.code == SerbianElectionModel.IZBORNA_LISTA) {
      return IzbornaLista(concept);
    }

    if (concept.code == SerbianElectionModel.KANDIDAT) {
      return Kandidat(concept);
    }

    if (concept.code == SerbianElectionModel.IZBORNA_JEDINICA) {
      return IzbornaJedinica(concept);
    }

    if (concept.code == SerbianElectionModel.GLAS) {
      return Glas(concept);
    }

    return null;
  }

  // Getters for entity collections
  Glasaci get glasaci => getEntry(SerbianElectionModel.GLASAC) as Glasaci;
  PolitickeStranke get politickeStranke =>
      getEntry(SerbianElectionModel.POLITICKA_STRANKA) as PolitickeStranke;
  Koalicije get koalicije =>
      getEntry(SerbianElectionModel.KOALICIJA) as Koalicije;
  IzborneListe get izborneListe =>
      getEntry(SerbianElectionModel.IZBORNA_LISTA) as IzborneListe;
  Kandidati get kandidati =>
      getEntry(SerbianElectionModel.KANDIDAT) as Kandidati;
  IzborneJedinice get izborneJedinice =>
      getEntry(SerbianElectionModel.IZBORNA_JEDINICA) as IzborneJedinice;
  Glasovi get glasovi => getEntry(SerbianElectionModel.GLAS) as Glasovi;
}
