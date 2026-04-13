import '../../domain/entities/character_entity.dart';

/// Model de parsing do personagem recebido da API Rick and Morty.
///
/// Campos esperados pela API:
/// - `id`: int
/// - `name`: String
/// - `status`: String — "Alive", "Dead", "unknown"
/// - `species`: String
/// - `gender`: String
/// - `image`: String — URL da imagem do personagem
/// - `origin`: Map com `name`
/// - `location`: Map com `name`
class CharacterModel extends CharacterEntity {
  const CharacterModel._internal({
    required super.id,
    required super.name,
    required super.status,
    required super.species,
    required super.gender,
    required super.imageUrl,
    required super.originName,
    required super.locationName,
  });

  factory CharacterModel.fromMap({required Map<String, dynamic> map}) {
    return CharacterModel._internal(
      id: map['id'] as int,
      name: map['name'] as String,
      status: map['status'] as String,
      species: map['species'] as String,
      gender: map['gender'] as String,
      imageUrl: map['image'] as String,
      originName: (map['origin'] as Map<String, dynamic>)['name'] as String,
      locationName:
          (map['location'] as Map<String, dynamic>)['name'] as String,
    );
  }

  /// Constrói um [CharacterModel] a partir de dados já parseados (ex: cache local).
  factory CharacterModel.fromCacheMap({required Map<String, dynamic> map}) {
    return CharacterModel._internal(
      id: map['id'] as int,
      name: map['name'] as String,
      status: map['status'] as String,
      species: map['species'] as String,
      gender: map['gender'] as String,
      imageUrl: map['image_url'] as String,
      originName: map['origin_name'] as String,
      locationName: map['location_name'] as String,
    );
  }

  /// Serializa o modelo para armazenamento em cache.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'gender': gender,
      'image_url': imageUrl,
      'origin_name': originName,
      'location_name': locationName,
    };
  }
}
