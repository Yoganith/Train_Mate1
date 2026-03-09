import 'package:flutter/material.dart';

class BerthTile extends StatelessWidget {
  final String berthNumber;
  final String type;
  final bool isAvailable;
  final bool isLadiesQuota;
  final VoidCallback onTap;

  const BerthTile({
    super.key,
    required this.berthNumber,
    required this.type,
    required this.isAvailable,
    required this.isLadiesQuota,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color seatColor =
  isAvailable ? (isLadiesQuota ? Colors.pink : Colors.green) : Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: isAvailable ? onTap : null,
      child: Container(
        width: 60,
        height: 50,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: seatColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            "$berthNumber\n$type",
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
