import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ModernDrawer extends StatelessWidget {
  const ModernDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.train,
                  size: 48,
                  color: Colors.white,
                )
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(duration: const Duration(seconds: 2)),
                const SizedBox(height: 16),
                Text(
                  'RailBuddy',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Your Smart Travel Companion',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.search,
                  title: 'Search Trains',
                  route: '/train_search',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.receipt_long,
                  title: 'Transactions',
                  route: '/transactions',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.airplane_ticket,
                  title: 'PNR Enquiry',
                  route: '/pnr',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.train,
                  title: 'Track Train',
                  route: '/track-train',
                ),
                const Divider(),
                _buildDrawerItem(
                  context,
                  icon: Icons.account_circle,
                  title: 'My Account',
                  route: '/account',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.settings,
                  title: 'Settings',
                  route: '/more',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.logout,
                  title: 'Logout',
                  route: '/',
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: isDestructive
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
      ),
      onTap: () {
        Navigator.pop(context); // Close drawer
        if (route == '/') {
          Navigator.pushReplacementNamed(context, route);
        } else {
          Navigator.pushNamed(context, route);
        }
      },
    )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 200))
        .slideX(begin: -0.2, duration: const Duration(milliseconds: 200));
  }
}
