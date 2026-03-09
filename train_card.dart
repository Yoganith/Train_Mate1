import 'package:flutter/material.dart';

class TrainCard extends StatelessWidget {
  final String name;
  final String number;
  final String timing;
  final String duration;
  final double rating;
  final VoidCallback onTap;

  const TrainCard({
    super.key,
    required this.name,
    required this.number,
    required this.timing,
    required this.duration,
    required this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: Text("$name ($number)",
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Timing: $timing\nDuration: $duration"),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, color: Theme.of(context).colorScheme.secondary),
            Text(rating.toString()),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
