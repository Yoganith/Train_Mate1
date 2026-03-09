import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class TrainTrackingScreen extends StatefulWidget {
  const TrainTrackingScreen({super.key});

  @override
  State<TrainTrackingScreen> createState() => _TrainTrackingScreenState();
}

class _TrainTrackingScreenState extends State<TrainTrackingScreen> {
  final TextEditingController _trainNumberController = TextEditingController();
  bool _isTracking = false;
  String? _trainNumber;
  
  // Mock train data
  final Map<String, dynamic> _mockTrainData = {
    'trainNumber': '12951',
    'trainName': 'Rajdhani Express',
    'from': 'New Delhi',
    'to': 'Mumbai Central',
    'departureTime': '16:55',
    'arrivalTime': '08:15',
    'currentLocation': 'Approaching Vadodara Junction',
    'delay': '15 min',
    'platform': '3',
    'speed': '110 km/h',
    'nextStation': 'Vadodara Junction',
    'distance': '12 km',
    'stations': [
      {'name': 'New Delhi', 'arrival': '16:55', 'departure': '16:55', 'platform': '1', 'status': 'Departed', 'delay': 'On Time'},
      {'name': 'Kota Junction', 'arrival': '22:30', 'departure': '22:35', 'platform': '2', 'status': 'Departed', 'delay': '+5 min'},
      {'name': 'Ratlam Junction', 'arrival': '02:45', 'departure': '02:50', 'platform': '4', 'status': 'Departed', 'delay': '+10 min'},
      {'name': 'Vadodara Junction', 'arrival': '05:35', 'departure': '05:40', 'platform': '3', 'status': 'Approaching', 'delay': '+15 min'},
      {'name': 'Surat', 'arrival': '06:52', 'departure': '06:55', 'platform': '2', 'status': 'Upcoming', 'delay': 'TBD'},
      {'name': 'Mumbai Central', 'arrival': '08:15', 'departure': '--', 'platform': '--', 'status': 'Upcoming', 'delay': 'TBD'},
    ],
  };

  @override
  void dispose() {
    _trainNumberController.dispose();
    super.dispose();
  }

  void _trackTrain() {
    if (_trainNumberController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a train number')),
      );
      return;
    }
    
    setState(() {
      _isTracking = true;
      _trainNumber = _trainNumberController.text.trim();
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Departed':
        return Colors.grey;
      case 'Approaching':
        return AppTheme.accentCyan;
      case 'Upcoming':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Your Train'),
        actions: [
          if (_isTracking)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => setState(() {}),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
            ),
            child: Column(
              children: [
                TextField(
                  controller: _trainNumberController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter Train Number (e.g. 12951)',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    prefixIcon: const Icon(Icons.train, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _trackTrain,
                    icon: const Icon(Icons.search),
                    label: const Text('Track Train'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().slideY(begin: -0.2),

          // Train Status
          if (_isTracking)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Train Info Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.train,
                                    color: colorScheme.primary,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${_mockTrainData['trainNumber']} - ${_mockTrainData['trainName']}',
                                        style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${_mockTrainData['from']} → ${_mockTrainData['to']}',
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 100.ms).slideX(),

                    const SizedBox(height: 16),

                    // Current Status Card
                    Card(
                      color: AppTheme.accentCyan.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: AppTheme.accentCyan,
                                  size: 28,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Current Location',
                                        style: textTheme.labelMedium,
                                      ),
                                      Text(
                                        _mockTrainData['currentLocation'],
                                        style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.accentCyan,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatusItem(
                                  context,
                                  icon: Icons.speed,
                                  label: 'Speed',
                                  value: _mockTrainData['speed'],
                                ),
                                _buildStatusItem(
                                  context,
                                  icon: Icons.schedule,
                                  label: 'Delay',
                                  value: _mockTrainData['delay'],
                                  color: Colors.orange,
                                ),
                                _buildStatusItem(
                                  context,
                                  icon: Icons.navigation,
                                  label: 'Next Station',
                                  value: _mockTrainData['distance'],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 200.ms).slideX(),

                    const SizedBox(height: 24),

                    // Station Timeline
                    Text(
                      'Station Timeline',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn(delay: 300.ms),
                    
                    const SizedBox(height: 12),

                    Card(
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: (_mockTrainData['stations'] as List).length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final station = (_mockTrainData['stations'] as List)[index];
                          final isCurrentStation = station['status'] == 'Approaching';
                          
                          return ListTile(
                            leading: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(station['status']).withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Icon(
                                  station['status'] == 'Departed'
                                      ? Icons.check_circle
                                      : station['status'] == 'Approaching'
                                          ? Icons.location_on
                                          : Icons.circle_outlined,
                                  color: _getStatusColor(station['status']),
                                ),
                              ],
                            ),
                            title: Text(
                              station['name'],
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: isCurrentStation ? FontWeight.bold : FontWeight.normal,
                                color: isCurrentStation ? AppTheme.accentCyan : null,
                              ),
                            ),
                            subtitle: Text(
                              'Arrival: ${station['arrival']} | Platform: ${station['platform']}',
                              style: textTheme.bodySmall,
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(station['status']).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                station['delay'],
                                style: textTheme.labelSmall?.copyWith(
                                  color: _getStatusColor(station['status']),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ).animate().fadeIn(delay: 400.ms),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? color,
  }) {
    final textTheme = Theme.of(context).textTheme;
    
    return Column(
      children: [
        Icon(icon, color: color ?? AppTheme.accentCyan),
        const SizedBox(height: 4),
        Text(
          value,
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: textTheme.labelSmall,
        ),
      ],
    );
  }
}
