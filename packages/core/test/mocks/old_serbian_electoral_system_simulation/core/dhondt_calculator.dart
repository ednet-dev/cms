part of '../serbian_election.dart';

/// Predstavlja rezultat izborne liste sa brojem glasova i brojem osvojenih mandata
class RezultatListe {
  final String naziv;
  final int brojGlasova;
  bool manjinskaLista;
  int brojMandata = 0;

  RezultatListe(this.naziv, this.brojGlasova, {this.manjinskaLista = false});
}

/// Implementira D'Hondt metod za raspodelu mandata u srpskim izborima
class DontKalkulator {
  /// Izračunava raspodelu mandata korišćenjem D'Hondt metode
  /// [liste] - Lista rezultata izbornih lista sa brojem glasova
  /// [ukupnoMandata] - Ukupan broj mandata za raspodelu
  /// [cenzus] - Minimalni procenat glasova potreban (0.03 za 3%)
  /// Vraća ažuriranu listu rezultata sa dodeljenim mandatima
  List<RezultatListe> izracunajMandate(
    List<RezultatListe> liste,
    int ukupnoMandata,
    double cenzus,
  ) {
    // Izračunaj ukupan broj glasova
    int ukupnoGlasova = 0;
    for (final lista in liste) {
      ukupnoGlasova += lista.brojGlasova;
    }

    // Odredi prag cenzusa
    final pragCenzusa = (ukupnoGlasova * cenzus).round();

    // Filtriraj liste koje prelaze cenzus ili su manjinske
    final kvalifikovane =
        liste.where((lista) {
          return lista.manjinskaLista || lista.brojGlasova >= pragCenzusa;
        }).toList();

    // Inicijalizuj brojač mandata
    for (final lista in kvalifikovane) {
      lista.brojMandata = 0;
    }

    // D'Hondt metod dodele mandata
    for (int i = 0; i < ukupnoMandata; i++) {
      var maxKolicnik = 0.0;
      RezultatListe? maxLista;

      for (final lista in kvalifikovane) {
        final kolicnik = lista.brojGlasova / (lista.brojMandata + 1);
        if (kolicnik > maxKolicnik) {
          maxKolicnik = kolicnik;
          maxLista = lista;
        }
      }

      if (maxLista != null) {
        maxLista.brojMandata++;
      }
    }

    // Vrati originalnu listu sa ažuriranim mandatima
    return liste;
  }
}
