import 'package:flutter_template/features/home/data/models/character_model.dart';
import 'package:flutter_template/features/home/domain/entities/character_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tCharacterModel = CharacterModel.fromMap(map: {
    'id': 1,
    'name': 'Rick Sanchez',
    'status': 'Alive',
    'species': 'Human',
    'gender': 'Male',
    'image': 'https://image',
    'origin': {'name': 'Earth'},
    'location': {'name': 'Earth'},
  });

  group('CharacterModel', () {
    test('should be a subclass of CharacterEntity', () {
      expect(tCharacterModel, isA<CharacterEntity>());
    });

    test('should return a valid model from JSON', () {
      final Map<String, dynamic> jsonMap = {
        'id': 1,
        'name': 'Rick Sanchez',
        'status': 'Alive',
        'species': 'Human',
        'gender': 'Male',
        'image': 'https://image',
        'origin': {'name': 'Earth'},
        'location': {'name': 'Earth'},
      };

      final result = CharacterModel.fromMap(map: jsonMap);

      expect(result.id, 1);
      expect(result.imageUrl, 'https://image');
    });
  });
}
