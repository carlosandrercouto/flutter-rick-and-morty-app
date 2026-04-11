import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/transaction_entity.dart';

class TransactionItemWidget extends StatelessWidget {
  const TransactionItemWidget({super.key, required this.transaction});

  final TransactionEntity transaction;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final dateFormatter = DateFormat('dd MMM', 'pt_BR');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF161A24),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF252A38),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF1E2233),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: Color(0xFF6C63FF),
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  dateFormatter.format(transaction.date),
                  style: const TextStyle(
                    color: Color(0xFF9BA3B8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '- ${formatter.format(transaction.amount)}',
            style: const TextStyle(
              color: Color(0xFFFF6B8A),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
