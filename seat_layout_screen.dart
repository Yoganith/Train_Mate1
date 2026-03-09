import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/aurora_components.dart';
import '../theme/app_theme.dart';

class SeatLayoutScreen extends StatefulWidget {
  final Map<String, dynamic> coach;
  final String selectedGender;
  final Function(String) onSeatSelected;

  const SeatLayoutScreen({
    super.key,
    required this.coach,
    required this.selectedGender,
    required this.onSeatSelected,
  });

  @override
  State<SeatLayoutScreen> createState() => _SeatLayoutScreenState();
}

class _SeatLayoutScreenState extends State<SeatLayoutScreen> {
  String? selectedSeat;
  final _scrollController = ScrollController();

  String? getNearbyGenderOccupancy(int seatIndex) {
    final genderOccupancy = widget.coach['genderOccupancy'] as Map<String, String>;
    
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
    
    if (widget.selectedGender != 'Any' && nearbyGender != null && nearbyGender != 'Available') {
      if (nearbyGender == widget.selectedGender) {
        return Color.lerp(baseColor, Colors.green.withOpacity(0.3), 0.3) ?? baseColor;
      } else {
        return Color.lerp(baseColor, Colors.orange.withOpacity(0.2), 0.2) ?? baseColor;
      }
    }
    
    return baseColor;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundMist,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Coach ${widget.coach['coach']} - ${widget.coach['type']}',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppTheme.textCharcoal,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${widget.coach['availableSeats']} seats available',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textCharcoal.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: AppTheme.buttonGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.coach['fare'],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Seat Layout
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(20),
                child: AuroraGlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          'Select Your Seat',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryCrimson,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        ...List.generate((widget.coach['seats'] as List).length ~/ 8, (rowIndex) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppTheme.primaryCrimson.withOpacity(0.15),
                                        AppTheme.secondaryIndigo.withOpacity(0.15),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Compartment ${rowIndex + 1}',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textCharcoal,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                
                                // Main berths (6 seats)
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    ...List.generate(6, (seatIndex) {
                                      final globalIndex = rowIndex * 8 + seatIndex;
                                      return _buildLargeSeat(
                                        (widget.coach['seats'] as List)[globalIndex],
                                        '${widget.coach['coach']}-${globalIndex + 1}',
                                        globalIndex,
                                      );
                                    }),
                                  ],
                                ),
                                
                                const SizedBox(height: 12),
                                
                                // Side berths (2 seats)
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    ...List.generate(2, (seatIndex) {
                                      final globalIndex = rowIndex * 8 + 6 + seatIndex;
                                      return _buildLargeSeat(
                                        (widget.coach['seats'] as List)[globalIndex],
                                        '${widget.coach['coach']}-${globalIndex + 1}',
                                        globalIndex,
                                      );
                                    }),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      
      bottomNavigationBar: selectedSeat != null
          ? AuroraBottomCTA(
              text: 'Confirm Seat $selectedSeat',
              onPressed: () {
                HapticFeedback.mediumImpact();
                widget.onSeatSelected(selectedSeat!);
                Navigator.pop(context);
              },
              isEnabled: true,
            ).animate().slideY(begin: 1)
          : null,
    );
  }

  Widget _buildLargeSeat(String seat, String seatNumber, int seatIndex) {
    bool isBooked = seat == "B";
    bool isSelected = selectedSeat == seatNumber;
    String? nearbyGender = getNearbyGenderOccupancy(seatIndex);
    
    // Get the actual gender of the booked seat
    final genderOccupancy = widget.coach['genderOccupancy'] as Map<String, String>;
    String? bookedGender = genderOccupancy[seatIndex.toString()];
    
    void handleSeatSelection() {
      if (widget.selectedGender != 'Any' && nearbyGender != null && 
          nearbyGender != 'Available' && nearbyGender != widget.selectedGender) {
        _showGenderConfirmationDialog(seatNumber, nearbyGender);
      } else {
        setState(() {
          selectedSeat = isSelected ? null : seatNumber;
        });
        if (!isSelected) {
          HapticFeedback.mediumImpact();
        }
      }
    }

    Color getSeatDisplayColor() {
      if (isSelected) {
        if (widget.selectedGender == 'Female') {
          return Colors.pink.shade400;
        } else if (widget.selectedGender == 'Male') {
          return Colors.blue.shade400;
        } else if (widget.selectedGender == 'Other') {
          return Colors.purple.shade400;
        }
        return AppTheme.primaryCrimson;
      }
      return getSeatColor(seat, nearbyGender);
    }

    return GestureDetector(
      onTap: isBooked ? null : handleSeatSelection,
      child: AnimatedContainer(
        duration: AppTheme.mediumAnimation,
        width: 70,
        height: 85,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: getSeatDisplayColor(),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppTheme.accentAmber
                : (nearbyGender == widget.selectedGender && widget.selectedGender != 'Any'
                    ? Colors.green.withOpacity(0.6)
                    : AppTheme.primaryCrimson.withOpacity(0.3)),
            width: isSelected ? 3 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: widget.selectedGender == 'Female' 
                        ? Colors.pink.withOpacity(0.5)
                        : widget.selectedGender == 'Male'
                            ? Colors.blue.withOpacity(0.5)
                            : widget.selectedGender == 'Other'
                                ? Colors.purple.withOpacity(0.5)
                                : AppTheme.accentAmber.withOpacity(0.5),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: isBooked
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.block, color: Colors.red, size: 24),
                    const SizedBox(height: 4),
                    if (bookedGender != null && bookedGender != 'Available')
                      Text(
                        bookedGender,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.red.shade700,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      seat,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isSelected ? Colors.white : AppTheme.textCharcoal,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      seatNumber.split('-').last,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected 
                            ? Colors.white.withOpacity(0.9)
                            : AppTheme.textCharcoal.withOpacity(0.6),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    ).animate(target: isSelected ? 1 : 0)
        .shimmer(duration: 1000.ms)
        .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.08, 1.08));
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
                          selectedSeat = seatNumber;
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
