import 'package:equatable/equatable.dart';

class Epsode extends Equatable {
  final int id;
  final String name;
  final String airDate;
  final String epsode;
  final List<int> characters;

  const Epsode({
    required this.id,
    required this.name,
    required this.airDate,
    required this.epsode,
    required this.characters,
  });

  @override
  List<Object?> get props => [id, name, airDate, epsode, characters];
}
