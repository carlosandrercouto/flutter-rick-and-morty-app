import 'package:flutter_template/features/home/domain/entities/entities_export.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Epsode', () {
    const tEpsode = Epsode(
      id: 28,
      name: 'The Ricklantis Mixup',
      airDate: 'September 10, 2017',
      epsode: 'S03E07',
      characters: [1, 2],
    );

    test('supports value equality via Equatable', () {
      const other = Epsode(
        id: 28,
        name: 'The Ricklantis Mixup',
        airDate: 'September 10, 2017',
        epsode: 'S03E07',
        characters: [1, 2],
      );

      expect(tEpsode, equals(other));
    });

    test('instances with different id are not equal', () {
      const other = Epsode(
        id: 99,
        name: 'The Ricklantis Mixup',
        airDate: 'September 10, 2017',
        epsode: 'S03E07',
        characters: [1, 2],
      );

      expect(tEpsode, isNot(equals(other)));
    });

    test('instances with different characters list are not equal', () {
      const other = Epsode(
        id: 28,
        name: 'The Ricklantis Mixup',
        airDate: 'September 10, 2017',
        epsode: 'S03E07',
        characters: [1],
      );

      expect(tEpsode, isNot(equals(other)));
    });

    test('props contains all fields', () {
      expect(
        tEpsode.props,
        [28, 'The Ricklantis Mixup', 'September 10, 2017', 'S03E07', [1, 2]],
      );
    });
  });

  group('CharacterEntity', () {
    const tCharacter = CharacterEntity(
      id: 1,
      name: 'Rick Sanchez',
      status: 'Alive',
      species: 'Human',
      gender: 'Male',
      imageUrl: 'https://image',
      originName: 'Earth (C-137)',
      locationName: 'Citadel of Ricks',
    );

    test('supports value equality via Equatable', () {
      const other = CharacterEntity(
        id: 1,
        name: 'Rick Sanchez',
        status: 'Alive',
        species: 'Human',
        gender: 'Male',
        imageUrl: 'https://image',
        originName: 'Earth (C-137)',
        locationName: 'Citadel of Ricks',
      );

      expect(tCharacter, equals(other));
    });

    test('instances with different id are not equal', () {
      const other = CharacterEntity(
        id: 99,
        name: 'Rick Sanchez',
        status: 'Alive',
        species: 'Human',
        gender: 'Male',
        imageUrl: 'https://image',
        originName: 'Earth (C-137)',
        locationName: 'Citadel of Ricks',
      );

      expect(tCharacter, isNot(equals(other)));
    });

    test('props contains all fields', () {
      expect(tCharacter.props, [
        1,
        'Rick Sanchez',
        'Alive',
        'Human',
        'Male',
        'https://image',
        'Earth (C-137)',
        'Citadel of Ricks',
      ]);
    });
  });
}
