class Booking {
  final String pnr;
  final String trainName;
  final String trainNumber;
  final String source;
  final String destination;
  final String departureTime;
  final String arrivalTime;
  final String journeyDate;
  final List<String> seats;
  final String coach;
  final String coachClass;
  final String passengerName;
  final String gender;
  final double totalPrice;
  final String status; // Confirmed, Pending, Cancelled
  final String bookingDate;
  final String? qrCode;

  Booking({
    required this.pnr,
    required this.trainName,
    required this.trainNumber,
    required this.source,
    required this.destination,
    required this.departureTime,
    required this.arrivalTime,
    required this.journeyDate,
    required this.seats,
    required this.coach,
    required this.coachClass,
    required this.passengerName,
    required this.gender,
    required this.totalPrice,
    required this.status,
    required this.bookingDate,
    this.qrCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'pnr': pnr,
      'trainName': trainName,
      'trainNumber': trainNumber,
      'source': source,
      'destination': destination,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'journeyDate': journeyDate,
      'seats': seats,
      'coach': coach,
      'coachClass': coachClass,
      'passengerName': passengerName,
      'gender': gender,
      'totalPrice': totalPrice,
      'status': status,
      'bookingDate': bookingDate,
      'qrCode': qrCode,
    };
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      pnr: json['pnr'] ?? '',
      trainName: json['trainName'] ?? '',
      trainNumber: json['trainNumber'] ?? '',
      source: json['source'] ?? '',
      destination: json['destination'] ?? '',
      departureTime: json['departureTime'] ?? '',
      arrivalTime: json['arrivalTime'] ?? '',
      journeyDate: json['journeyDate'] ?? '',
      seats: List<String>.from(json['seats'] ?? []),
      coach: json['coach'] ?? '',
      coachClass: json['coachClass'] ?? '',
      passengerName: json['passengerName'] ?? '',
      gender: json['gender'] ?? 'Male',
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'Pending',
      bookingDate: json['bookingDate'] ?? '',
      qrCode: json['qrCode'],
    );
  }
}
