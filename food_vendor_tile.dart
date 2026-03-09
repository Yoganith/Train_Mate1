import 'package:flutter/material.dart';

class FoodVendorTile extends StatelessWidget {
  final String vendorName;
  final String station;
  final double rating;
  final VoidCallback onOrder;

  const FoodVendorTile({
    super.key,
    required this.vendorName,
    required this.station,
    required this.rating,
    required this.onOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 4,
      child: ListTile(
        title: Text(vendorName),
        subtitle: Text("Station: $station"),
        trailing: ElevatedButton(
          onPressed: onOrder,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text("Order"),
        ),
      ),
    );
  }
}
