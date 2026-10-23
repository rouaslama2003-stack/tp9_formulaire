import 'package:flutter_test/flutter_test.dart';
import 'package:tp_inscription/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('refuse une valeur vide', () {
      expect(Validators.email(''), isNotNull);
    });
    test('refuse une adresse sans extension', () {
      expect(Validators.email('ali@gmail'), isNotNull);
    });
    test('accepte une adresse valide', () {
      expect(Validators.email('ali.ben@gmail.com'), isNull);
    });
  });

  group('Validators.motDePasse', () {
    test('trop court', () {
      expect(Validators.motDePasse('Ab1'), 'Au moins 8 caractères');
    });
    test('sans majuscule', () {
      expect(
        Validators.motDePasse('bonjour12'),
        'Au moins une lettre majuscule',
      );
    });
    test('sans chiffre', () {
      expect(Validators.motDePasse('Bonjourrr'), 'Au moins un chiffre');
    });
    test('valide', () {
      expect(Validators.motDePasse('Bonjour12'), isNull);
    });
  });

  group('Validators.confirmation', () {
    test('différente', () {
      expect(Validators.confirmation('Abc12345', 'Abc12346'), isNotNull);
    });
    test('identique', () {
      expect(Validators.confirmation('Abc12345', 'Abc12345'), isNull);
    });
  });

  group('Validators numériques', () {
    test('expérience hors bornes', () {
      expect(Validators.experience('51'), isNotNull);
    });
    test('TJM avec virgule', () {
      expect(Validators.tjm('350,50'), isNull);
    });
    test('TJM trop bas', () {
      expect(Validators.tjm('20'), isNotNull);
    });
  });

  group('Validators.biographie (facultative)', () {
    test('vide = valide', () {
      expect(Validators.biographie(''), isNull);
    });
    test('trop courte', () {
      expect(Validators.biographie('Je code.'), isNotNull);
    });
  });
}
