import 'package:flutter_template/features/home/data/models/character_model.dart';
import 'package:flutter_template/features/home/domain/entities/character_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tApiMap = {
    'id': 1,
    'name': 'Rick Sanchez',
    'status': 'Alive',
    'species': 'Human',
    'gender': 'Male',
    'image': 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
    'origin': {'name': 'Earth (C-137)'},
    'location': {'name': 'Citadel of Ricks'},
  };

  // Formato salvo no SQLite (campos já achatados, sem nested maps)
  const tCacheMap = {
    'id': 1,
    'name': 'Rick Sanchez',
    'status': 'Alive',
    'species': 'Human',
    'gender': 'Male',
    'image_url': 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
    'origin_name': 'Earth (C-137)',
    'location_name': 'Citadel of Ricks',
  };

  group('CharacterModel', () {
    test('should be a subclass of CharacterEntity', () {
      final model = CharacterModel.fromMap(map: tApiMap);

      expect(model, isA<CharacterEntity>());
    });

    // ── fromMap (API) ────────────────────────────────────────────────────────

    group('fromMap', () {
      test('should parse all fields correctly', () {
        final model = CharacterModel.fromMap(map: tApiMap);

        expect(model.id, 1);
        expect(model.name, 'Rick Sanchez');
        expect(model.status, 'Alive');
        expect(model.species, 'Human');
        expect(model.gender, 'Male');
        expect(
          model.imageUrl,
          'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
        );
        expect(model.originName, 'Earth (C-137)');
        expect(model.locationName, 'Citadel of Ricks');
      });

      test('should parse status "Dead" correctly', () {
        final model = CharacterModel.fromMap(
          map: {...tApiMap, 'status': 'Dead'},
        );

        expect(model.status, 'Dead');
      });

      test('should parse status "unknown" correctly', () {
        final model = CharacterModel.fromMap(
          map: {...tApiMap, 'status': 'unknown'},
        );

        expect(model.status, 'unknown');
      });
    });

    // ── fromCacheMap (SQLite) ────────────────────────────────────────────────

    group('fromCacheMap', () {
      test('should parse all fields correctly from cache map', () {
        final model = CharacterModel.fromCacheMap(map: tCacheMap);

        expect(model.id, 1);
        expect(model.name, 'Rick Sanchez');
        expect(model.status, 'Alive');
        expect(model.species, 'Human');
        expect(model.gender, 'Male');
        expect(
          model.imageUrl,
          'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
        );
        expect(model.originName, 'Earth (C-137)');
        expect(model.locationName, 'Citadel of Ricks');
      });

      test('fromCacheMap result equals fromMap result for same data', () {
        final fromApi = CharacterModel.fromMap(map: tApiMap);
        final fromCache = CharacterModel.fromCacheMap(map: tCacheMap);

        expect(fromApi, equals(fromCache));
      });
    });

    // ── toMap (serialização para SQLite) ──────────────────────────────────────

    group('toMap', () {
      test('should serialize all fields correctly', () {
        final model = CharacterModel.fromMap(map: tApiMap);
        final map = model.toMap();

        expect(map['id'], 1);
        expect(map['name'], 'Rick Sanchez');
        expect(map['status'], 'Alive');
        expect(map['species'], 'Human');
        expect(map['gender'], 'Male');
        expect(
          map['image_url'],
          'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
        );
        expect(map['origin_name'], 'Earth (C-137)');
        expect(map['location_name'], 'Citadel of Ricks');
      });

      test('toMap uses flat keys (no nested maps)', () {
        final model = CharacterModel.fromMap(map: tApiMap);
        final map = model.toMap();

        expect(map.containsKey('image_url'), isTrue);
        expect(map.containsKey('origin_name'), isTrue);
        expect(map.containsKey('location_name'), isTrue);
        // Garante que não há chaves aninhadas da API
        expect(map.containsKey('image'), isFalse);
        expect(map.containsKey('origin'), isFalse);
        expect(map.containsKey('location'), isFalse);
      });

      test('toMap → fromCacheMap roundtrip preserves data', () {
        final original = CharacterModel.fromMap(map: tApiMap);
        final roundtrip = CharacterModel.fromCacheMap(map: original.toMap());

        expect(roundtrip, equals(original));
      });
    });

    // ── Equatable ────────────────────────────────────────────────────────────

    group('Equatable', () {
      test('two models with same data should be equal', () {
        final a = CharacterModel.fromMap(map: tApiMap);
        final b = CharacterModel.fromMap(map: tApiMap);

        expect(a, equals(b));
      });

      test('two models with different id should not be equal', () {
        final a = CharacterModel.fromMap(map: tApiMap);
        final b = CharacterModel.fromMap(map: {...tApiMap, 'id': 99});

        expect(a, isNot(equals(b)));
      });
    });
  });
}
