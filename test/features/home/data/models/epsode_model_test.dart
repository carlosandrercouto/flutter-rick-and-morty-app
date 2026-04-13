import 'package:flutter_template/features/home/data/models/epsode_model.dart';
import 'package:flutter_template/features/home/domain/entities/epsode.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tEpsodeModel = EpsodeModel.fromMap(map: {
    'id': 1,
    'name': 'Test',
    'air_date': 'Test',
    'episode': 'Test',
    'characters': ['https://rickandmortyapi.com/api/character/1'],
  });

  group('EpsodeModel', () {
    test('should be a subclass of Epsode entity', () {
      expect(tEpsodeModel, isA<Epsode>());
    });

    test('should return a valid model from JSON', () {
      final Map<String, dynamic> jsonMap = {
        'id': 1,
        'name': 'Test',
        'air_date': 'Test',
        'episode': 'Test',
        'characters': ['https://rickandmortyapi.com/api/character/1'],
      };

      final result = EpsodeModel.fromMap(map: jsonMap);

      expect(result.id, 1);
      expect(result.characters, [1]);
    });
  });
}
