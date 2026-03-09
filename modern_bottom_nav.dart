import 'package:flutter/material.dart';

class ModernBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const ModernBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: NavigationBar(
          height: 65,
          selectedIndex: currentIndex,
          onDestinationSelected: onTap,
          backgroundColor: Colors.transparent,
          indicatorColor: colorScheme.primary.withOpacity(0.1),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            _buildNavItem(Icons.home, 'Home', currentIndex == 0),
            _buildNavItem(Icons.airplane_ticket, 'Bookings', currentIndex == 1),
            _buildNavItem(Icons.search, 'Search', currentIndex == 2),
            _buildNavItem(Icons.account_circle, 'Profile', currentIndex == 3),
          ],
        ),
      ),
    );
  }

  NavigationDestination _buildNavItem(IconData icon, String label, bool isSelected) {
    return NavigationDestination(
      icon: Icon(
        icon,
        size: 24,
        color: isSelected ? Colors.black87 : Colors.grey.shade600,
      ),
      selectedIcon: Icon(
        icon,
        size: 24,
        color: Colors.black87,
      ),
      label: label,
    );
  }
}
