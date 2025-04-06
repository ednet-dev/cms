/// Predstavlja rezultat izborne liste sa brojem glasova i brojem osvojenih mandata
class RezultatListe {
  final String naziv;
  final int brojGlasova;
  bool manjinskaLista;
  int brojMandata = 0;
  double procenatGlasova = 0.0;

  RezultatListe(this.naziv, this.brojGlasova, {this.manjinskaLista = false});
}

/// Implementira D'Hondt metod za raspodelu mandata u srpskim izborima
class DontKalkulator {
  /// Izračunava raspodelu mandata korišćenjem D'Hondt metode
  /// [liste] - Lista rezultata izbornih lista sa brojem glasova
  /// [ukupnoMandata] - Ukupan broj mandata za raspodelu
  /// [cenzus] - Minimalni procenat glasova potreban (0.03 za 3%)
  /// [prirodniPrag] - Da li koristiti prirodni prag umesto cenzusa (za lokalne izbore)
  /// [cenzusZaManjine] - Da li manjinske liste prelaze cenzus (false = oslobođene su)
  /// Vraća ažuriranu listu rezultata sa dodeljenim mandatima
  ///
  /// TODO: Fix handling of minority parties - they should be exempt from the electoral threshold
  /// and receive mandates according to D'Hondt calculation regardless of their vote percentage.
  List<RezultatListe> izracunajMandate(
    List<RezultatListe> liste,
    int ukupnoMandata, {
    double cenzus = 0.03,
    bool prirodniPrag = false,
    bool cenzusZaManjine = false,
  }) {
    // Izračunaj ukupan broj važećih glasova
    final ukupnoGlasova = liste.fold<int>(
      0,
      (sum, lista) => sum + lista.brojGlasova,
    );

    // Izračunaj procenat glasova za svaku listu
    for (var lista in liste) {
      lista.procenatGlasova = lista.brojGlasova / ukupnoGlasova;
    }

    // Filtriraj liste koje prelaze cenzus ili su manjinske (po srpskom izbornom zakonu)
    final kvalifikovane = liste.where((lista) {
      // U slučaju prirodnog praga (lokalni izbori posle 2019.) sve liste učestvuju
      if (prirodniPrag) return true;

      // Manjinske liste su oslobođene cenzusa osim ako je drugačije naznačeno
      if (lista.manjinskaLista && !cenzusZaManjine) return true;

      // Standardni cenzus za ostale liste (3% od 2022. godine)
      return lista.procenatGlasova >= cenzus;
    }).toList();

    // Resetuj broj mandata
    for (var lista in liste) {
      lista.brojMandata = 0;
    }

    // Ako nema kvalifikovanih listi, vrati praznu listu
    if (kvalifikovane.isEmpty) {
      return liste;
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

  /// Izračunava efektivni prag pri prirodnom pragu (za manjinske liste)
  /// [ukupnoGlasova] - Ukupan broj glasova
  /// [ukupnoMandata] - Ukupan broj mandata za raspodelu
  /// Vraća približan broj glasova potreban za osvajanje barem jednog mandata
  int izracunajPrirodniPrag(int ukupnoGlasova, int ukupnoMandata) {
    // Prirodni prag je približno ukupan broj glasova podijeljen sa ukupnim brojem mandata
    return (ukupnoGlasova / ukupnoMandata).ceil();
  }
}
