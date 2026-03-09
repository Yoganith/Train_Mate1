import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/user_session_service.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required int delay,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    ).animate()
      .scale(delay: delay.ms)
      .fadeIn();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('My Account'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Settings coming soon')),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: colorScheme.primaryContainer,
                            child: Icon(
                              Icons.account_circle,
                              size: 32,
                              color: colorScheme.primary,
                            ),
                          ).animate()
                            .scale(delay: 200.ms)
                            .fadeIn(),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  UserSessionService.userName,
                                  style: textTheme.titleLarge,
                                ).animate()
                                  .fadeIn(delay: 400.ms)
                                  .slideX(),
                                Text(
                                  UserSessionService.userEmail,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ).animate()
                                  .fadeIn(delay: 500.ms)
                                  .slideX(),
                              ],
                            ),
                          ),
                          IconButton.filled(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Edit profile coming soon')),
                              );
                            },
                            icon: const Icon(Icons.edit_outlined),
                          ).animate()
                            .scale(delay: 600.ms)
                            .fadeIn(),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Account Stats
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          icon: Icons.airplane_ticket_outlined,
                          title: '${UserSessionService.bookingCount}',
                          subtitle: 'Bookings',
                          delay: 300,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          icon: Icons.currency_rupee,
                          title: '₹4,590',
                          subtitle: 'Spent',
                          delay: 400,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          icon: Icons.star,
                          title: '4.8',
                          subtitle: 'Rating',
                          delay: 500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Account Settings
                  Text(
                    'Account Settings',
                    style: textTheme.titleMedium,
                  ).animate()
                    .fadeIn(delay: 600.ms)
                    .slideX(),

                  const SizedBox(height: 8),

                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.edit, color: colorScheme.primary),
                          title: const Text('Edit Profile'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.pushNamed(context, '/profile/edit'),
                        ),
                        Divider(color: colorScheme.outlineVariant),
                        ListTile(
                          leading: Icon(Icons.shield_outlined, color: colorScheme.primary),
                          title: const Text('Security Settings'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.pushNamed(context, '/profile/security'),
                        ),
                        Divider(color: colorScheme.outlineVariant),
                        ListTile(
                          leading: Icon(Icons.train, color: colorScheme.primary),
                          title: const Text('Track Train'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.pushNamed(context, '/track-train'),
                        ),
                        Divider(color: colorScheme.outlineVariant),
                        ListTile(
                          leading: Icon(Icons.notifications_outlined, color: colorScheme.primary),
                          title: const Text('Notifications'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.pushNamed(context, '/profile/notifications'),
                        ),
                        Divider(color: colorScheme.outlineVariant),
                        ListTile(
                          leading: Icon(Icons.help_outline, color: colorScheme.primary),
                          title: const Text('Help & Support'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.pushNamed(context, '/profile/help'),
                        ),
                        Divider(color: colorScheme.outlineVariant),
                        ListTile(
                          leading: Icon(Icons.logout, color: colorScheme.error),
                          title: Text(
                            'Logout',
                            style: TextStyle(color: colorScheme.error),
                          ),
                          onTap: () => Navigator.pushReplacementNamed(context, '/'),
                        ),
                      ],
                    ),
                  ).animate()
                    .fadeIn(delay: 700.ms)
                    .slideY(),

                  const SizedBox(height: 24),

                  // App Info
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.info, color: colorScheme.primary),
                          title: const Text('About RailBuddy'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.pushNamed(context, '/profile/about'),
                        ),
                        Divider(color: colorScheme.outlineVariant),
                        ListTile(
                          leading: Icon(Icons.description, color: colorScheme.primary),
                          title: const Text('Terms & Conditions'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.pushNamed(context, '/profile/terms'),
                        ),
                        Divider(color: colorScheme.outlineVariant),
                        ListTile(
                          leading: Icon(Icons.verified_user, color: colorScheme.primary),
                          title: const Text('Privacy Policy'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.pushNamed(context, '/profile/privacy'),
                        ),
                      ],
                    ),
                  ).animate()
                    .fadeIn(delay: 800.ms)
                    .slideY(),

                  const SizedBox(height: 16),
                  
                  Center(
                    child: Text(
                      'Version 2.0.0',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ).animate()
                    .fadeIn(delay: 900.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
