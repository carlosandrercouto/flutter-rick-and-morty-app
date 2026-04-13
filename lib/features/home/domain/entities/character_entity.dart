import 'package:equatable/equatable.dart';

/// Entidade de domínio que representa um personagem do episódio.
class CharacterEntity extends Equatable {
  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String imageUrl;
  final String originName;
  final String locationName;

  const CharacterEntity({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.imageUrl,
    required this.originName,
    required this.locationName,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    status,
    species,
    gender,
    imageUrl,
    originName,
    locationName,
  ];
}
