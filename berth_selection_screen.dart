import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/aurora_components.dart';
import '../theme/app_theme.dart';
import 'seat_layout_screen.dart';

class BerthSelectionScreen extends StatefulWidget {
  final Map<String, dynamic>? train;
  const BerthSelectionScreen({super.key, this.train});
  @override
  State<BerthSelectionScreen> createState() => _BerthSelectionScreenState();
}

class _BerthSelectionScreenState extends State<BerthSelectionScreen>
    with TickerProviderStateMixin {
  final List<String> selectedSeats = [];
  String selectedCoach = 'S1';
  late final int requiredSeats;
  final _scrollController = ScrollController();
  bool _showFloatingButton = false;
  
  String selectedGender = 'Any';
  bool showGenderComfortInfo = false;
  Map<String, String> seatGenderMap = {};

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late final List<Map<String, dynamic>> coaches;
  
  @override
  void initState() {
    super.initState();
    
    // Get required seats from route arguments
    requiredSeats = (widget.train?['passengers'] as int?) ?? 1;
    
    // Get the selected class fare (passed from train list)
    final selectedFare = widget.train?['fare'];
    final fareValue = selectedFare is double 
        ? selectedFare 
        : selectedFare is int 
            ? selectedFare.toDouble()
            : selectedFare is String
                ? double.tryParse(selectedFare.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 1845.0
                : 1845.0;
    final selectedClass = widget.train?['selectedClass'] ?? 'AC 3 Tier';
    
    coaches = [
      {
        "coach": "S1",
        "type": selectedClass,
        "totalSeats": 72,
        "availableSeats": 45,
        "fare": "₹${fareValue.toInt()}",
        ..._generateSeatLayout(72),
      },
      {
        "coach": "S2",
        "type": selectedClass,
        "totalSeats": 72,
        "availableSeats": 38,
        "fare": "₹${fareValue.toInt()}",
        ..._generateSeatLayout(72),
      },
      {
        "coach": "S3",
        "type": selectedClass,
        "totalSeats": 72,
        "availableSeats": 52,
        "fare": "₹${fareValue.toInt()}",
        ..._generateSeatLayout(72),
      },
    ];
    
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
    
    _scrollController.addListener(() {
      setState(() {
        _showFloatingButton = _scrollController.offset > 200;
      });
    });
    
    _animationController.forward();
  }

  Map<String, dynamic> _generateSeatLayout(int totalSeats) {
    List<String> seats = [];
    Map<String, String> genderOccupancy = {};
    
    for (int i = 0; i < totalSeats; i++) {
      int position = i % 8;
      String seatType;
      
      if (position == 0 || position == 1) {
        seatType = "LB";
      } else if (position == 2 || position == 3) {
        seatType = "MB";
      } else if (position == 4 || position == 5) {
        seatType = "UB";
      } else if (position == 6) {
        seatType = "SL";
      } else {
        seatType = "SU";
      }
      
      seats.add(seatType);
      
      if (i % 7 == 0) {
        seats[i] = "B";
        final genders = ['Male', 'Female', 'Other'];
        genderOccupancy[i.toString()] = genders[i % 3];
      } else {
        genderOccupancy[i.toString()] = 'Available';
      }
    }
    
    return {
      'seats': seats,
      'genderOccupancy': genderOccupancy,
    };
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
  
  String? getNearbyGenderOccupancy(String coach, int seatIndex) {
    final coachData = coaches.firstWhere((c) => c['coach'] == coach);
    final genderOccupancy = coachData['genderOccupancy'] as Map<String, String>;
    
    int compartment = seatIndex ~/ 8;
    int startIndex = compartment * 8;
    int endIndex = startIndex + 8;
    
    for (int i = startIndex; i < endIndex && i < 72; i++) {
      if (i != seatIndex && genderOccupancy[i.toString()] != 'Available') {
        return genderOccupancy[i.toString()];
      }
    }
    
    return null;
  }

  Color getSeatColor(String seat, String? nearbyGender) {
    Color baseColor;
    
    switch (seat) {
      case "LB":
        baseColor = AppTheme.primaryCrimson.withOpacity(0.1);
        break;
      case "MB":
        baseColor = AppTheme.secondaryIndigo.withOpacity(0.1);
        break;
      case "UB":
        baseColor = AppTheme.accentAmber.withOpacity(0.1);
        break;
      case "SL":
      case "SU":
        baseColor = AppTheme.backgroundMist;
        break;
      case "B":
        baseColor = Colors.red.withOpacity(0.2);
        break;
      default:
        baseColor = Colors.white.withOpacity(0.8);
    }
    
    if (selectedGender != 'Any' && nearbyGender != null && nearbyGender != 'Available') {
      if (nearbyGender == selectedGender) {
        return Color.lerp(baseColor, Colors.green.withOpacity(0.3), 0.3) ?? baseColor;
      } else {
        return Color.lerp(baseColor, Colors.orange.withOpacity(0.2), 0.2) ?? baseColor;
      }
    }
    
    return baseColor;
  }

  String getSeatTypeLabel(String type) {
    switch (type) {
      case "LB": return "Lower Berth";
      case "MB": return "Middle Berth";
      case "UB": return "Upper Berth";
      case "SL": return "Side Lower";
      case "SU": return "Side Upper";
      case "B": return "Booked";
      default: return "Unknown";
    }
  }

  IconData getSeatIcon(String type) {
    switch (type) {
      case "LB":
      case "SL":
        return Icons.hotel;
      case "MB":
        return Icons.bed;
      case "UB":
      case "SU":
        return Icons.airline_seat_flat;
      case "B":
        return Icons.block;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bottomInset = MediaQuery.of(context).viewPadding.bottom + 120.0;
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundMist,
      floatingActionButton: _showFloatingButton
          ? Container(
              decoration: BoxDecoration(
                gradient: AppTheme.buttonGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentAmber.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: _scrollToTop,
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: const Icon(Icons.arrow_upward, color: Colors.white),
              ),
            ).animate().scale()
          : null,
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
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                        Row(
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
                                    'Select Berth',
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: AppTheme.textCharcoal,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Aurora Transit - Comfort & Privacy',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppTheme.textCharcoal.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() => showGenderComfortInfo = !showGenderComfortInfo);
                              },
                              icon: AuroraAnimatedIcon(
                                icon: Icons.info_outline,
                                color: AppTheme.primaryCrimson,
                                isActive: showGenderComfortInfo,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        AuroraGlassCard(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  AuroraAnimatedIcon(
                                    icon: Icons.diversity_1,
                                    color: AppTheme.accentAmber,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Gender Comfort Filter',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: AppTheme.textCharcoal,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (selectedGender != 'Any')
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        gradient: AppTheme.buttonGradient,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Active',
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
                                  ..._buildGenderButtons(),
                                ],
                              ),
                            ],
                          ),
                        ).animate().slideY(begin: 0.2, delay: 100.ms),
                        
                        if (showGenderComfortInfo) ...[
                          const SizedBox(height: 16),
                          AuroraGlassCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    AuroraAnimatedIcon(
                                      icon: Icons.security,
                                      color: AppTheme.primaryCrimson,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Privacy & Comfort Features',
                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                          color: AppTheme.textCharcoal,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                _buildInfoItem('🟢', 'Green highlight: Same-gender nearby berths for comfort'),
                                const SizedBox(height: 6),
                                _buildInfoItem('🟠', 'Orange tint: Mixed-gender compartment (user consent required)'),
                                const SizedBox(height: 6),
                                _buildInfoItem('🔒', 'Your privacy and safety are our priority'),
                              ],
                            ),
                          ).animate().slideY(begin: -0.2).fadeIn(),
                        ],
                        
                        const SizedBox(height: 16),
                        
                        AuroraGlassCard(
                          child: Row(
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
                                      widget.train?['name'] ?? 'Rajdhani Express',
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        color: AppTheme.textCharcoal,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Train No. ${widget.train?['number'] ?? '12951'}',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppTheme.textCharcoal.withOpacity(0.7),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    widget.train?['departure'] ?? '16:55',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: AppTheme.textCharcoal,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    width: 60,
                                    height: 3,
                                    decoration: BoxDecoration(
                                      gradient: AppTheme.buttonGradient,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.train?['duration'] ?? '15h 20m',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.primaryCrimson,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    widget.train?['arrival'] ?? '08:15',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: AppTheme.textCharcoal,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ).animate().slideY(begin: 0.2, delay: 200.ms),
                      ],
                    ),
                  ),
                ),
              ),

                Container(
                  height: 120,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: coaches.length,
                  itemBuilder: (context, index) {
                    final coach = coaches[index];
                    final isSelected = coach['coach'] == selectedCoach;

                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SeatLayoutScreen(
                                coach: coach,
                                selectedGender: selectedGender,
                                onSeatSelected: (String seatNumber) {
                                  setState(() {
                                    selectedSeats.clear();
                                    if (selectedSeats.length < requiredSeats) {
                                      selectedSeats.add(seatNumber);
                                    }
                                    selectedCoach = coach['coach'];
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 160,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: isSelected ? AppTheme.buttonGradient : null,
                            color: isSelected ? null : Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? Colors.transparent : AppTheme.primaryCrimson.withOpacity(0.3),
                            ),
                            boxShadow: isSelected ? [
                              BoxShadow(
                                color: AppTheme.accentAmber.withOpacity(0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ] : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Coach ${coach['coach']}',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: isSelected ? Colors.white : AppTheme.textCharcoal,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                coach['type'],
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: isSelected ? Colors.white.withOpacity(0.8) : AppTheme.textCharcoal.withOpacity(0.7),
                                  fontSize: 10,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.airline_seat_recline_normal,
                                    size: 14,
                                    color: isSelected ? Colors.white : AppTheme.primaryCrimson,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${coach['availableSeats']}/${coach['totalSeats']}',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: isSelected ? Colors.white : AppTheme.textCharcoal.withOpacity(0.7),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ).animate(delay: Duration(milliseconds: index * 100)).slideX(begin: 0.3),
                    );
                  },
                ),
              ),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: AuroraGlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Seat Types',
                          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          children: ['LB', 'MB', 'UB', 'SL', 'SU', 'B'].map((type) => _buildLegendItem(
                            type,
                            getSeatColor(type, null),
                            getSeatTypeLabel(type),
                            getSeatIcon(type),
                            Theme.of(context).textTheme,
                            Theme.of(context).colorScheme,
                          )).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().slideY(delay: 300.ms),

                Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.fromLTRB(20, 20, 20, bottomInset),
                  itemCount: coaches.length,
                  itemBuilder: (context, index) {
                    final coach = coaches[index];
                    if (coach['coach'] != selectedCoach) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Coach ${coach['coach']} - ${coach['type']}',
                                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                coach['fare'],
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        AuroraGlassCard(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                
                                ...List.generate((coach['seats'] as List).length ~/ 8, (rowIndex) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppTheme.primaryCrimson.withOpacity(0.1),
                                                AppTheme.secondaryIndigo.withOpacity(0.1),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            'Compartment ${rowIndex + 1}',
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme.textCharcoal,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              ...List.generate(6, (seatIndex) {
                                                final globalIndex = rowIndex * 8 + seatIndex;
                                                return _buildSeat(
                                                  (coach['seats'] as List)[globalIndex],
                                                  '${coach['coach']}-${globalIndex + 1}',
                                                  globalIndex,
                                                );
                                              }),
                                              
                                              const SizedBox(width: 16),
                                              
                                              ...List.generate(2, (seatIndex) {
                                                final globalIndex = rowIndex * 8 + 6 + seatIndex;
                                                return _buildSeat(
                                                  (coach['seats'] as List)[globalIndex],
                                                  '${coach['coach']}-${globalIndex + 1}',
                                                  globalIndex,
                                                );
                                              }),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ).animate(delay: Duration(milliseconds: index * 100)).slideY(begin: 0.3).fadeIn(),
                      ],
                    );
                  },
                ),
              ),
                ],
              ),
              // Positioned CTA at bottom when a seat is selected
              if (selectedSeats.isNotEmpty)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: AuroraBottomCTA(
                    text: 'Confirm Selection (${selectedSeats.length}/${requiredSeats}) - ${coaches.firstWhere((c) => c['coach'] == selectedCoach)['fare']}',
                    onPressed: selectedSeats.length == requiredSeats ? () {
                      HapticFeedback.mediumImpact();
                      final trainData = widget.train ?? {};
                      
                      // Get numeric fare value
                      final fareValue = widget.train?['fare'];
                      final numericFare = fareValue is int 
                          ? fareValue.toDouble()
                          : fareValue is double 
                              ? fareValue 
                              : fareValue is String
                                  ? double.tryParse(fareValue.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 1845.0
                                  : 1845.0;
                      
                      Navigator.pushNamed(
                        context,
                        '/passenger-details',
                        arguments: {
                          'train': {
                            ...trainData,
                            'baseFare': numericFare,
                          },
                          'selectedSeats': selectedSeats,
                          'selectedCoach': selectedCoach,
                          'genderPreference': selectedGender,
                          'fare': numericFare,
                        },
                      );
                    } : null,
                    isEnabled: selectedSeats.length == requiredSeats,
                  ).animate().slideY(begin: 1, delay: 500.ms),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeat(String seat, String seatNumber, int seatIndex) {
    bool isBooked = seat == "B";
    bool isSelected = selectedSeats.contains(seatNumber);
    
    // Get the gender of the booked seat if it's booked
    final coachData = coaches.firstWhere((c) => c['coach'] == selectedCoach);
    final genderOccupancy = coachData['genderOccupancy'] as Map<String, String>;
    String? bookedSeatGender = isBooked ? genderOccupancy[seatIndex.toString()] : null;
    
    String? nearbyGender = getNearbyGenderOccupancy(selectedCoach, seatIndex);
    
    void _handleSeatSelection() {
      if (selectedGender != 'Any' && nearbyGender != null && 
          nearbyGender != 'Available' && nearbyGender != selectedGender) {
        _showGenderConfirmationDialog(seatNumber, nearbyGender);
      } else {
        setState(() {
          if (selectedSeats.contains(seatNumber)) {
            selectedSeats.remove(seatNumber);
          } else if (selectedSeats.length < requiredSeats) {
            selectedSeats.add(seatNumber);
            HapticFeedback.mediumImpact();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('You can only select $requiredSeats seats'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        });
      }
    }

    Color getSeatDisplayColor() {
      if (isSelected) {
        // Color based on selected gender preference
        if (selectedGender == 'Female') {
          return Colors.pink.shade400;
        } else if (selectedGender == 'Male') {
          return Colors.blue.shade400;
        } else if (selectedGender == 'Other') {
          return Colors.purple.shade400;
        }
        return AppTheme.primaryCrimson;
      }
      return getSeatColor(seat, nearbyGender);
    }

    return GestureDetector(
      onTap: isBooked ? null : _handleSeatSelection,
      child: AnimatedContainer(
        duration: AppTheme.mediumAnimation,
        width: 42,
        height: 50,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: getSeatDisplayColor(),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.accentAmber
                : (nearbyGender == selectedGender && selectedGender != 'Any'
                    ? Colors.green.withOpacity(0.6)
                    : AppTheme.primaryCrimson.withOpacity(0.3)),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: selectedGender == 'Female' 
                        ? Colors.pink.withOpacity(0.5)
                        : selectedGender == 'Male'
                            ? Colors.blue.withOpacity(0.5)
                            : selectedGender == 'Other'
                                ? Colors.purple.withOpacity(0.5)
                                : AppTheme.accentAmber.withOpacity(0.5),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: isBooked
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      bookedSeatGender == 'Male' 
                          ? Icons.male 
                          : bookedSeatGender == 'Female' 
                              ? Icons.female 
                              : Icons.person,
                      color: bookedSeatGender == 'Male' 
                          ? Colors.blue 
                          : bookedSeatGender == 'Female' 
                              ? Colors.pink 
                              : Colors.grey,
                      size: 18,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'B',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      seat,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isSelected ? Colors.white : AppTheme.textCharcoal,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      seatNumber.split('-').last,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isSelected 
                            ? Colors.white.withOpacity(0.9)
                            : AppTheme.textCharcoal.withOpacity(0.6),
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
        ),
      ),
    ).animate(target: isSelected ? 1 : 0)
        .shimmer(duration: 1000.ms)
        .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.05, 1.05));
  }

  Widget _buildLegendItem(String code, Color color, String label, IconData icon, TextTheme textTheme, ColorScheme colorScheme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.primaryCrimson.withOpacity(0.3),
            ),
          ),
          child: Center(
            child: Text(
              code,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppTheme.textCharcoal,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textCharcoal.withOpacity(0.7),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
  
  List<Widget> _buildGenderButtons() {
    final genders = [
      {'value': 'Male', 'icon': Icons.male, 'color': Colors.blue},
      {'value': 'Female', 'icon': Icons.female, 'color': Colors.pink},
      {'value': 'Other', 'icon': Icons.transgender, 'color': Colors.purple},
      {'value': 'Any', 'icon': Icons.people, 'color': AppTheme.textCharcoal},
    ];
    
    return genders.map((gender) {
      final isSelected = selectedGender == gender['value'];
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: GestureDetector(
            onTap: () {
              setState(() => selectedGender = gender['value'] as String);
              HapticFeedback.lightImpact();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: isSelected ? AppTheme.buttonGradient : null,
                color: isSelected ? null : Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.transparent : AppTheme.primaryCrimson.withOpacity(0.3),
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: AppTheme.accentAmber.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ] : null,
              ),
              child: Column(
                children: [
                  Icon(
                    gender['icon'] as IconData,
                    color: isSelected ? Colors.white : gender['color'] as Color,
                    size: 20,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    gender['value'] as String,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSelected ? Colors.white : AppTheme.textCharcoal,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
  
  Widget _buildInfoItem(String emoji, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textCharcoal.withOpacity(0.8),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
  
  void _showGenderConfirmationDialog(String seatNumber, String nearbyGender) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: AuroraGlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  AuroraAnimatedIcon(
                    icon: Icons.info_outline,
                    color: AppTheme.accentAmber,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Mixed Gender Compartment',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.textCharcoal,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'This compartment has $nearbyGender passengers nearby. For your comfort and privacy, we recommend selecting a seat with same-gender occupancy.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textCharcoal.withOpacity(0.8),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: AuroraGradientButton(
                      text: 'Choose Different',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AuroraGradientButton(
                      text: 'Proceed Anyway',
                      hasAmberGlow: true,
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          if (selectedSeats.length < requiredSeats) {
                            selectedSeats.add(seatNumber);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('You can only select $requiredSeats seats'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        });
                        HapticFeedback.mediumImpact();
                      },
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
}