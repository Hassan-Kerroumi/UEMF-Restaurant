import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_settings_provider.dart';
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
    final settings = Provider.of<AppSettingsProvider>(context);
    final isDark = settings.isDarkMode;

    return Scaffold(
      extendBody: true, // Important for floating effect
      body: _screens[_currentIndex],
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1a1f2e).withOpacity(0.95) : Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(
                icon: Icons.home_rounded,
                label: settings.t('home'),
                index: 0,
                isDark: isDark,
              ),
              _buildNavItem(
                icon: Icons.receipt_long_rounded,
                label: settings.t('orders'),
                index: 1,
                isDark: isDark,
              ),
              _buildNavItem(
                icon: Icons.insights_rounded,
                label: settings.t('stats'),
                index: 2,
                isDark: isDark,
              ),
              _buildNavItem(
                icon: Icons.inventory_2_rounded,
                label: settings.t('products'),
                index: 3,
                isDark: isDark,
              ),
              _buildNavItem(
                icon: Icons.upcoming_rounded,
                label: settings.t('upcoming'),
                index: 4,
                isDark: isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isDark,
  }) {
    final isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected 
            ? (isDark ? const Color(0xFF3cad2a).withOpacity(0.15) : const Color(0xFF062c6b).withOpacity(0.1))
            : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected 
                ? (isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b))
                : (isDark ? const Color(0xFF9ca3af) : const Color(0xFF9ca3af)),
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected 
                    ? (isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b))
                    : (isDark ? const Color(0xFF9ca3af) : const Color(0xFF9ca3af)),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
