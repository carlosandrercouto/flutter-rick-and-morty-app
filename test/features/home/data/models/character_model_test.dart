import 'package:flutter_template/features/home/data/models/character_model.dart';
import 'package:flutter_template/features/home/domain/entities/character_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tMap = {
    'id': 1,
    'name': 'Rick Sanchez',
    'status': 'Alive',
    'species': 'Human',
    'gender': 'Male',
    'image': 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
    'origin': {'name': 'Earth (C-137)'},
    'location': {'name': 'Citadel of Ricks'},
  };

  group('CharacterModel', () {
    test('should be a subclass of CharacterEntity', () {
      final model = CharacterModel.fromMap(map: tMap);

      expect(model, isA<CharacterEntity>());
    });

    group('fromMap', () {
      test('should parse all fields correctly', () {
        final model = CharacterModel.fromMap(map: tMap);

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
        final model = CharacterModel.fromMap(map: {
          ...tMap,
          'status': 'Dead',
        });

        expect(model.status, 'Dead');
      });

      test('should parse status "unknown" correctly', () {
        final model = CharacterModel.fromMap(map: {
          ...tMap,
          'status': 'unknown',
        });

        expect(model.status, 'unknown');
      });
    });

    group('Equatable', () {
      test('two models with same data should be equal', () {
        final a = CharacterModel.fromMap(map: tMap);
        final b = CharacterModel.fromMap(map: tMap);

        expect(a, equals(b));
      });

      test('two models with different id should not be equal', () {
        final a = CharacterModel.fromMap(map: tMap);
        final b = CharacterModel.fromMap(map: {...tMap, 'id': 99});

        expect(a, isNot(equals(b)));
      });
    });
  });
}
