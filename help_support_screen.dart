import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('FAQs', style: textTheme.titleMedium),
          const SizedBox(height: 12),
          ExpansionTile(
            title: const Text('How to book a ticket?'),
            children: const [
              Padding(
                padding: EdgeInsets.all(12),
                child: Text('Search → Select Train → Choose Berth → Enter Details → Book.'),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('How to cancel my booking?'),
            children: const [
              Padding(
                padding: EdgeInsets.all(12),
                child: Text('Go to Bookings, open your ticket, and tap Cancel.'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Contact Us', style: textTheme.titleMedium),
          const SizedBox(height: 12),
          ListTile(
            leading: Icon(Icons.email, color: colorScheme.primary),
            title: const Text('support@railbuddy.app'),
            subtitle: const Text('Email support'),
          ),
          ListTile(
            leading: Icon(Icons.phone, color: colorScheme.primary),
            title: const Text('+91-800-000-0000'),
            subtitle: const Text('9 AM – 9 PM, Mon–Sat'),
          ),
        ],
      ),
    );
  }
}


