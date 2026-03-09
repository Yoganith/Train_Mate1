import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/modern_widgets.dart';
import '../utils/number_utils.dart';
import '../services/user_session_service.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final Map<String, dynamic>? arguments;
  const BookingConfirmationScreen({super.key, this.arguments});

  @override
  State<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  
  String _bookingId = '';
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    
    _generateBookingId();
    _animationController.forward();
    _updateUserBookingCount();
    
    // Show success animation after a delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _showSuccess = true);
        HapticFeedback.heavyImpact();
      }
    });
  }

  void _generateBookingId() {
    // Generate a random booking ID
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    _bookingId = 'TR${timestamp.toString().substring(8)}';
  }
  
  void _updateUserBookingCount() {
    // Update user's booking count in profile
    if (UserSessionService.userId != null) {
      UserSessionService.bookingCount++;
      debugPrint('Booking saved for user: ${UserSessionService.userId}');
      debugPrint('PNR: ${widget.arguments?['pnr']}');
      debugPrint('Total bookings: ${UserSessionService.bookingCount}');
    }
  }

  void _downloadTicket() {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Ticket downloaded successfully!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _shareTicket() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Ticket shared successfully!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final Map<String, dynamic> args = widget.arguments ?? {
      'train': {
        'name': 'Rajdhani Express',
        'number': '12951',
        'from': 'New Delhi',
        'to': 'Mumbai Central',
        'departure': '16:55',
        'arrival': '08:15',
        'price': '₹1,845',
      },
      'selectedSeat': 'S1-1',
      'selectedCoach': 'S1',
      'passengers': [
        {'name': 'Passenger 1', 'age': 28, 'gender': 'Male', 'aadhar': '123456789012'},
      ],
    };

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar.large(
                floating: true,
                backgroundColor: Colors.white,
                elevation: 0,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking Confirmed',
                      style: textTheme.headlineMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn().slideX(),
                    Text(
                      'Your ticket is ready!',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ).animate(delay: 200.ms).fadeIn().slideX(),
                  ],
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
                  onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.share, color: colorScheme.onSurface),
                    onPressed: _shareTicket,
                  ),
                ],
              ),
              
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Success Animation
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            child: ScaleTransition(
                              scale: _scaleAnimation,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: _showSuccess 
                                      ? Colors.green.withValues(alpha: 0.15)
                                      : colorScheme.primaryContainer.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _showSuccess ? Icons.check_circle : Icons.train,
                                  size: 60,
                                  color: _showSuccess ? Colors.green.shade600 : colorScheme.primary,
                                ),
                              ),
                            ),
                          ).animate(target: _showSuccess ? 1 : 0)
                              .shimmer(duration: const Duration(milliseconds: 1000)),
                          
                          const SizedBox(height: 24),
                          
                          // Booking ID Card
                          GlassCard(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: colorScheme.primary.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Icon(
                                          Icons.confirmation_number,
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
                                              'Booking ID',
                                              style: textTheme.bodyMedium?.copyWith(
                                                color: colorScheme.onSurface.withValues(alpha: 0.6),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              _bookingId,
                                              style: textTheme.headlineSmall?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: colorScheme.onSurface,
                                                letterSpacing: 1.2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(text: _bookingId));
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: const Text('Booking ID copied!'),
                                              behavior: SnackBarBehavior.floating,
                                              backgroundColor: colorScheme.primary,
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.copy, color: colorScheme.primary),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ).animate().slideY(delay: 300.ms),
                          
                          const SizedBox(height: 20),
                          
                          // Train Details Card
                          GlassCard(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: colorScheme.primary.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Icon(
                                          Icons.train,
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
                                              (args['train']?['name'] ?? 'Rajdhani Express') as String,
                                              style: textTheme.titleLarge?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: colorScheme.onSurface,
                                              ),
                                            ),
                                            Text(
                                              'Train No. ${(args['train']?['number'] ?? '12951')}',
                                              style: textTheme.bodyMedium?.copyWith(
                                                color: colorScheme.onSurface.withValues(alpha: 0.6),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  
                                  // Journey Details
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildJourneyDetail(
                                          'Departure',
                                          (args['train']?['departure'] ?? '16:55') as String,
                                          (args['train']?['from'] ?? 'New Delhi') as String,
                                          Icons.flight_takeoff,
                                          colorScheme,
                                          textTheme,
                                        ),
                                      ),
                                      Container(
                                        width: 60,
                                        height: 3,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.5)],
                                          ),
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                      Expanded(
                                        child: _buildJourneyDetail(
                                          'Arrival',
                                          (args['train']?['arrival'] ?? '08:15') as String,
                                          (args['train']?['to'] ?? 'Mumbai Central') as String,
                                          Icons.flight_land,
                                          colorScheme,
                                          textTheme,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ).animate().slideY(delay: 400.ms),
                          
                          const SizedBox(height: 20),
                          
                          // Seat Details Card
                          GlassCard(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Seat Details',
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildSeatDetail(
                                          'Coach',
                                          (args['selectedCoach'] ?? 'S1') as String,
                                          Icons.train,
                                          colorScheme,
                                          textTheme,
                                        ),
                                      ),
                                      Expanded(
                                        child: _buildSeatDetail(
                                          'Seat',
                                          (args['selectedSeat'] ?? 'S1-1') as String,
                                          Icons.event_seat,
                                          colorScheme,
                                          textTheme,
                                        ),
                                      ),
                                      Expanded(
                                        child: _buildSeatDetail(
                                          'Class',
                                          'AC 3 Tier',
                                          Icons.airline_seat_recline_normal,
                                          colorScheme,
                                          textTheme,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ).animate().slideY(delay: 500.ms),
                          
                          const SizedBox(height: 20),
                          
                          // Passenger Details Card
                          GlassCard(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                      'Passenger Details',
                                      style: textTheme.titleMedium?.copyWith(
                                        color: colorScheme.onSurface,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  const SizedBox(height: 16),
                                  ...List.generate(
                                    (args['passengers'] as List?)?.length ?? 1,
                                    (index) {
                                      final passenger = (args['passengers'] as List?)?[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 12),
                                        child: _buildPassengerDetail(
                                          passenger?['name'] ?? 'Passenger ${index + 1}',
                                          '${passenger?['age'] ?? '25'} years • ${passenger?['gender'] ?? 'Male'}',
                                          passenger?['aadhar'] ?? '123456789012',
                                          colorScheme,
                                          textTheme,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ).animate().slideY(delay: 600.ms),
                          
                          const SizedBox(height: 20),
                          
                          // Price Summary Card
                          GlassCard(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                      'Price Summary',
                                      style: textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Base Fare',
                                        style: textTheme.bodyLarge?.copyWith(
                                          color: colorScheme.onSurface,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        args['train']?['price'] ?? '₹1,845',
                                        style: textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Passengers',
                                        style: textTheme.bodyLarge?.copyWith(
                                          color: colorScheme.onSurface,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '${(args['passengers'] as List?)?.length ?? 1}',
                                        style: textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total Amount',
                                        style: textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                      Text(
                                        '₹${(safeParseInt(((args['train']?['price'] ?? '₹1845') as String)) * ((args['passengers'] as List?)?.length ?? 1))}',
                                        style: textTheme.titleLarge?.copyWith(
                                          color: colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ).animate().slideY(delay: 700.ms),
                          
                          const SizedBox(height: 32),
                          
                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _downloadTicket,
                                  icon: const Icon(Icons.download),
                                  label: const Text('Download Ticket'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    foregroundColor: colorScheme.primary,
                                    side: BorderSide(color: colorScheme.primary),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: GradientButton(
                                  text: 'Done',
                                  icon: Icons.check,
                                  onPressed: () {
                                    Navigator.popUntil(context, (route) => route.isFirst);
                                  },
                                ),
                              ),
                            ],
                          ).animate().slideY(delay: 800.ms),
                          
                          const SizedBox(height: 20),
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
    );
  }

  Widget _buildJourneyDetail(
    String label,
    String time,
    String station,
    IconData icon,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        Text(
          station,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSeatDetail(
    String label,
    String value,
    IconData icon,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Column(
      children: [
        Icon(icon, color: colorScheme.primary, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildPassengerDetail(
    String name,
    String details,
    String aadhar,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.person,
            color: colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                details,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Text(
          'Aadhar: ${aadhar.substring(0, 4)}****${aadhar.substring(8)}',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
            fontFamily: 'monospace',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}