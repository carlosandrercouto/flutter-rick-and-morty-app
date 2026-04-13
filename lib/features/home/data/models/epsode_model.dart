import '../../domain/entities/epsode.dart';

/// Model de parsing do episódio recebido da API Rick and Morty.
///
/// Campos esperados pela API:
/// - `id`: int
/// - `name`: String — nome do episódio
/// - `air_date`: String — data de exibição original (ex: "September 10, 2017")
/// - `episode`: String — código do episódio no formato "SxxExx" (ex: "S03E07")
/// - `characters`: List\<String\> — lista de URLs dos personagens do episódio
class EpsodeModel extends Epsode {
  const EpsodeModel._internal({
    required super.id,
    required super.name,
    required super.airDate,
    required super.epsode,
    required super.characters,
  });

  factory EpsodeModel.fromMap({required Map<String, dynamic> map}) {
    return EpsodeModel._internal(
      id: map['id'] as int,
      name: map['name'] as String,
      airDate: map['air_date'] as String,
      epsode: map['episode'] as String,
      characters: (map['characters'] as List<dynamic>)
          .map((url) => int.tryParse((url as String).split('/').last))
          .whereType<int>()
          .toList(),
    );
  }

  /// Constrói um [EpsodeModel] a partir de dados já parseados (ex: cache local).
  factory EpsodeModel.fromCacheMap({required Map<String, dynamic> map}) {
    return EpsodeModel._internal(
      id: map['id'] as int,
      name: map['name'] as String,
      airDate: map['air_date'] as String,
      epsode: map['episode'] as String,
      characters: (map['characters'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
    );
  }

  /// Serializa o modelo para armazenamento em cache.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'air_date': airDate,
      'episode': epsode,
      'characters': characters,
    };
  }
}
