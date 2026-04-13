import 'package:flutter_template/features/home/data/models/epsode_model.dart';
import 'package:flutter_template/features/home/domain/entities/epsode.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tMap = {
    'id': 28,
    'name': 'The Ricklantis Mixup',
    'air_date': 'September 10, 2017',
    'episode': 'S03E07',
    'characters': [
      'https://rickandmortyapi.com/api/character/1',
      'https://rickandmortyapi.com/api/character/2',
    ],
  };

  group('EpsodeModel', () {
    test('should be a subclass of Epsode entity', () {
      final model = EpsodeModel.fromMap(map: tMap);

      expect(model, isA<Epsode>());
    });

    group('fromMap', () {
      test('should parse all fields correctly', () {
        final model = EpsodeModel.fromMap(map: tMap);

        expect(model.id, 28);
        expect(model.name, 'The Ricklantis Mixup');
        expect(model.airDate, 'September 10, 2017');
        expect(model.epsode, 'S03E07');
        expect(model.characters, [1, 2]);
      });

      test('should extract character IDs from URLs', () {
        final model = EpsodeModel.fromMap(map: {
          ...tMap,
          'characters': [
            'https://rickandmortyapi.com/api/character/1',
            'https://rickandmortyapi.com/api/character/42',
            'https://rickandmortyapi.com/api/character/123',
          ],
        });

        expect(model.characters, [1, 42, 123]);
      });

      test('should ignore URLs with non-numeric ID segments', () {
        final model = EpsodeModel.fromMap(map: {
          ...tMap,
          'characters': [
            'https://rickandmortyapi.com/api/character/1',
            'https://rickandmortyapi.com/api/character/abc',
            'https://rickandmortyapi.com/api/character/2',
          ],
        });

        expect(model.characters, [1, 2]);
      });

      test('should return an empty characters list when the field is empty', () {
        final model = EpsodeModel.fromMap(map: {
          ...tMap,
          'characters': <String>[],
        });

        expect(model.characters, isEmpty);
      });
    });

    group('Equatable', () {
      test('two models with same data should be equal', () {
        final a = EpsodeModel.fromMap(map: tMap);
        final b = EpsodeModel.fromMap(map: tMap);

        expect(a, equals(b));
      });

      test('two models with different id should not be equal', () {
        final a = EpsodeModel.fromMap(map: tMap);
        final b = EpsodeModel.fromMap(map: {...tMap, 'id': 99});

        expect(a, isNot(equals(b)));
      });
    });
  });
}
