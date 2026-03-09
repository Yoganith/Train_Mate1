import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool bookingUpdates = true;
  bool offers = true;
  bool foodStatus = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        children: [
          SwitchListTile(
            value: bookingUpdates,
            title: const Text('Booking Updates'),
            subtitle: const Text('PNR, seat, schedule, and delay updates'),
            onChanged: (v) => setState(() => bookingUpdates = v),
          ),
          SwitchListTile(
            value: offers,
            title: const Text('Promotions & Offers'),
            subtitle: const Text('Discounts, coupons, and special deals'),
            onChanged: (v) => setState(() => offers = v),
          ),
          SwitchListTile(
            value: foodStatus,
            title: const Text('Food Order Status'),
            subtitle: const Text('Order confirmations and delivery info'),
            onChanged: (v) => setState(() => foodStatus = v),
          ),
        ],
      ),
    );
  }
}


