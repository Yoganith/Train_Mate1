import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/modern_drawer.dart';
import '../widgets/modern_bottom_nav.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  final _scrollController = ScrollController();
  bool _showFloatingButton = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
    
    _scrollController.addListener(() {
      setState(() {
        _showFloatingButton = _scrollController.offset > 200;
      });
    });
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      drawer: const ModernDrawer(),
      bottomNavigationBar: ModernBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 1) {
            Navigator.pushNamed(context, '/transactions');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/train_search');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/account');
          }
        },
      ),
      floatingActionButton: _showFloatingButton
          ? FloatingActionButton.extended(
              onPressed: _scrollToTop,
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.arrow_upward),
              label: const Text('Top'),
            ).animate().scale()
          : null,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Enhanced App Bar
            SliverAppBar.large(
              floating: true,
              pinned: true,
              expandedHeight: 200,
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  final isCollapsed = constraints.maxHeight <= kToolbarHeight + 50;
                  return FlexibleSpaceBar(
                    centerTitle: false,
                    titlePadding: EdgeInsets.only(
                      left: isCollapsed ? 56 : 20,
                      right: 20,
                      bottom: isCollapsed ? 16 : 16,
                    ),
                    title: Text(
                      'RailBuddy',
                      style: textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: isCollapsed ? 20 : 32,
                      ),
                    ),
                    expandedTitleScale: 1.0,
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                          ),
                        ),
                        Positioned(
                          right: -40,
                          top: -20,
                          child: Icon(
                            Icons.train,
                            size: 160,
                            color: Colors.white.withOpacity(0.08),
                          ).animate(onPlay: (controller) => controller.repeat())
                              .shimmer(duration: const Duration(seconds: 3)),
                        ),
                        Positioned(
                          left: 20,
                          top: 90,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              shape: BoxShape.circle,
                            ),
                          ).animate().scale(delay: 500.ms),
                        ),
                        Positioned(
                          right: 40,
                          bottom: 70,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              shape: BoxShape.circle,
                            ),
                          ).animate().scale(delay: 700.ms),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Search Bar Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/train_search');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Search trains, routes, stations...',
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.tune,
                          color: Colors.grey.shade400,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.2, end: 0),
            ),

            // Quick Stats Section
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 1,
                          child: _buildStatCard(
                            '12',
                            'Bookings',
                            Icons.confirmation_number,
                            Theme.of(context).colorScheme.primary.withOpacity(0.12),
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: _buildStatCard(
                            '₹4,590',
                            'Spent',
                            Icons.currency_rupee,
                            Theme.of(context).colorScheme.primary.withOpacity(0.12),
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: _buildStatCard(
                            '4.8',
                            'Rating',
                            Icons.star,
                            Colors.amber.withOpacity(0.1),
                            Colors.amber.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Quick Actions Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Row(
                  children: [
                    Text(
                      'Quick Actions',
                      style: textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/train_search');
                      },
                      child: Text(
                        'View All',
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 300.ms),
            ),

            // Main Features Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                delegate: SliverChildListDelegate([
                  _buildEnhancedFeatureCard(
                    context,
                    Icons.search,
                    "Search Trains",
                    'Find and book train tickets',
                    '/train_search',
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.12),
                  ),
                  _buildEnhancedFeatureCard(
                    context,
                    Icons.directions_railway,
                    "My Bookings",
                    'View your bookings',
                    '/transactions',
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.12),
                  ),
                  _buildEnhancedFeatureCard(
                    context,
                    Icons.airline_seat_recline_normal,
                    "Seat Selection",
                    'Choose your preferred seat',
                    '/berth-selection',
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.12),
                  ),
                  _buildEnhancedFeatureCard(
                    context,
                    Icons.restaurant,
                    "Order Food",
                    'Order food to your seat',
                    '/order_food',
                    Colors.orange,
                    Colors.orange.shade100,
                  ),
                ]),
              ),
            ),

            // Recent Activity Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Text(
                  'Recent Activity',
                  style: textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 500.ms),
            ),

            // Recent Activity List
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildActivityItem(
                      Icons.confirmation_number,
                      'Booking Confirmed',
                      'Rajdhani Express - Delhi to Mumbai',
                      '2 hours ago',
                      Theme.of(context).colorScheme.primary.withOpacity(0.12),
                      Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    _buildActivityItem(
                      Icons.payment,
                      'Payment Successful',
                      '₹1,845 paid for train booking',
                      '3 hours ago',
                      Colors.green.withOpacity(0.1),
                      Colors.green,
                    ),
                    const SizedBox(height: 12),
                    _buildActivityItem(
                      Icons.restaurant,
                      'Food Order Placed',
                      'Paneer Butter Masala ordered',
                      '1 day ago',
                      Colors.orange.shade100,
                      Colors.orange.shade800,
                    ),
                  ],
                ),
              ).animate().slideY(delay: 600.ms),
            ),

            // Travel Tips Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.lightbulb_outline,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Travel Tips',
                            style: textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Always verify your ticket details and carry a valid ID proof while traveling. Arrive at the station at least 30 minutes before departure.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade800,
                          height: 1.6,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 700.ms),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color backgroundColor,
    Color foregroundColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: foregroundColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: foregroundColor, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ).animate().scale(delay: Duration(milliseconds: 200 + (value == '12' ? 0 : value == '₹4,590' ? 100 : 200)));
  }

  Widget _buildEnhancedFeatureCard(
    BuildContext context,
    IconData icon,
    String label,
    String description,
    String routeName,
    Color iconColor,
    Color backgroundColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, routeName),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, size: 32, color: iconColor),
                ),
                const SizedBox(height: 16),
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 600))
        .scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildActivityItem(
    IconData icon,
    String title,
    String subtitle,
    String time,
    Color backgroundColor,
    Color foregroundColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: foregroundColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.grey.shade900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}