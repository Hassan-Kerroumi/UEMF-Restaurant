import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/app_settings_provider.dart';
import 'home/user_home_screen.dart';
import 'history/user_history_screen.dart';
import 'upcoming/user_upcoming_screen.dart';
import 'cart/cart_sheet.dart';

class UserMain extends StatefulWidget {
  // Accept userData map
  final Map<String, dynamic> userData;

  const UserMain({super.key, required this.userData});

  @override
  State<UserMain> createState() => _UserMainState();
}

class _UserMainState extends State<UserMain> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize Cart with User Info immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final name = widget.userData['name'] ?? 'Student';
      final id = widget.userData['id'] ?? '';
      Provider.of<CartProvider>(context, listen: false).setUser(id, name);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Pass user ID to History Screen
    final List<Widget> screens = [
      const UserHomeScreen(),
      UserHistoryScreen(userId: widget.userData['id'] ?? ''), // Pass param here
      const UserUpcomingScreen(),
    ];

    final settings = Provider.of<AppSettingsProvider>(context);
    final isDark = settings.isDarkMode;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: screens),
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
              _buildNavItem(icon: Icons.home_rounded, label: settings.t('home'), index: 0, isDark: isDark),
              _buildNavItem(icon: Icons.history_rounded, label: settings.t('orders'), index: 1, isDark: isDark),
              _buildNavItem(icon: Icons.schedule_rounded, label: settings.t('upcoming'), index: 2, isDark: isDark),
            ],
          ),
        ),
      ),
      floatingActionButton: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.itemCount == 0) return const SizedBox.shrink();
          return FloatingActionButton.extended(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const CartSheet(),
              );
            },
            backgroundColor: const Color(0xFF3cad2a),
            icon: const Icon(Icons.shopping_basket_rounded, color: Colors.white),
            label: Text('${cart.itemCount}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
          );
        },
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String label, required int index, required bool isDark}) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? (isDark ? const Color(0xFF3cad2a).withOpacity(0.15) : const Color(0xFF062c6b).withOpacity(0.1)) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? (isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b)) : (isDark ? const Color(0xFF9ca3af) : const Color(0xFF9ca3af)), size: 24),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Text(label, style: TextStyle(color: isSelected ? (isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b)) : (isDark ? const Color(0xFF9ca3af) : const Color(0xFF9ca3af)), fontSize: 10, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
            ],
          ],
        ),
      ),
    );
  }
}