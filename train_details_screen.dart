import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/modern_widgets.dart';

class TrainDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? train;
  const TrainDetailsScreen({super.key, this.train});

  @override
  State<TrainDetailsScreen> createState() => _TrainDetailsScreenState();
}

class _TrainDetailsScreenState extends State<TrainDetailsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic> t = widget.train ??
        (args is Map<String, dynamic>
            ? args
            : {
                'name': 'Rajdhani Express',
                'number': '12951',
                'type': 'Superfast',
                'source': 'New Delhi',
                'destination': 'Mumbai Central',
                'departure': '16:55',
                'arrival': '08:15',
                'duration': '15h 20m',
                'distance': '1,384 km',
                'frequency': 'Daily',
                'classes': ['1A', '2A', '3A'],
                'amenities': ['Pantry Car', 'Bedroll', 'Wi-Fi', 'GPS Tracking'],
                'stations': [
                  {
                    'name': 'New Delhi',
                    'arrival': '--',
                    'departure': '16:55',
                    'day': 1,
                    'platform': '3',
                    'distance': '0 km'
                  },
                  {
                    'name': 'Mathura Jn',
                    'arrival': '18:45',
                    'departure': '18:47',
                    'day': 1,
                    'platform': '1',
                    'distance': '150 km'
                  },
                  {
                    'name': 'Kota Jn',
                    'arrival': '22:05',
                    'departure': '22:10',
                    'day': 1,
                    'platform': '2',
                    'distance': '465 km'
                  },
                  {
                    'name': 'Ratlam Jn',
                    'arrival': '02:15',
                    'departure': '02:20',
                    'day': 2,
                    'platform': '4',
                    'distance': '855 km'
                  },
                  {
                    'name': 'Vadodara Jn',
                    'arrival': '05:45',
                    'departure': '05:50',
                    'day': 2,
                    'platform': '1',
                    'distance': '1,155 km'
                  },
                  {
                    'name': 'Mumbai Central',
                    'arrival': '08:15',
                    'departure': '--',
                    'day': 2,
                    'platform': '5',
                    'distance': '1,384 km'
                  },
                ],
                'fares': {
                  '1A': '₹4,995',
                  '2A': '₹2,995',
                  '3A': '₹1,845',
                },
                'availability': {
                  '1A': 'Available',
                  '2A': 'RAC',
                  '3A': 'Limited',
                },
              });

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primaryContainer.withValues(alpha: 0.1),
              colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    pinned: true,
                    expandedHeight: 280,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  colorScheme.primaryContainer.withValues(alpha: 0.2),
                                  colorScheme.surface,
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            right: -100,
                            top: -50,
                            child: Icon(
                              Icons.train,
                              size: 300,
                              color: colorScheme.primary.withValues(alpha: 0.1),
                            ),
                          ),
                          Positioned(
                            left: 20,
                            right: 20,
                            bottom: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: colorScheme.primaryContainer,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Icon(Icons.train, 
                                                 color: colorScheme.onPrimaryContainer, size: 28),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            (t['name'] ?? '').toString(),
                                            style: textTheme.headlineMedium?.copyWith(
                                              color: colorScheme.onSurface,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Train No. ${(t['number'] ?? '').toString()} • ${(t['frequency'] ?? '').toString()}',
                                            style: textTheme.bodyLarge?.copyWith(
                                              color: colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colorScheme.primaryContainer,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        (t['type'] ?? '').toString(),
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.onPrimaryContainer,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
                      onPressed: () => Navigator.pop(context),
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.share, color: colorScheme.onSurface),
                        onPressed: () {
                          // Share train details
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.favorite_border, color: colorScheme.onSurface),
                        onPressed: () {
                          // Add to favorites
                        },
                      ),
                    ],
                  ),
                  
                  SliverToBoxAdapter(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Quick Info Card
                            GlassCard(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildTimeInfo(
                                            t['departure'],
                                            t['source'],
                                            'Departure',
                                            Icons.flight_takeoff,
                                            colorScheme,
                                            textTheme,
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: colorScheme.primaryContainer,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Icon(
                                                Icons.schedule,
                                                color: colorScheme.onPrimaryContainer,
                                                size: 20,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              t['duration'],
                                              style: textTheme.bodyMedium?.copyWith(
                                                color: colorScheme.primary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              t['distance'],
                                              style: textTheme.bodySmall?.copyWith(
                                                color: colorScheme.onSurfaceVariant,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: _buildTimeInfo(
                                            t['arrival'],
                                            t['destination'],
                                            'Arrival',
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
                            ).animate().slideY(delay: 200.ms),
                            
                            const SizedBox(height: 24),
                            
                            // Tab Bar
                            Container(
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: TabBar(
                                controller: _tabController,
                                indicator: BoxDecoration(
                                  color: colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                labelColor: colorScheme.onPrimaryContainer,
                                unselectedLabelColor: colorScheme.onSurfaceVariant,
                                labelStyle: textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                tabs: const [
                                  Tab(text: 'Classes & Fares'),
                                  Tab(text: 'Route & Timings'),
                                  Tab(text: 'Amenities'),
                                ],
                              ),
                            ).animate().fadeIn(delay: 300.ms),
                            
                            const SizedBox(height: 20),
                            
                            // Tab Content
                            SizedBox(
                              height: 400,
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  _buildClassesTab(t, colorScheme, textTheme),
                                  _buildRouteTab(t, colorScheme, textTheme),
                                  _buildAmenitiesTab(t, colorScheme, textTheme),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              // Bottom Action Bar
              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/berth-selection', arguments: t);
                          },
                          icon: const Icon(Icons.airline_seat_recline_normal),
                          label: const Text('Select Berth'),
                          style: FilledButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/order-food', arguments: t);
                          },
                          icon: const Icon(Icons.restaurant),
                          label: const Text('Order Food'),
                          style: FilledButton.styleFrom(
                            backgroundColor: colorScheme.secondary,
                            foregroundColor: colorScheme.onSecondary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ).animate().slideY(begin: 1, delay: 500.ms),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeInfo(
    String time,
    String station,
    String label,
    IconData icon,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          time,
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          station,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildClassesTab(
    Map<String, dynamic> train,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return ListView.builder(
      itemCount: train['classes'].length,
      itemBuilder: (context, index) {
        final trainClass = train['classes'][index];
        final availability = train['availability'] != null && train['availability'][trainClass] != null 
            ? train['availability'][trainClass] 
            : 'Available';
        final fareValue = train['fares'] != null && train['fares'][trainClass] != null
            ? train['fares'][trainClass]
            : 1845;
        final fare = fareValue is int ? '₹$fareValue' : fareValue.toString();
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: GlassCard(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      trainClass,
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getClassFullName(trainClass),
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getClassDescription(trainClass),
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
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.currency_rupee, 
                               size: 16, color: colorScheme.primary),
                          Text(
                            fare,
                            style: textTheme.titleLarge?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getAvailabilityColor(availability).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          availability,
                          style: textTheme.bodySmall?.copyWith(
                            color: _getAvailabilityColor(availability),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ).animate(delay: Duration(milliseconds: index * 100))
              .slideX(begin: 0.3)
              .fadeIn(),
        );
      },
    );
  }

  Widget _buildRouteTab(
    Map<String, dynamic> train,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return ListView.builder(
      itemCount: train['stations'].length,
      itemBuilder: (context, index) {
        final station = train['stations'][index];
        final isFirst = index == 0;
        final isLast = index == train['stations'].length - 1;
        
        return IntrinsicHeight(
          child: Row(
            children: [
              SizedBox(
                width: 32,
                child: Column(
                  children: [
                    Container(
                      width: 3,
                      height: 24,
                      color: isFirst
                          ? Colors.transparent
                          : colorScheme.primaryContainer,
                    ),
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: isFirst || isLast
                            ? colorScheme.primary
                            : colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.primary,
                          width: 2,
                        ),
                      ),
                    ),
                    Container(
                      width: 3,
                      height: 24,
                      color: isLast
                          ? Colors.transparent
                          : colorScheme.primaryContainer,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                station['name'],
                                style: textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Platform ${station['platform']}',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (station['arrival'] != '--')
                                Text(
                                  'Arr: ${station['arrival']}',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              if (station['departure'] != '--')
                                Text(
                                  'Dep: ${station['departure']}',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.secondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              const SizedBox(height: 4),
                              Text(
                                'Day ${station['day']}',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
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
            ],
          ).animate(delay: Duration(milliseconds: index * 100))
              .slideX(begin: 0.3)
              .fadeIn(),
        );
      },
    );
  }

  Widget _buildAmenitiesTab(
    Map<String, dynamic> train,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final amenities = train['amenities'];
    
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: amenities.length,
      itemBuilder: (context, index) {
        final amenity = amenities[index];
        return GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getAmenityIcon(amenity),
                    color: colorScheme.onPrimaryContainer,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    amenity,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ).animate(delay: Duration(milliseconds: index * 100))
            .scale(begin: const Offset(0.8, 0.8))
            .fadeIn();
      },
    );
  }

  String _getClassFullName(String classCode) {
    switch (classCode) {
      case '1A':
        return 'First AC';
      case '2A':
        return 'Second AC';
      case '3A':
        return 'Third AC';
      case 'SL':
        return 'Sleeper';
      case 'CC':
        return 'Chair Car';
      case 'EC':
        return 'Executive Chair Car';
      default:
        return classCode;
    }
  }

  String _getClassDescription(String classCode) {
    switch (classCode) {
      case '1A':
        return 'Luxury air-conditioned coach with private cabins';
      case '2A':
        return 'Air-conditioned coach with 4 berths per compartment';
      case '3A':
        return 'Air-conditioned coach with 6 berths per compartment';
      case 'SL':
        return 'Non-AC sleeper coach with 6 berths per compartment';
      case 'CC':
        return 'Air-conditioned chair car with reclining seats';
      case 'EC':
        return 'Premium air-conditioned chair car with extra legroom';
      default:
        return 'Standard coach';
    }
  }

  Color _getAvailabilityColor(String availability) {
    switch (availability.toLowerCase()) {
      case 'available':
        return Colors.green;
      case 'rac':
        return Colors.orange;
      case 'limited':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getAmenityIcon(String amenity) {
    switch (amenity.toLowerCase()) {
      case 'pantry car':
        return Icons.restaurant;
      case 'bedroll':
        return Icons.bed;
      case 'wi-fi':
        return Icons.wifi;
      case 'gps tracking':
        return Icons.location_on;
      case 'ac':
        return Icons.ac_unit;
      case 'charging':
        return Icons.battery_charging_full;
      default:
        return Icons.check_circle;
    }
  }
}