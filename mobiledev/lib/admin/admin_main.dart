import 'package:flutter/material.dart';
import 'admin_home_screen.dart';
import 'admin_orders_screen.dart';
import 'admin_stats_screen.dart';
import 'admin_products_screen.dart';
import 'admin_upcoming_screen.dart';

class AdminMain extends StatefulWidget {
  const AdminMain({super.key});

  @override
  State<AdminMain> createState() => _AdminMainState();
}

class _AdminMainState extends State<AdminMain> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const AdminHomeScreen(),
    const AdminOrdersScreen(),
    const AdminStatsScreen(),
    const AdminProductsScreen(),
    const AdminUpcomingScreen(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1a1f2e),
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home,
                  label: 'Home',
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.list_alt,
                  label: 'Orders',
                  index: 1,
                ),
                _buildNavItem(
                  icon: Icons.bar_chart,
                  label: 'Stats',
                  index: 2,
                ),
                _buildNavItem(
                  icon: Icons.inventory,
                  label: 'Products',
                  index: 3,
                ),
                _buildNavItem(
                  icon: Icons.upcoming,
                  label: 'Upcoming',
                  index: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
            ? const Color(0xFFc74242).withOpacity(0.1)
            : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected 
                ? const Color(0xFFc74242)
                : const Color(0xFF9ca3af),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected 
                  ? const Color(0xFFc74242)
                  : const Color(0xFF9ca3af),
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
