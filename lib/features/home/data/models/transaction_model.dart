import '../../domain/entities/transaction_entity.dart';

/// Model de parsing das transações recebidas da API.
///
/// Segue o padrão do projeto com construtor privado [_internal]
/// e factory [fromMap] responsável pelo parsing do map da API.
class TransactionModel extends TransactionEntity {
  const TransactionModel._internal({
    required super.id,
    required super.name,
    required super.amount,
    required super.date,
  });

  /// Cria um [TransactionModel] a partir de um Map da API.
  ///
  /// Campos esperados:
  /// - `id`: String
  /// - `name`: String — descrição da transação
  /// - `amount`: num — valor em reais (double)
  /// - `date`: String ISO 8601 — ex: "2024-03-15T10:30:00Z"
  factory TransactionModel.fromMap({required Map<String, dynamic> map}) {
    return TransactionModel._internal(
      id: map['id'] as String,
      name: map['name'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
    );
  }
}
