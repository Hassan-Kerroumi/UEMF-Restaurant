import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/app_settings_provider.dart';
import 'home/user_home_screen.dart';
import 'history/user_history_screen.dart';
import 'upcoming/user_upcoming_screen.dart';
import 'cart/cart_sheet.dart';

class UserMain extends StatefulWidget {
  const UserMain({super.key});

  @override
  State<UserMain> createState() => _UserMainState();
}

class _UserMainState extends State<UserMain> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const UserHomeScreen(),
    const UserHistoryScreen(),
    const UserUpcomingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // For translation keys
    final settings = Provider.of<AppSettingsProvider>(context);

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Theme.of(context).cardColor,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: settings.t('home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.history),
            label: settings.t('orders'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.schedule),
            label: settings.t('upcoming'),
          ),
        ],
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
            backgroundColor: Theme.of(context).primaryColor,
            icon: const Icon(Icons.shopping_basket, color: Colors.white),
            label: Text(
              '${cart.itemCount}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}
