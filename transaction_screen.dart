import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import '../services/booking_service.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> _userBookings = [];
  bool _loadingBookings = false;

  final List<Map<String, dynamic>> transactions = [
    {
      'id': 'TXN001',
      'type': 'Booking',
      'amount': 1250.0,
      'date': '2024-01-15',
      'status': 'Completed',
      'description': 'Train booking - Mumbai to Delhi',
      'icon': Icons.train,
    },
    {
      'id': 'TXN002',
      'type': 'Food Order',
      'amount': 450.0,
      'date': '2024-01-14',
      'status': 'Completed',
      'description': 'Food order during journey',
      'icon': Icons.restaurant,
    },
    {
      'id': 'TXN003',
      'type': 'Refund',
      'amount': -500.0,
      'date': '2024-01-10',
      'status': 'Processed',
      'description': 'Cancellation refund',
      'icon': Icons.refresh,
    },
    {
      'id': 'TXN004',
      'type': 'Booking',
      'amount': 800.0,
      'date': '2024-01-08',
      'status': 'Pending',
      'description': 'Train booking - Delhi to Bangalore',
      'icon': Icons.train,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    setState(() => _loadingBookings = true);
    try {
      final bookings = await BookingService.getUserBookings();
      setState(() => _userBookings = bookings);
    } catch (e) {
      if (kDebugMode) print('Failed to fetch bookings: $e');
    } finally {
      setState(() => _loadingBookings = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'processed':
        return Colors.blue;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isNegative = transaction['amount'] < 0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Show transaction details
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  transaction['icon'] as IconData,
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction['description'],
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transaction['id'],
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transaction['date'],
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isNegative ? '-' : '+'}₹${transaction['amount'].abs().toStringAsFixed(0)}',
                    style: textTheme.titleMedium?.copyWith(
                      color: isNegative ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(transaction['status'])
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      transaction['status'],
                      style: textTheme.labelSmall?.copyWith(
                        color: _getStatusColor(transaction['status']),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: Duration(milliseconds: index * 100))
        .fadeIn()
        .slideX(begin: 0.2, end: 0);
  }

  Widget _buildEmptyState(String message) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transactions',
          style: textTheme.titleLarge?.copyWith(
            color: Colors.white,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          indicatorColor: colorScheme.primary,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Bookings'),
            Tab(text: 'Food'),
            Tab(text: 'Refunds'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // All Transactions
          transactions.isEmpty
              ? _buildEmptyState('No transactions found')
              : ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    return _buildTransactionCard(transactions[index], index);
                  },
                ),

          // Bookings (from backend)
          _loadingBookings
              ? Center(child: CircularProgressIndicator())
              : (_userBookings.isEmpty
                  ? _buildEmptyState('No bookings found')
                  : ListView.builder(
                      itemCount: _userBookings.length,
                      itemBuilder: (context, index) {
                        final b = _userBookings[index];
                        final tx = {
                          'id': b['_id'] ?? b['id'] ?? 'BK${index + 1}',
                          'type': 'Booking',
                          'amount': (b['totalAmount'] ?? 0).toDouble(),
                          'date': (b['bookingDate'] ?? '').toString(),
                          'status': b['bookingStatus'] ?? 'CONFIRMED',
                          'description': '${b['train']?['trainName'] ?? b['trainId'] ?? 'Train Booking'}',
                          'icon': Icons.train,
                        };
                        return _buildTransactionCard(tx, index);
                      },
                    )),

          // Food Orders
          transactions.where((t) => t['type'] == 'Food Order').isEmpty
              ? _buildEmptyState('No food order transactions found')
              : ListView.builder(
                  itemCount: transactions
                      .where((t) => t['type'] == 'Food Order')
                      .length,
                  itemBuilder: (context, index) {
                    final foodTransactions = transactions
                        .where((t) => t['type'] == 'Food Order')
                        .toList();
                    return _buildTransactionCard(foodTransactions[index], index);
                  },
                ),

          // Refunds
          transactions.where((t) => t['type'] == 'Refund').isEmpty
              ? _buildEmptyState('No refund transactions found')
              : ListView.builder(
                  itemCount: transactions
                      .where((t) => t['type'] == 'Refund')
                      .length,
                  itemBuilder: (context, index) {
                    final refundTransactions = transactions
                        .where((t) => t['type'] == 'Refund')
                        .toList();
                    return _buildTransactionCard(refundTransactions[index], index);
                  },
                ),
        ],
      ),
    );
  }
}