import '../../domain/entities/epsode.dart';

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
}
