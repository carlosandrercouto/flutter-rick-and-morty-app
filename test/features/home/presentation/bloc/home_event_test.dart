import 'package:flutter_template/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeEvent', () {
    group('LoadEpsodeEvent', () {
      test('supports value equality', () {
        expect(const LoadEpsodeEvent(id: 1), const LoadEpsodeEvent(id: 1));
      });
    });

    group('LoadCharactersEvent', () {
      test('supports value equality', () {
        expect(
          const LoadCharactersEvent(ids: [1, 2]),
          const LoadCharactersEvent(ids: [1, 2]),
        );
      });
    });
  });
}
