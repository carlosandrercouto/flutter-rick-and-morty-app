import 'package:flutter_template/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeEvent', () {
    group('LoadHomeTransactionsEvent', () {
      test('can be instantiated', () {
        const event = LoadHomeTransactionsEvent();
        expect(event, isNotNull);
      });
    });
  });
}
