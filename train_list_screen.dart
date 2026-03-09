import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/aurora_components.dart';
import '../theme/app_theme.dart';
import '../utils/indian_trains_data.dart';
import '../utils/dynamic_train_generator.dart';

class TrainListScreen extends StatefulWidget {
  final Map<String, dynamic>? searchArgs;
  const TrainListScreen({super.key, this.searchArgs});

  @override
  State<TrainListScreen> createState() => _TrainListScreenState();
}

class _TrainListScreenState extends State<TrainListScreen>
    with TickerProviderStateMixin {
  final _scrollController = ScrollController();
  bool _showFloatingButton = false;
  String _selectedFilter = 'All';
  String _sortBy = 'Departure Time';
  bool _showSortOptions = false;
  bool _isLoading = true;
  int _expandedIndex = -1;
  List<Map<String, dynamic>> _filteredTrains = [];
  
  final List<String> _filters = ['All', 'AC', 'Non-AC', 'Fast', 'Superfast'];
  final List<String> _sortOptions = [
    'Departure Time',
    'Arrival Time',
    'Duration',
    'Price',
    'Availability'
  ];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Enhanced dummy data with multiple routes
  final List<Map<String, dynamic>> _trains = [
    // New Delhi → Mumbai Central
    {
      'number': '12345',
      'name': 'Rajdhani Express',
      'type': 'Superfast',
      'from': 'New Delhi',
      'to': 'Mumbai Central',
      'departure': '16:55',
      'arrival': '08:15',
      'duration': '15h 20m',
      'classes': ['1A', '2A', '3A'],
      'price': '₹1,845',
      'fares': {'1A': 4995, '2A': 2995, '3A': 1845},
      'availability': {'1A': 'Available', '2A': 'RAC', '3A': 'Available'},
      'rating': 4.5,
      'amenities': ['Wi-Fi', 'Pantry', 'AC'],
      'delay': 'On Time',
      'platform': '3',
    },
    {
      'number': '12957',
      'name': 'Duronto Express',
      'type': 'AC Express',
      'from': 'New Delhi',
      'to': 'Mumbai Central',
      'departure': '18:35',
      'arrival': '11:05',
      'duration': '16h 30m',
      'classes': ['2A', '3A'],
      'price': '₹1,525',
      'fares': {'2A': 2695, '3A': 1525},
      'availability': {'2A': 'RAC', '3A': 'Limited'},
      'rating': 4.2,
      'amenities': ['Wi-Fi', 'Pantry'],
      'delay': '5 min late',
      'platform': '1',
    },
    // Chennai Central → Hyderabad
    {
      'number': '12759',
      'name': 'Charminar Express',
      'type': 'Superfast',
      'from': 'Chennai Central',
      'to': 'Hyderabad',
      'departure': '18:00',
      'arrival': '05:55',
      'duration': '11h 55m',
      'classes': ['1A', '2A', '3A', 'SL'],
      'price': '₹865',
      'fares': {'1A': 2845, '2A': 1545, '3A': 865, 'SL': 325},
      'availability': {'1A': 'Available', '2A': 'Available', '3A': 'Available', 'SL': 'Available'},
      'rating': 4.3,
      'amenities': ['Wi-Fi', 'Pantry', 'AC'],
      'delay': 'On Time',
      'platform': '2',
    },
    {
      'number': '12604',
      'name': 'Chennai Central - Hyderabad Express',
      'type': 'AC Express',
      'from': 'Chennai Central',
      'to': 'Hyderabad',
      'departure': '06:30',
      'arrival': '19:15',
      'duration': '12h 45m',
      'classes': ['2A', '3A', 'SL'],
      'price': '₹745',
      'fares': {'2A': 1395, '3A': 745, 'SL': 285},
      'availability': {'2A': 'Available', '3A': 'Available', 'SL': 'Waiting'},
      'rating': 4.1,
      'amenities': ['Pantry', 'AC'],
      'delay': 'On Time',
      'platform': '4',
    },
    {
      'number': '12760',
      'name': 'Tamil Nadu Express',
      'type': 'Superfast',
      'from': 'Chennai Central',
      'to': 'Hyderabad',
      'departure': '22:30',
      'arrival': '10:25',
      'duration': '11h 55m',
      'classes': ['1A', '2A', '3A', 'SL'],
      'price': '₹920',
      'fares': {'1A': 3145, '2A': 1795, '3A': 920, 'SL': 350},
      'availability': {'1A': 'RAC', '2A': 'RAC', '3A': 'Limited', 'SL': 'Available'},
      'rating': 4.4,
      'amenities': ['Wi-Fi', 'Pantry', 'AC'],
      'delay': '15 min late',
      'platform': '1',
    },
    {
      'number': '17644',
      'name': 'Circar Express',
      'type': 'Fast',
      'from': 'Chennai Central',
      'to': 'Hyderabad',
      'departure': '16:45',
      'arrival': '06:30',
      'duration': '13h 45m',
      'classes': ['SL', '2S'],
      'price': '₹465',
      'fares': {'SL': 465, '2S': 185},
      'availability': {'SL': 'Available', '2S': 'Available'},
      'rating': 3.9,
      'amenities': ['Pantry'],
      'delay': 'On Time',
      'platform': '5',
    },
    // Chennai → Coimbatore
    {
      'number': '12679',
      'name': 'Kovai Express',
      'type': 'Superfast',
      'from': 'Chennai Central',
      'to': 'Coimbatore',
      'departure': '06:00',
      'arrival': '12:30',
      'duration': '6h 30m',
      'classes': ['2A', '3A', 'SL'],
      'price': '₹645',
      'fares': {'2A': 1195, '3A': 645, 'SL': 245},
      'availability': {'2A': 'Available', '3A': 'Available', 'SL': 'Available'},
      'rating': 4.2,
      'amenities': ['Wi-Fi', 'Pantry', 'AC'],
      'delay': 'On Time',
      'platform': '3',
    },
    {
      'number': '12673',
      'name': 'Cheran Express',
      'type': 'Superfast',
      'from': 'Chennai Central',
      'to': 'Coimbatore',
      'departure': '21:30',
      'arrival': '04:45',
      'duration': '7h 15m',
      'classes': ['2A', '3A', 'SL'],
      'price': '₹585',
      'fares': {'2A': 1095, '3A': 585, 'SL': 230},
      'availability': {'2A': 'Available', '3A': 'RAC', 'SL': 'Available'},
      'rating': 4.0,
      'amenities': ['Pantry', 'AC'],
      'delay': 'On Time',
      'platform': '6',
    },
    // Mumbai → Bangalore
    {
      'number': '12628',
      'name': 'Karnataka Express',
      'type': 'Superfast',
      'from': 'Mumbai Central',
      'to': 'Bangalore City',
      'departure': '20:10',
      'arrival': '10:40',
      'duration': '14h 30m',
      'classes': ['1A', '2A', '3A', 'SL'],
      'price': '₹1,245',
      'fares': {'1A': 3895, '2A': 2395, '3A': 1245, 'SL': 425},
      'availability': {'1A': 'Available', '2A': 'Available', '3A': 'Limited', 'SL': 'Available'},
      'rating': 4.4,
      'amenities': ['Wi-Fi', 'Pantry', 'AC'],
      'delay': 'On Time',
      'platform': '7',
    },
  ];

  @override
  void initState() {
    super.initState();
    
    // Load trains from comprehensive Indian Railways data
    _trains.clear();
    _trains.addAll(IndianTrainsData.getAllTrains());
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _scrollController.addListener(() {
      setState(() {
        _showFloatingButton = _scrollController.offset > 200;
      });
    });
    
    // Filter trains based on selected route
    _filterTrainsByRoute();
    
    // Simulate loading with shimmer effect
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => _isLoading = false);
        _animationController.forward();
      }
    });
  }
  
  void _filterTrainsByRoute() {
    final from = widget.searchArgs?['from']?.toString() ?? '';
    final to = widget.searchArgs?['to']?.toString() ?? '';
    
    // If no route specified, show all trains
    if (from.isEmpty || to.isEmpty) {
      _filteredTrains = List.from(_trains);
      return;
    }
    
    // Normalize station names (handle variations)
    String normalizeStation(String station) {
      station = station.toLowerCase().trim();
      // Map common variations
      if (station.contains('kolkata') || station.contains('howrah')) return 'kolkata';
      if (station.contains('chennai')) return 'chennai';
      if (station.contains('mumbai') || station.contains('bombay')) return 'mumbai';
      if (station.contains('delhi') || station.contains('ndls')) return 'delhi';
      if (station.contains('bangalore') || station.contains('bengaluru')) return 'bangalore';
      if (station.contains('hyderabad')) return 'hyderabad';
      if (station.contains('pune')) return 'pune';
      if (station.contains('ahmedabad')) return 'ahmedabad';
      if (station.contains('coimbatore')) return 'coimbatore';
      return station;
    }
    
    final normalizedFrom = normalizeStation(from.toLowerCase());
    final normalizedTo = normalizeStation(to.toLowerCase());
    
    // Filter trains that match the route from existing data
    _filteredTrains = _trains.where((train) {
      final trainFrom = normalizeStation(train['from']?.toString() ?? '');
      final trainTo = normalizeStation(train['to']?.toString() ?? '');
      return trainFrom == normalizedFrom && trainTo == normalizedTo;
    }).toList();
    
    // If no exact match, try partial matching
    if (_filteredTrains.isEmpty) {
      _filteredTrains = _trains.where((train) {
        final trainFrom = normalizeStation(train['from']?.toString() ?? '');
        final trainTo = normalizeStation(train['to']?.toString() ?? '');
        return trainFrom.contains(normalizedFrom) && trainTo.contains(normalizedTo);
      }).toList();
    }
    
    // If still no trains found, dynamically generate trains for this route
    if (_filteredTrains.isEmpty) {
      if (kDebugMode) {
        print('No trains found in dataset for route: $from → $to');
        print('Generating trains dynamically...');
      }
      _filteredTrains = DynamicTrainGenerator.generateTrainsForRoute(from, to);
    }
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

  String _getFormattedDate() {
    final date = widget.searchArgs?['date'] as DateTime?;
    if (date == null) return 'Select Date';
    
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    return '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
  }
  
  Color _getAvailabilityColor(String availability) {
    if (availability.startsWith('CURR_AVBL')) {
      return Colors.green;
    } else if (availability.startsWith('RAC')) {
      return Colors.orange;
    } else if (availability.startsWith('WL')) {
  return Theme.of(context).colorScheme.primary;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          // Header with route info
          Container(
            width: double.infinity,
            color: Colors.white,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, color: Colors.black87),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${widget.searchArgs?['from'] ?? 'NDLS'} → ${widget.searchArgs?['to'] ?? 'MMCT'}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.calendar_today, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const SizedBox(width: 56), // Align with back button
                        Text(
                          '${_getFormattedDate()} • ${_filteredTrains.length} Train${_filteredTrains.length != 1 ? 's' : ''}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Filter tabs
          Container(
            height: 50,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedFilter = filter),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        filter,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(height: 1),

          // Train list
          Expanded(
            child: _filteredTrains.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.train,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No trains available',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'for this route',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredTrains.length,
                    itemBuilder: (context, index) {
                      final train = _filteredTrains[index];
                      return _buildRedRailTrainCard(train, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRedRailTrainCard(Map<String, dynamic> train, int index) {
    // Get fares and availability maps
    final faresMap = train['fares'] as Map<String, dynamic>?;
    final availabilityMap = train['availability'] as Map<String, dynamic>?;
    
    // Normalize classes into a list of maps with predictable fields
    final classesRaw = train['classes'];
    final List<Map<String, dynamic>> classesList = [];
    if (classesRaw is List) {
      for (var c in classesRaw) {
        if (c is String) {
          // Get fare from fares map
          final fare = faresMap?[c];
          final fareStr = fare != null ? '₹$fare' : '₹0';
          
          // Get availability from availability map
          final avail = availabilityMap != null && availabilityMap[c] != null
              ? availabilityMap[c].toString()
              : 'Unknown';
          
          classesList.add({
            'name': c,
            'price': fareStr,
            'availability': avail,
            'tatkal': false
          });
        } else if (c is Map) {
          classesList.add(Map<String, dynamic>.from(c));
        } else {
          // Unexpected type
          classesList.add({'name': c.toString(), 'price': '₹0', 'availability': 'Unknown', 'tatkal': false});
        }
      }
    } else if (classesRaw is Map) {
      // If classes stored as a map (e.g., TrainModel.toJson()), convert entries to list
      classesRaw.forEach((k, v) {
        if (v is Map) {
          final m = Map<String, dynamic>.from(v);
          m['name'] = m['name'] ?? k;
          classesList.add(m);
        } else {
          classesList.add({'name': k, 'price': v?.toString() ?? '₹0', 'availability': 'Unknown', 'tatkal': false});
        }
      });
    }

    // Compute the lowest price class safely from normalized classesList
    Map<String, dynamic>? lowestPriceClass;
    int? lowestPrice;
    for (final c in classesList) {
      final priceStr = (c['price'] ?? '0').toString();
      final digits = priceStr.replaceAll(RegExp(r'[^0-9]'), '');
      final p = int.tryParse(digits) ?? 0;
      if (lowestPrice == null || p < lowestPrice) {
        lowestPrice = p;
        lowestPriceClass = c;
      }
    }

    // Safe string coercions for fields that may be null or lists
    final number = (train['number'] ?? train['trainNumber'] ?? '').toString();
    final trainType = (train['trainType'] ?? train['type'] ?? '').toString();
    final trainName = (train['name'] ?? '').toString();
    final runningDays = train['runningDays'] is List
        ? (train['runningDays'] as List).join(', ')
        : (train['runningDays'] ?? '').toString();
    final departure = (train['departure'] ?? '').toString();
    final fromStation = (train['from'] ?? '').toString();
    final durationStr = (train['duration'] ?? '').toString();
    final arrival = (train['arrival'] ?? '').toString();
    final toStation = (train['to'] ?? '').toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Train header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            number,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              trainType,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.green.shade800,
                              ),
                            ),
                          ),
                          if ((train['pantryAvailable'] ?? false)) ...[
                            const SizedBox(width: 6),
                            Icon(Icons.restaurant, size: 14, color: Colors.orange.shade600),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        trainName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  runningDays,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Journey details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Departure
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        departure,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        fromStation,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Duration with line
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        durationStr,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          CircleAvatar(radius: 4, backgroundColor: Colors.green),
                          Expanded(
                            child: Container(
                              height: 2,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          CircleAvatar(radius: 4, backgroundColor: Theme.of(context).colorScheme.primary),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Arrival
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        arrival,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        toStation,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Class pricing section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                // Class options (use normalized classesList)
                Row(
                  children: classesList.map<Widget>((trainClass) {
                    final name = trainClass['name']?.toString() ?? '';
                    final availability = trainClass['availability']?.toString() ?? 'Unknown';
                    final tatkal = trainClass['tatkal'] == true;
                    final price = trainClass['price']?.toString() ?? '₹0';
                    
                    // Extract numeric fare
                    final numericFare = double.tryParse(price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
                    
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to berth selection with selected class info
                          Navigator.pushNamed(
                            context,
                            '/berth-selection',
                            arguments: {
                              ...train,
                              'selectedClass': name,
                              'fare': numericFare,
                              'classAvailability': availability,
                            },
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      name,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  if (tatkal)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade100,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Text(
                                        'TK',
                                        style: TextStyle(
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange.shade800,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getAvailabilityColor(availability).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: _getAvailabilityColor(availability).withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  availability,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: _getAvailabilityColor(availability),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                price,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 12),
                
                // Instruction text
                Text(
                  'Tap on a class to book',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 12),
                // Book Now button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle book now action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'BOOK NOW',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: index * 100)).fadeIn().slideY(begin: 0.2);
  }
}