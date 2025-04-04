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
  ///
  /// TODO: Fix handling of minority parties - they should be exempt from the electoral threshold
  /// and receive mandates according to D'Hondt calculation regardless of their vote percentage.
  List<RezultatListe> izracunajMandate(
    List<RezultatListe> liste,
    int ukupnoMandata,
    double cenzus,
  ) {
    // Izračunaj ukupan broj važećih glasova
    final ukupnoGlasova = liste.fold<int>(
      0,
      (sum, lista) => sum + lista.brojGlasova,
    );

    // Filtriraj liste koje prelaze cenzus (osim manjinskih lista)
    final kvalifikovane = liste.where((lista) {
      if (lista.manjinskaLista) return true;
      return lista.brojGlasova / ukupnoGlasova >= cenzus;
    }).toList();

    // Resetuj broj mandata
    for (var lista in liste) {
      lista.brojMandata = 0;
    }

    // Implementiraj D'Hondt metod
    for (var mandat = 0; mandat < ukupnoMandata; mandat++) {
      var najveciKolicnik = 0.0;
      RezultatListe? listaSaNajvecimKolicnikom;

      for (var lista in kvalifikovane) {
        // Izračunaj količnik: glasovi / (osvojeni_mandati + 1)
        final kolicnik = lista.brojGlasova / (lista.brojMandata + 1);
        if (kolicnik > najveciKolicnik) {
          najveciKolicnik = kolicnik;
          listaSaNajvecimKolicnikom = lista;
        }
      }

      if (listaSaNajvecimKolicnikom != null) {
        listaSaNajvecimKolicnikom.brojMandata++;
      }
    }

    return liste;
  }
}
