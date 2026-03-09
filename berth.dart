class Berth {
  final String berthNumber;
  final String type; // LB, UB, SL, SU
  bool isAvailable;
  bool isLadiesQuota;

  Berth({
    required this.berthNumber,
    required this.type,
    this.isAvailable = true,
    this.isLadiesQuota = false,
  });
}
