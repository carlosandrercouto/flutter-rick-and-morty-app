import 'package:flutter_template/features/home/data/models/epsode_model.dart';
import 'package:flutter_template/features/home/domain/entities/epsode.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tApiMap = {
    'id': 28,
    'name': 'The Ricklantis Mixup',
    'air_date': 'September 10, 2017',
    'episode': 'S03E07',
    'characters': [
      'https://rickandmortyapi.com/api/character/1',
      'https://rickandmortyapi.com/api/character/2',
    ],
  };

  // Formato salvo no SQLite (IDs já como int)
  const tCacheMap = {
    'id': 28,
    'name': 'The Ricklantis Mixup',
    'air_date': 'September 10, 2017',
    'episode': 'S03E07',
    'characters': [1, 2],
  };

  group('EpsodeModel', () {
    test('should be a subclass of Epsode entity', () {
      final model = EpsodeModel.fromMap(map: tApiMap);

      expect(model, isA<Epsode>());
    });

    // ── fromMap (API) ────────────────────────────────────────────────────────

    group('fromMap', () {
      test('should parse all fields correctly', () {
        final model = EpsodeModel.fromMap(map: tApiMap);

        expect(model.id, 28);
        expect(model.name, 'The Ricklantis Mixup');
        expect(model.airDate, 'September 10, 2017');
        expect(model.epsode, 'S03E07');
        expect(model.characters, [1, 2]);
      });

      test('should extract character IDs from URLs', () {
        final model = EpsodeModel.fromMap(map: {
          ...tApiMap,
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
          ...tApiMap,
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
          ...tApiMap,
          'characters': <String>[],
        });

        expect(model.characters, isEmpty);
      });
    });

    // ── fromCacheMap (SQLite) ────────────────────────────────────────────────

    group('fromCacheMap', () {
      test('should parse all fields correctly from cache map', () {
        final model = EpsodeModel.fromCacheMap(map: tCacheMap);

        expect(model.id, 28);
        expect(model.name, 'The Ricklantis Mixup');
        expect(model.airDate, 'September 10, 2017');
        expect(model.epsode, 'S03E07');
        expect(model.characters, [1, 2]);
      });

      test('fromCacheMap result equals fromMap result for same data', () {
        final fromApi = EpsodeModel.fromMap(map: tApiMap);
        final fromCache = EpsodeModel.fromCacheMap(map: tCacheMap);

        expect(fromApi, equals(fromCache));
      });

      test('should return empty characters list when field is empty', () {
        final model = EpsodeModel.fromCacheMap(map: {
          ...tCacheMap,
          'characters': <int>[],
        });

        expect(model.characters, isEmpty);
      });
    });

    // ── toMap (serialização para SQLite) ──────────────────────────────────────

    group('toMap', () {
      test('should serialize all fields correctly', () {
        final model = EpsodeModel.fromMap(map: tApiMap);
        final map = model.toMap();

        expect(map['id'], 28);
        expect(map['name'], 'The Ricklantis Mixup');
        expect(map['air_date'], 'September 10, 2017');
        expect(map['episode'], 'S03E07');
        expect(map['characters'], [1, 2]);
      });

      test('toMap → fromCacheMap roundtrip preserves data', () {
        final original = EpsodeModel.fromMap(map: tApiMap);
        final roundtrip = EpsodeModel.fromCacheMap(map: original.toMap());

        expect(roundtrip, equals(original));
      });
    });

    // ── Equatable ────────────────────────────────────────────────────────────

    group('Equatable', () {
      test('two models with same data should be equal', () {
        final a = EpsodeModel.fromMap(map: tApiMap);
        final b = EpsodeModel.fromMap(map: tApiMap);

        expect(a, equals(b));
      });

      test('two models with different id should not be equal', () {
        final a = EpsodeModel.fromMap(map: tApiMap);
        final b = EpsodeModel.fromMap(map: {...tApiMap, 'id': 99});

        expect(a, isNot(equals(b)));
      });
    });
  });
}
