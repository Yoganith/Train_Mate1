import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';
import '../widgets/aurora_components.dart';
import '../theme/app_theme.dart';
import '../utils/number_utils.dart';

class BookingSummaryScreen extends StatefulWidget {
  final Map<String, dynamic>? arguments;
  const BookingSummaryScreen({super.key, this.arguments});

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  String _selectedPaymentMethod = 'UPI';
  late double totalAmount;

  final List<Map<String, dynamic>> _paymentMethods = [
    {'name': 'UPI', 'icon': Icons.account_balance_wallet, 'description': 'Google Pay, PhonePe, Paytm'},
    {'name': 'Cards', 'icon': Icons.credit_card, 'description': 'Credit/Debit Cards'},
    {'name': 'Net Banking', 'icon': Icons.account_balance, 'description': 'All major banks'},
    {'name': 'Wallet', 'icon': Icons.wallet, 'description': 'Paytm, Freecharge, Mobikwik'},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Map<String, dynamic> get _args => widget.arguments ?? {};

  // Helper method to format price with currency and thousand separators
  String _formatPrice(dynamic price) {
    if (price == null) return '₹0.00';
    final value = price is String 
        ? double.tryParse(price) ?? 0 
        : (price as num).toDouble();
    return '₹${value.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }

  Future<void> _proceedToPayment() async {
    if (totalAmount <= 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid fare amount. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    HapticFeedback.mediumImpact();
    
    // Show processing dialog
    if (!mounted) return;
    
    try {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: AuroraGlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Processing Payment...',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.textCharcoal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;
      
      // Navigate to order food screen
      Navigator.pushNamed(
        context,
        '/order-food',
        arguments: {
          ..._args,
          'totalAmount': totalAmount,
        },
      );
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close dialog if still open
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment processing failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final trainData = _args['train'] ?? {};
    final passengers = (_args['passengers'] as List?) ?? [];
    totalAmount = _args['totalAmount'] is String
        ? double.tryParse(_args['totalAmount']) ?? 0.0
        : (_args['totalAmount'] as num?)?.toDouble() ?? 0.0;

    return Scaffold(
      backgroundColor: AppTheme.backgroundMist,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.secondaryIndigo.withOpacity(0.1),
              AppTheme.backgroundMist,
              AppTheme.accentAmber.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: AuroraAnimatedIcon(
                            icon: Icons.arrow_back_ios,
                            color: AppTheme.textCharcoal,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Booking Summary',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: AppTheme.textCharcoal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Review your booking details',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.textCharcoal.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Train Details
                          AuroraGlassCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        gradient: AppTheme.buttonGradient,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.train, color: Colors.white, size: 24),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            trainData['name'] ?? 'Rajdhani Express',
                                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                              color: AppTheme.textCharcoal,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Train No. ${trainData['number'] ?? '12951'}',
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              color: AppTheme.textCharcoal.withOpacity(0.7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildRouteInfo(
                                        'From',
                                        trainData['from'] ?? _args['from'] ?? 'New Delhi',
                                        trainData['departure'] ?? '16:55',
                                      ),
                                    ),
                                    Icon(Icons.arrow_forward, color: AppTheme.primaryCrimson),
                                    Expanded(
                                      child: _buildRouteInfo(
                                        'To',
                                        trainData['to'] ?? _args['to'] ?? 'Mumbai Central',
                                        trainData['arrival'] ?? '08:15',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ).animate().slideY(begin: 0.2, delay: 100.ms),

                          const SizedBox(height: 16),

                          // Seat Details
                          AuroraGlassCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Seat Details',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: AppTheme.textCharcoal,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        gradient: AppTheme.buttonGradient,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        '${(_args['selectedSeats'] as List?)?.length ?? 1} ${(_args['selectedSeats'] as List?)?.length == 1 ? 'Seat' : 'Seats'}',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    _buildDetailItem('Coach', _args['selectedCoach'] ?? 'S1', Icons.train),
                                    const SizedBox(width: 16),
                                    _buildDetailItem('Class', 'AC 3 Tier', Icons.airline_seat_recline_normal),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: (_args['selectedSeats'] as List? ?? ['S1-1'])
                                      .map((seat) => Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: AppTheme.primaryCrimson.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(
                                                color: AppTheme.primaryCrimson.withOpacity(0.3),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.event_seat,
                                                  size: 16,
                                                  color: AppTheme.primaryCrimson,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  seat.toString(),
                                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                    color: AppTheme.textCharcoal,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          ).animate().slideY(begin: 0.2, delay: 200.ms),                          const SizedBox(height: 16),

                          // Passenger Details
                          AuroraGlassCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Passenger Details',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: AppTheme.textCharcoal,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        gradient: AppTheme.buttonGradient,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        '${passengers.length} ${passengers.length == 1 ? 'Passenger' : 'Passengers'}',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                ...List.generate(passengers.length, (index) {
                                  final passenger = passengers[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryCrimson.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            passenger['gender'] == 'Male' 
                                                ? Icons.male 
                                                : passenger['gender'] == 'Female'
                                                    ? Icons.female
                                                    : Icons.person,
                                            color: AppTheme.primaryCrimson,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                passenger['name'] ?? 'Passenger ${index + 1}',
                                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                  color: AppTheme.textCharcoal,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                '${passenger['age']} years \u2022 ${passenger['gender']}',
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  color: AppTheme.textCharcoal.withOpacity(0.6),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ).animate().slideY(begin: 0.2, delay: 300.ms),

                          const SizedBox(height: 16),

                          // Payment Method Selection
                          AuroraGlassCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Select Payment Method',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppTheme.textCharcoal,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ...List.generate(_paymentMethods.length, (index) {
                                  final method = _paymentMethods[index];
                                  final isSelected = _selectedPaymentMethod == method['name'];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() => _selectedPaymentMethod = method['name']);
                                        HapticFeedback.lightImpact();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          gradient: isSelected ? AppTheme.buttonGradient : null,
                                          color: isSelected ? null : Colors.white.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: isSelected
                                                ? Colors.transparent
                                                : AppTheme.primaryCrimson.withOpacity(0.3),
                                          ),
                                          boxShadow: isSelected
                                              ? [
                                                  BoxShadow(
                                                    color: AppTheme.accentAmber.withOpacity(0.3),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ]
                                              : null,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              method['icon'] as IconData,
                                              color: isSelected
                                                  ? Colors.white
                                                  : AppTheme.primaryCrimson,
                                              size: 24,
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    method['name'],
                                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                      color: isSelected
                                                          ? Colors.white
                                                          : AppTheme.textCharcoal,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text(
                                                    method['description'],
                                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                      color: isSelected
                                                          ? Colors.white.withOpacity(0.8)
                                                          : AppTheme.textCharcoal.withOpacity(0.6),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Icon(
                                              isSelected ? Icons.check_circle : Icons.circle_outlined,
                                              color: isSelected ? Colors.white : AppTheme.textCharcoal.withOpacity(0.3),
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ).animate().slideY(begin: 0.2, delay: 400.ms),

                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.textCharcoal.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Total Amount
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.accentAmber.withOpacity(0.15),
                      AppTheme.accentAmber.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.accentAmber.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Amount',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textCharcoal,
                          ),
                        ),
                        Text(
                          'via $_selectedPaymentMethod',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textCharcoal.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _formatPrice(totalAmount),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppTheme.primaryCrimson,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Pay Button
              AuroraGradientButton(
                text: 'Proceed to Payment',
                icon: Icons.lock,
                onPressed: _proceedToPayment,
              ),
            ],
          ),
        ),
      ).animate().slideY(begin: 1, delay: 500.ms),
    );
  }

  Widget _buildRouteInfo(String label, String location, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textCharcoal.withOpacity(0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.textCharcoal,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          location,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textCharcoal.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryCrimson, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textCharcoal.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppTheme.textCharcoal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
