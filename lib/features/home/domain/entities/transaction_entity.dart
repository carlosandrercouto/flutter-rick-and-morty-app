import 'package:equatable/equatable.dart';

/// Representa uma transação financeira no domínio da aplicação.
///
/// Entidade imutável que encapsula os dados essenciais de uma transação
/// independente da fonte de dados (API, banco local, etc).
class TransactionEntity extends Equatable {
  final String id;

  /// Nome ou descrição da transação (ex: "Supermercado Extra").
  final String name;

  /// Valor da transação em reais.
  final double amount;

  /// Data em que a transação ocorreu.
  final DateTime date;

  const TransactionEntity({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
  });

  @override
  List<Object?> get props => [id, name, amount, date];
}
