import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/transaction_provider.dart';
import '../../../../core/theme/theme.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(transactionProvider.notifier).fetchTransactions('customer_1');
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(transactionProvider);

    return Scaffold(
      backgroundColor: BrewEaseTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Transaction History'),
        elevation: 0,
      ),
      body: transactionState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : transactionState.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: BrewEaseTheme.warningRed,
                      ),
                      const SizedBox(height: 16),
                      Text(transactionState.error ?? 'Error loading transactions'),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          ref
                              .read(transactionProvider.notifier)
                              .fetchTransactions('customer_1');
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : transactionState.transactions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.receipt_long_outlined,
                            size: 64,
                            color: BrewEaseTheme.textLight,
                          ),
                          const SizedBox(height: 16),
                          const Text('No transactions yet'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: transactionState.transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactionState.transactions[index];
                        return TransactionCard(
                          transaction: transaction,
                          onTap: () {
                            ref
                                .read(transactionProvider.notifier)
                                .fetchTransactionById(transaction.id);
                            Navigator.of(context).pushNamed(
                              '/transaction-detail',
                              arguments: transaction,
                            );
                          },
                        );
                      },
                    ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final dynamic transaction;
  final VoidCallback onTap;

  const TransactionCard({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getStatusColor(transaction.status).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    _getStatusIcon(transaction.status),
                    color: _getStatusColor(transaction.status),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction #${transaction.id.substring(0, 8).toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: BrewEaseTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transaction.createdAt?.split('T').first ?? 'Unknown date',
                      style: const TextStyle(
                        fontSize: 12,
                        color: BrewEaseTheme.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${transaction.totalAmount?.toStringAsFixed(2) ?? '0.00'}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: BrewEaseTheme.primaryBrown,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(transaction.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      transaction.status.substring(0, 1).toUpperCase() +
                          transaction.status.substring(1),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(transaction.status),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return BrewEaseTheme.successGreen;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return BrewEaseTheme.warningRed;
      default:
        return BrewEaseTheme.infoBlue;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle;
      case 'pending':
        return Icons.schedule;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }
}
