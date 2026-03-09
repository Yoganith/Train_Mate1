import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> options = [
      {
        'icon': Icons.airplane_ticket_outlined,
        'title': 'PNR Status',
        'description': 'Check your PNR status and seat details',
        'route': '/pnr',
        'category': 'Services'
      },
      {
        'icon': Icons.train,
        'title': 'Live Train Status',
        'description': 'Track your train in real-time',
        'route': '/track-train',
        'category': 'Services'
      },
      {
        'icon': Icons.restaurant,
        'title': 'Order Food',
        'description': 'Order food to be delivered to your seat',
        'route': '/food',
        'category': 'Services'
      },
      {
        'icon': Icons.local_offer,
        'title': 'Offers & Discounts',
        'description': 'Exclusive deals and promotions',
        'route': null,
        'category': 'Offers'
      },
      {
        'icon': Icons.wallet,
        'title': 'RailWallet',
        'description': 'Quick refunds and easy payments',
        'route': null,
        'category': 'Payments'
      },
      {
        'icon': Icons.history,
        'title': 'Booking History',
        'description': 'View all your past bookings',
        'route': null,
        'category': 'Account'
      },
      {
        'icon': Icons.group,
        'title': 'Saved Travellers',
        'description': 'Manage frequent traveller profiles',
        'route': null,
        'category': 'Account'
      },
      {
        'icon': Icons.credit_card,
        'title': 'Saved Cards',
        'description': 'Manage your payment methods',
        'route': null,
        'category': 'Payments'
      },
      {
        'icon': Icons.support_agent,
        'title': 'Customer Support',
        'description': '24/7 customer assistance',
        'route': null,
        'category': 'Support'
      },
      {
        'icon': Icons.question_answer,
        'title': 'Help & FAQs',
        'description': 'Frequently asked questions',
        'route': null,
        'category': 'Support'
      },
      {
        'icon': Icons.verified_user,
        'title': 'Privacy Policy',
        'description': 'Our privacy policies and terms',
        'route': null,
        'category': 'Legal'
      },
      {
        'icon': Icons.info,
        'title': 'About Us',
        'description': 'Learn more about RailBuddy',
        'route': null,
        'category': 'Legal'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Quick Actions Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 0,
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Actions',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildQuickAction(
                            context,
                            icon: Icons.airplane_ticket_outlined,
                            label: 'PNR\nStatus',
                            onTap: () => Navigator.pushNamed(context, '/pnr'),
                          ),
                          _buildQuickAction(
                            context,
                            icon: Icons.restaurant,
                            label: 'Order\nFood',
                            onTap: () => Navigator.pushNamed(context, '/food'),
                          ),
                          _buildQuickAction(
                            context,
                            icon: Icons.train,
                            label: 'Live\nStatus',
                            onTap: () => Navigator.pushNamed(context, '/track-train'),
                          ),
                          _buildQuickAction(
                            context,
                            icon: Icons.wallet,
                            label: 'Rail\nWallet',
                            onTap: () =>
                                ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Coming Soon!')),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 100.ms).slideX(),

            // Options List by Category
            ...groupOptionsByCategory(options).entries.map((entry) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        entry.key,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                    Card(
                      elevation: 0,
                      child: Column(
                        children: entry.value.map((option) {
                          return ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                option['icon'],
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            title: Text(option['title']),
                            subtitle: Text(
                              option['description'],
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              if (option['route'] != null) {
                                Navigator.pushNamed(context, option['route']);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "${option['title']} Coming Soon!")),
                                );
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms).slideX();
            }).toList(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.secondary,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  height: 1.2,
                ),
          ),
        ],
      ),
    );
  }

  Map<String, List<Map<String, dynamic>>> groupOptionsByCategory(
      List<Map<String, dynamic>> options) {
    final groupedOptions = <String, List<Map<String, dynamic>>>{};
    for (final option in options) {
      final category = option['category'] as String;
      if (!groupedOptions.containsKey(category)) {
        groupedOptions[category] = [];
      }
      groupedOptions[category]!.add(option);
    }
    return groupedOptions;
  }
}
