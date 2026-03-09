import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/aurora_components.dart';
import '../theme/app_theme.dart';
import '../services/booking_service.dart';
import '../services/user_session_service.dart';
import '../utils/number_utils.dart';
import '../models/firebase_models.dart';

class PassengerDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? arguments;
  const PassengerDetailsScreen({super.key, this.arguments});

  @override
  State<PassengerDetailsScreen> createState() => _PassengerDetailsScreenState();
}

class _PassengerDetailsScreenState extends State<PassengerDetailsScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  
  // Passenger details controllers
  final List<TextEditingController> _nameControllers = [];
  final List<TextEditingController> _ageControllers = [];
  final List<TextEditingController> _aadharControllers = [];
  final List<TextEditingController> _phoneControllers = [];
  final List<String> _selectedGenders = [];
  
  late final int _passengerCount;
  bool _isBooking = false;
  bool _savePassengerData = true;
  bool _acceptTerms = false;
  String _selectedInsurance = 'None';
  
  // Enhanced validation states
  List<bool> _isFormValidByPassenger = [];
  double _totalAmount = 0.0;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<String> _genders = ['Male', 'Female', 'Other'];

  Map<String, dynamic> get _args => widget.arguments ?? {
        'train': {
          'name': 'Rajdhani Express',
          'number': '12951',
          'price': '₹1,845',
          'from': 'New Delhi',
          'to': 'Mumbai Central',
          'departure': '16:55',
          'arrival': '08:15',
        },
        'selectedSeats': ['S1-1'],
        'selectedCoach': 'S1',
      };

  @override
  void initState() {
    super.initState();
    // Initialize passenger count based on selected seats
    _passengerCount = (_args['selectedSeats'] as List?)?.length ?? 1;
    
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
    
    _initializePassengers();
    _animationController.forward();
  }

  void _initializePassengers() {
    for (int i = 0; i < _passengerCount; i++) {
      _nameControllers.add(TextEditingController());
      _ageControllers.add(TextEditingController());
      _aadharControllers.add(TextEditingController());
      _phoneControllers.add(TextEditingController());
      final genderPref = _args['genderPreference'];
      _selectedGenders.add(_genders.contains(genderPref) ? genderPref : 'Male');
      _isFormValidByPassenger.add(false);
    }
    _calculateTotalAmount();
    
    // Add listeners for real-time validation
    for (int i = 0; i < _passengerCount; i++) {
      _nameControllers[i].addListener(() => _validatePassengerForm(i));
      _ageControllers[i].addListener(() => _validatePassengerForm(i));
      _aadharControllers[i].addListener(() => _validatePassengerForm(i));
      _phoneControllers[i].addListener(() => _validatePassengerForm(i));
    }
  }

  void _calculateTotalAmount() {
    // Parse base fare from train data
    final baseFare = (_args['train']?['baseFare'] ?? 1845).toDouble();
    final insurancePrice = _selectedInsurance == 'Basic' ? 50.0 : _selectedInsurance == 'Premium' ? 150.0 : 0.0;
    
    // Calculate total amount based on base fare, passenger count, and insurance
    _totalAmount = (baseFare + insurancePrice) * _passengerCount;
  }
  
  void _validatePassengerForm(int index) {
    final isValid = _nameControllers[index].text.length >= 2 &&
                   _ageControllers[index].text.isNotEmpty &&
                   (_ageControllers[index].text.isNotEmpty ? int.tryParse(_ageControllers[index].text) != null : false) &&
                   _aadharControllers[index].text.length == 12 &&
                   _phoneControllers[index].text.length == 10;
    
    setState(() {
      _isFormValidByPassenger[index] = isValid;
    });
  }
  
  void _addPassenger() {
    final maxSeats = (_args['selectedSeats'] as List?)?.length ?? 1;
    if (_passengerCount < maxSeats) {
      setState(() {
        _passengerCount++;
        _nameControllers.add(TextEditingController());
        _ageControllers.add(TextEditingController());
        _aadharControllers.add(TextEditingController());
        _phoneControllers.add(TextEditingController());
        final genderPref = _args['genderPreference'];
        _selectedGenders.add(_genders.contains(genderPref) ? genderPref : 'Male');
        _isFormValidByPassenger.add(false);
        
        // Add listeners for the new passenger
        int newIndex = _passengerCount - 1;
        _nameControllers[newIndex].addListener(() => _validatePassengerForm(newIndex));
        _ageControllers[newIndex].addListener(() => _validatePassengerForm(newIndex));
        _aadharControllers[newIndex].addListener(() => _validatePassengerForm(newIndex));
        _phoneControllers[newIndex].addListener(() => _validatePassengerForm(newIndex));
        
        _calculateTotalAmount();
      });
    }
    }

  void _removePassenger(int index) {
    if (_passengerCount > 1) {
      setState(() {
        _passengerCount--;
        _nameControllers[index].dispose();
        _nameControllers.removeAt(index);
        _ageControllers[index].dispose();
        _ageControllers.removeAt(index);
        _aadharControllers[index].dispose();
        _aadharControllers.removeAt(index);
        _phoneControllers[index].dispose();
        _phoneControllers.removeAt(index);
        _selectedGenders.removeAt(index);
        _isFormValidByPassenger.removeAt(index);
        
        _calculateTotalAmount();
      });
    }
  }

  bool _isFormValid() {
    return _isFormValidByPassenger.every((isValid) => isValid) && _acceptTerms;
  }

  Future<void> _bookTicket() async {
    if (!_isFormValid()) return;
    
    // Check if user is authenticated
    if (!UserSessionService.isAuthenticated) {
      _showErrorSnackBar('Please login to book tickets');
      return;
    }
    
    setState(() => _isBooking = true);
    
    try {
      // Create train model from args data
      final trainModel = TrainModel(
        id: _args['train']['id'] ?? 'train_demo_id',
        trainNumber: _args['train']['number'] ?? '12951',
        trainName: _args['train']['name'] ?? 'Rajdhani Express',
        trainType: _args['train']['type'] ?? 'Superfast',
        departureStation: _args['from'] ?? 'New Delhi',
        arrivalStation: _args['to'] ?? 'Mumbai Central',
        departureTime: DateTime.now().add(const Duration(days: 1, hours: 8)),
        arrivalTime: DateTime.now().add(const Duration(days: 2, hours: 2)),
        classes: {
          'AC3': ClassInfo(
            className: 'AC 3 Tier',
            price: safeParseDouble((_args['train']?['price'] ?? '₹1845')),
            totalSeats: 72,
            availableSeats: 45,
            availability: 'CURR_AVBL',
            isTatkalAvailable: true,
          ),
        },
        runningDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        route: {},
        isActive: true,
        lastUpdated: DateTime.now(),
      );
      
      // Create passenger info list
      final passengers = <PassengerInfo>[];
      for (int i = 0; i < _passengerCount; i++) {
        passengers.add(PassengerInfo(
          name: _nameControllers[i].text.trim(),
          age: safeParseInt(_ageControllers[i].text, fallback: 25),
          gender: _selectedGenders[i],
          idType: 'Aadhar',
          idNumber: _aadharControllers[i].text,
        ));
      }
      
      // Create booking with Firebase
      final booking = await BookingService.createBooking(
        trainId: trainModel.id,
        train: trainModel,
        passengers: passengers,
        selectedCoach: _args['selectedCoach'] ?? 'S1',
        selectedSeats: (_args['selectedSeats'] as List?)?.map((s) => s.toString()).toList() ?? ['S1-1'],
        travelDate: DateTime.now().add(const Duration(days: 1)),
        totalAmount: _totalAmount,
        additionalInfo: {
          'insurance': _selectedInsurance,
          'genderPreference': _args['genderPreference'],
        },
      );
      
      if (mounted) {
        // Navigate to booking summary screen to review before payment
        Navigator.pushNamed(
          context,
          '/booking-summary',
          arguments: {
            'booking': booking,
            'train': _args['train'],
            'selectedSeat': _args['selectedSeat'],
            'selectedCoach': _args['selectedCoach'],
            'passengers': _getPassengerData(),
            'totalAmount': _totalAmount,
            'insurance': _selectedInsurance,
            'genderPreference': _args['genderPreference'],
            'pnr': booking.pnrNumber,
            'from': _args['from'],
            'to': _args['to'],
          },
        );
      }
    } catch (e) {
      _showErrorSnackBar('Booking failed: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isBooking = false);
      }
    }
  }
  

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
  backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
  
  List<Map<String, dynamic>> _getPassengerData() {
    List<Map<String, dynamic>> passengers = [];
    for (int i = 0; i < _passengerCount; i++) {
      passengers.add({
        'name': _nameControllers[i].text,
        'age': safeParseInt(_ageControllers[i].text, fallback: 25),
        'gender': _selectedGenders[i],
        'aadhar': _aadharControllers[i].text,
        'phone': _phoneControllers[i].text,
      });
    }
    return passengers;
  }

  @override
  void dispose() {
    for (var controller in _nameControllers) controller.dispose();
    for (var controller in _ageControllers) controller.dispose();
    for (var controller in _aadharControllers) controller.dispose();
    for (var controller in _phoneControllers) controller.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
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
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    AuroraGlassCard(
                      padding: EdgeInsets.zero,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: AppTheme.textCharcoal,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Passenger Details',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textCharcoal,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    AuroraGlassCard(
                      padding: EdgeInsets.zero,
                      child: IconButton(
                        onPressed: _addPassenger,
                        icon: Icon(
                          Icons.person_add_rounded,
                          color: AppTheme.primaryCrimson,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(20),
                    children: [
                      // Passenger Forms
                      ...List.generate(
                        _passengerCount,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: _buildPassengerForm(index),
                        ),
                      ),
                      
                      // Booking Options
                      AuroraGlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Booking Options',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textCharcoal,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Terms and Conditions
                            Row(
                              children: [
                                Checkbox(
                                  value: _acceptTerms,
                                  onChanged: (value) => setState(() => _acceptTerms = value ?? false),
                                  activeColor: AppTheme.primaryCrimson,
                                ),
                                Expanded(
                                  child: Text(
                                    'I accept the Terms & Conditions and Privacy Policy',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.textCharcoal.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),

              // Bottom Action Bar
              Container(
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
                      // Price Summary
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.accentAmber.withOpacity(0.1),
                              AppTheme.accentAmber.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.accentAmber.withOpacity(0.2),
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
                                  'Including all taxes & fees',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textCharcoal.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '₹$_totalAmount',
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
                      
                      // Review Button
                      AuroraGradientButton(
                        text: _isBooking ? 'Processing...' : 'Review & Proceed',
                        icon: _isBooking ? null : Icons.arrow_forward_rounded,
                        isLoading: _isBooking,
                        onPressed: _isFormValid() && !_isBooking ? _bookTicket : null,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPassengerForm(int index) {
    return AuroraGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.secondaryIndigo,
                      AppTheme.secondaryIndigo.withOpacity(0.8)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Passenger ${index + 1}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textCharcoal,
                  ),
                ),
              ),
              if (_passengerCount > 1)
                IconButton(
                  onPressed: () => _removePassenger(index),
                  icon: Icon(
                    Icons.close_rounded,
                    color: AppTheme.primaryCrimson,
                    size: 20,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Name Field
          AuroraInputField(
            controller: _nameControllers[index],
            label: 'Full Name',
            hint: 'Enter passenger name',
            icon: Icons.person_outline_rounded,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Please enter passenger name';
              if (value!.length < 2) return 'Name must be at least 2 characters';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Age and Gender
          Row(
            children: [
              Expanded(
                child: AuroraInputField(
                  controller: _ageControllers[index],
                  label: 'Age',
                  hint: 'Enter age',
                  icon: Icons.cake_rounded,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Enter age';
                    final age = int.tryParse(value!);
                    if (age == null || age < 1 || age > 120) {
                      return 'Enter valid age';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.textCharcoal.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedGenders[index],
                    isExpanded: true,
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppTheme.primaryCrimson,
                    ),
                    underline: const SizedBox(),
                    items: _genders.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() => _selectedGenders[index] = newValue);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Aadhar Field
          AuroraInputField(
            controller: _aadharControllers[index],
            label: 'Aadhar Number',
            hint: 'Enter 12-digit Aadhar number',
            icon: Icons.badge_rounded,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(12),
            ],
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Please enter Aadhar number';
              if (value!.length != 12) return 'Aadhar number must be 12 digits';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Phone Field
          AuroraInputField(
            controller: _phoneControllers[index],
            label: 'Phone Number',
            hint: 'Enter 10-digit phone number',
            icon: Icons.phone_rounded,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Please enter phone number';
              if (value!.length != 10) return 'Phone number must be 10 digits';
              return null;
            },
          ),
        ],
      ),
    );
  }
}