import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/aurora_components.dart';
import '../theme/app_theme.dart';
import '../utils/sample_data.dart';

class TrainSearchScreen extends StatefulWidget {
  const TrainSearchScreen({super.key});

  @override
  State<TrainSearchScreen> createState() => _TrainSearchScreenState();
}

class _TrainSearchScreenState extends State<TrainSearchScreen>
    with TickerProviderStateMixin {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate; // No default date - user must select
  int _selectedPassengers = 1;
  String _selectedClass = 'All Classes';
  bool _isRoundTrip = false;
  bool _showAdvancedFilters = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _classes = [
    'All Classes',
    'First AC',
    'Second AC',
    'Third AC',
    'Sleeper',
    'Chair Car',
  ];

  final _popularStations = [
    'New Delhi',
    'Mumbai Central',
    'Chennai Central',
    'Kolkata',
    'Bangalore City',
    'Hyderabad',
    'Pune',
    'Ahmedabad',
    'Jaipur',
    'Lucknow',
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
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 120)),
      helpText: 'Select Travel Date',
      confirmText: 'SELECT',
      cancelText: 'CANCEL',
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppTheme.primaryCrimson, // Selected date color
              onPrimary: Colors.white, // Selected date text
              surface: const Color(0xFF1E1E2E), // Dialog background (dark blue-grey)
              onSurface: Colors.white, // Calendar text color (white)
              secondary: AppTheme.accentAmber, // Secondary elements
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.accentAmber, // Button text color (amber)
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: const Color(0xFF1E1E2E), // Dark background
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              headerBackgroundColor: AppTheme.primaryCrimson, // Header background
              headerForegroundColor: Colors.white, // Header text
              dayStyle: const TextStyle(color: Colors.white),
              weekdayStyle: const TextStyle(color: Colors.white70),
              yearStyle: const TextStyle(color: Colors.white),
            ),
            dialogBackgroundColor: const Color(0xFF1E1E2E), // Overall dialog background
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Date selected: ${picked.day}/${picked.month}/${picked.year}'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _swapStations() {
    setState(() {
      final temp = _fromController.text;
      _fromController.text = _toController.text;
      _toController.text = temp;
    });
  }

  /// ✅ Updated to avoid type issues when passing arguments
  void _searchTrains() {
    if (_formKey.currentState?.validate() ?? false) {
      // Check if date is selected
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please select a travel date'),
            backgroundColor: AppTheme.primaryCrimson,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        return;
      }
      
      Navigator.pushNamed(
        context,
        '/train_list',
        arguments: <String, dynamic>{
          'from': _fromController.text.trim(),
          'to': _toController.text.trim(),
          'date': _selectedDate,
          'passengers': _selectedPassengers,
          'class': _selectedClass,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTripTypeToggle(),
                        const SizedBox(height: 24),
                        _buildInputCard(),
                        if (_showAdvancedFilters) ...[
                          const SizedBox(height: 16),
                          _buildAdvancedFilters()
                              .animate()
                              .slideY(delay: 300.ms),
                        ],
                        const SizedBox(height: 20),
                        _buildPopularStations()
                            .animate()
                            .fadeIn(delay: 700.ms),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AuroraBottomCTA(
        text: 'Search Trains',
        onPressed: _searchTrains,
        isEnabled: true,
      ).animate().slideY(begin: 1, delay: 800.ms),
    );
  }

  // 🧭 Header Section
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
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
                  'Search Trains',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.textCharcoal,
                        fontWeight: FontWeight.bold,
                      ),
                ).animate().slideX(begin: -0.3).fadeIn(),
                Text(
                  'Aurora Transit - Your Journey Begins',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textCharcoal.withOpacity(0.7),
                      ),
                ).animate(delay: 200.ms).slideX(begin: -0.3).fadeIn(),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() => _showAdvancedFilters = !_showAdvancedFilters);
            },
            icon: AuroraAnimatedIcon(
              icon: Icons.tune,
              color: AppTheme.primaryCrimson,
              isActive: _showAdvancedFilters,
            ),
          ),
        ],
      ),
    );
  }

  // 🚆 Trip Type Toggle Buttons
  Widget _buildTripTypeToggle() {
    return AuroraGlassCard(
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: _buildTripTypeButton(
              'One Way',
              !_isRoundTrip,
              () => setState(() => _isRoundTrip = false),
            ),
          ),
          Expanded(
            child: _buildTripTypeButton(
              'Round Trip',
              _isRoundTrip,
              () => setState(() => _isRoundTrip = true),
            ),
          ),
        ],
      ),
    ).animate().scale(delay: 100.ms);
  }

  Widget _buildTripTypeButton(String text, bool isSelected, VoidCallback onTap) {
    return AnimatedContainer(
      duration: AppTheme.mediumAnimation,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              gradient: isSelected ? AppTheme.buttonGradient : null,
              color: isSelected ? null : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
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
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isSelected
                        ? Colors.white
                        : AppTheme.textCharcoal,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  // 🧳 Input Card
  Widget _buildInputCard() {
    return AuroraGlassCard(
      child: Column(
        children: [
          AuroraInputField(
            label: 'From Station',
            hint: 'Enter departure station',
            icon: Icons.train_outlined,
            controller: _fromController,
            validator: (value) =>
                value?.isEmpty == true ? 'Please enter departure station' : null,
          ).animate().slideX(begin: -0.3, delay: 300.ms),
          const SizedBox(height: 16),
          Center(
            child: Container(
              decoration: BoxDecoration(
                gradient: AppTheme.buttonGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentAmber.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: _swapStations,
                icon: const Icon(Icons.swap_vert, color: Colors.white),
              ),
            ),
          ).animate().shimmer(delay: 2.seconds, duration: 1.seconds),
          const SizedBox(height: 16),
          AuroraInputField(
            label: 'To Station',
            hint: 'Enter arrival station',
            icon: Icons.location_on_outlined,
            controller: _toController,
            validator: (value) =>
                value?.isEmpty == true ? 'Please enter arrival station' : null,
          ).animate().slideX(begin: 0.3, delay: 400.ms),
          const SizedBox(height: 20),
          AuroraInputField(
            label: 'Travel Date',
            hint: _selectedDate == null
                ? 'Select travel date'
                : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
            icon: Icons.calendar_today,
            readOnly: true,
            onTap: () => _selectDate(context),
            validator: (value) => _selectedDate == null ? 'Please select a travel date' : null,
          ).animate().slideY(begin: 0.2, delay: 500.ms),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: AuroraInputField(
                  label: 'Passengers',
                  hint:
                      '$_selectedPassengers ${_selectedPassengers == 1 ? 'Passenger' : 'Passengers'}',
                  icon: Icons.people,
                  readOnly: true,
                  onTap: () => _showPassengerPicker(context),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AuroraInputField(
                  label: 'Class',
                  hint: _selectedClass,
                  icon: Icons.airline_seat_recline_normal,
                  readOnly: true,
                  onTap: () => _showClassPicker(context),
                ),
              ),
            ],
          ).animate().slideY(begin: 0.2, delay: 600.ms),
        ],
      ),
    ).animate().slideY(begin: 0.3, delay: 200.ms);
  }

  // ⚙️ Advanced Filters
  Widget _buildAdvancedFilters() {
    return AuroraGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Advanced Filters',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textCharcoal,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildFilterChip('Direct Trains')),
              const SizedBox(width: 12),
              Expanded(child: _buildFilterChip('Express Only')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryCrimson.withOpacity(0.3),
        ),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textCharcoal,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  // 🙋‍♂️ Passenger Picker Modal
  void _showPassengerPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => AuroraGlassCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Passengers',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.textCharcoal,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                final passengerCount = index + 1;
                final isSelected = _selectedPassengers == passengerCount;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedPassengers = passengerCount);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: isSelected ? AppTheme.buttonGradient : null,
                      color: isSelected ? null : Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : AppTheme.primaryCrimson.withOpacity(0.3),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$passengerCount',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: isSelected ? Colors.white : AppTheme.textCharcoal,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 💺 Class Picker Modal
  void _showClassPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => AuroraGlassCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Class',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.textCharcoal,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _classes.map((classType) {
                    final isSelected = _selectedClass == classType;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedClass = classType);
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: isSelected ? AppTheme.buttonGradient : null,
                            color: isSelected ? null : Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.transparent
                                  : AppTheme.primaryCrimson.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            classType,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme.textCharcoal,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // 🌟 Popular Stations
  Widget _buildPopularStations() {
    return AuroraGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AuroraAnimatedIcon(
                icon: Icons.star,
                color: AppTheme.accentAmber,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Popular Stations',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.textCharcoal,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _popularStations.map((station) {
              return GestureDetector(
                onTap: () {
                  if (_fromController.text.isEmpty) {
                    _fromController.text = station;
                  } else if (_toController.text.isEmpty) {
                    _toController.text = station;
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.primaryCrimson.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    station,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textCharcoal,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ).animate().scale(
                  delay: Duration(
                      milliseconds: 100 * _popularStations.indexOf(station)));
            }).toList(),
          ),
        ],
      ),
    );
  }
}
