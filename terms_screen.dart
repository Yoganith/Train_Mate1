import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Terms & Conditions')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('User Agreement', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            'By using RailBuddy, you agree to our terms regarding ticket bookings, cancellations, refunds, and conduct during use of the app.',
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Text('Booking & Cancellation', style: textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            'Bookings are subject to availability. Cancellation and refund policies apply as per the applicable railway rules.',
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          Text('Liability', style: textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            'RailBuddy is a booking facilitator and is not responsible for schedule changes, delays, or service disruptions by rail operators.',
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}


