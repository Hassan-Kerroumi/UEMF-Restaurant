import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_settings_provider.dart';
import '../../services/database_service.dart';
import '../../data/upcoming_meal_model.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserUpcomingScreen extends StatefulWidget {
  const UserUpcomingScreen({super.key});

  @override
  State<UserUpcomingScreen> createState() => _UserUpcomingScreenState();
}

class _UserUpcomingScreenState extends State<UserUpcomingScreen> {
  List<String> _votedMealIds = [];

  @override
  void initState() {
    super.initState();
    _loadVotedMeals();
  }

  Future<void> _loadVotedMeals() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _votedMealIds = prefs.getStringList('voted_meal_ids') ?? [];
    });
  }

  Future<void> _toggleVote(String mealId) async {
    if (_votedMealIds.contains(mealId)) return;

    try {
      await DatabaseService().voteForMeal(mealId);
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _votedMealIds.add(mealId);
      });
      await prefs.setStringList('voted_meal_ids', _votedMealIds);
      
      if (mounted) {
        final settings = Provider.of<AppSettingsProvider>(context, listen: false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(settings.t('voteSuccess') == 'voteSuccess' ? 'Vote added!' : settings.t('voteSuccess')),
            backgroundColor: const Color(0xFF3cad2a),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingsProvider>(context);
    final isDark = settings.isDarkMode;
    final db = DatabaseService();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0e1116) : const Color(0xFFf5f5f5),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1a1f2e) : Colors.white,
        elevation: 0,
        title: Text(
          settings.t('upcoming'),
          style: TextStyle(
            color: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        iconTheme: IconThemeData(
          color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
        ),
      ),
      body: StreamBuilder<List<UpcomingMeal>>(
        stream: db.getUpcomingMeals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final meals = snapshot.data ?? [];

          if (meals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_busy_rounded,
                    size: 64,
                    color: isDark ? const Color(0xFF1a1f2e) : Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    settings.t('noItemsFound'),
                    style: TextStyle(
                      color: isDark ? const Color(0xFF9ca3af) : Colors.grey[500],
                      fontFamily: 'Poppins',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: meals.length,
            itemBuilder: (context, index) {
              return _buildUpcomingMealCard(context, meals[index], isDark);
            },
          );
        },
      ),
    );
  }

  Widget _buildUpcomingMealCard(BuildContext context, UpcomingMeal meal, bool isDark) {
    final settings = Provider.of<AppSettingsProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1a1f2e) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.2) : const Color(0xFF062c6b).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF9ca3af).withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              image: meal.imageUrl != null
                  ? (meal.imageUrl!.startsWith('data:image')
                      ? DecorationImage(
                          image: MemoryImage(base64Decode(meal.imageUrl!.split(',')[1])),
                          fit: BoxFit.cover,
                        )
                      : DecorationImage(
                          image: NetworkImage(meal.imageUrl!),
                          fit: BoxFit.cover,
                        ))
                  : null,
            ),
            child: meal.imageUrl == null
                ? Center(
                    child: Icon(
                      Icons.restaurant_menu_rounded,
                      size: 48,
                      color: const Color(0xFF9ca3af).withOpacity(0.5),
                    ),
                  )
                : null,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        meal.name[settings.language] ?? meal.name['en'] ?? '',
                        style: TextStyle(
                          color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0e1116) : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '\$${meal.price}',
                        style: const TextStyle(
                          color: Color(0xFF3cad2a),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 16,
                      color: isDark ? Colors.white54 : Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      settings.t(meal.category),
                      style: TextStyle(
                        color: isDark ? Colors.white54 : Colors.grey[600],
                        fontFamily: 'Poppins',
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => _toggleVote(meal.id),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _votedMealIds.contains(meal.id)
                              ? const Color(0xFF3cad2a).withOpacity(0.2)
                              : const Color(0xFF3b82f6).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: _votedMealIds.contains(meal.id)
                              ? Border.all(color: const Color(0xFF3cad2a), width: 1)
                              : null,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _votedMealIds.contains(meal.id) ? Icons.thumb_up_alt_rounded : Icons.thumb_up_off_alt_rounded,
                              size: 14,
                              color: _votedMealIds.contains(meal.id) ? const Color(0xFF3cad2a) : const Color(0xFF3b82f6),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${meal.voteCount} votes',
                              style: TextStyle(
                                color: _votedMealIds.contains(meal.id) ? const Color(0xFF3cad2a) : const Color(0xFF3b82f6),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
