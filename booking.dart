class Booking {
  final String bookingId;
  final String trainName;
  final String from;
  final String to;
  final String date;
  final String seatNumber;
  final double price;

  Booking({
    required this.bookingId,
    required this.trainName,
    required this.from,
    required this.to,
    required this.date,
    required this.seatNumber,
    required this.price,
  });
}
