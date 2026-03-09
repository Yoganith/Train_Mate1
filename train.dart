class Train {
  final String id;
  final String name;
  final String number;
  final String from;
  final String to;
  final String departure;
  final String arrival;
  final String duration;
  final double rating;
  final String trainType;
  final String runningDays;
  final bool pantryAvailable;
  final List<Map<String, dynamic>> classes;
  final Map<String, dynamic>? fares;
  final Map<String, dynamic>? availability;

  Train({
    required this.id,
    required this.name,
    required this.number,
    required this.from,
    required this.to,
    required this.departure,
    required this.arrival,
    required this.duration,
    required this.rating,
    this.trainType = 'Express',
    this.runningDays = 'Runs on: M T W T F S S',
    this.pantryAvailable = true,
    this.classes = const [],
    this.fares,
    this.availability,
  });

}
