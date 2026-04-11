import 'package:flutter/material.dart';

import '../../../domain/entities/transaction_entity.dart';
import 'transaction_item_widget.dart';

class TransactionListWidget extends StatelessWidget {
  const TransactionListWidget({super.key, required this.transactions});

  final List<TransactionEntity> transactions;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      itemCount: transactions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return TransactionItemWidget(transaction: transactions[index]);
      },
    );
  }
}
