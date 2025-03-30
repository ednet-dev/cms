import 'dart:io';

main() {
  print("Unesite broj: ");
  var broj = int.parse(stdin.readLineSync() ?? '0');
  if (broj % 2 == 0) {
    print("Broj je paran");
  } else {
    print("Broj je neparan");
  }
}
