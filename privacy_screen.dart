import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Data Collection', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            'We collect minimal information needed to provide booking services, such as contact details and journey information.',
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Text('Usage', style: textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            'Your information is used to facilitate bookings, send notifications, and improve the service. We do not sell your data.',
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          Text('Security', style: textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            'We use industry-standard practices to protect your data. Enable 2FA in Security Settings for extra protection.',
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}


