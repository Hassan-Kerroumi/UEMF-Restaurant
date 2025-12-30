import 'package:flutter/material.dart';
import 'upcoming_meal_card.dart';
import 'package:provider/provider.dart';
import '../../providers/app_settings_provider.dart';
import '../../services/database_service.dart';
import '../../data/upcoming_meal_model.dart';

class UserUpcomingScreen extends StatefulWidget {
  const UserUpcomingScreen({super.key});

  @override
  State<UserUpcomingScreen> createState() => _UserUpcomingScreenState();
}

class _UserUpcomingScreenState extends State<UserUpcomingScreen> {
  final DatabaseService _db = DatabaseService();
  final Set<String> _votedMeals = {}; // Track locally for this session

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingsProvider>(context);
    final isDark = settings.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0e1116)
          : const Color(0xFFf5f5f5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: isDark ? const Color(0xFF1a1f2e) : Colors.white,
            elevation: 0,
            floating: true,
            title: Text(
              settings.t('upcomingMenu'),
              style: TextStyle(
                color: isDark
                    ? const Color(0xFF3cad2a)
                    : const Color(0xFF062c6b),
                fontSize: 24,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          StreamBuilder<List<UpcomingMeal>>(
            stream: _db.getUpcomingMeals(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(child: Text('Error: ${snapshot.error}')),
                );
              }

              final meals = snapshot.data ?? [];

              if (meals.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_available,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          settings.t('noItemsFound'),
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.grey[600],
                            fontFamily: 'Poppins',
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final breakfastMeals = meals
                  .where((m) => m.category == 'breakfast')
                  .toList();
              final lunchMeals = meals
                  .where((m) => m.category == 'lunch')
                  .toList();
              final dinnerMeals = meals
                  .where((m) => m.category == 'dinner')
                  .toList();

              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    if (breakfastMeals.isNotEmpty)
                      _buildCategorySection(
                        settings.t('breakfast'),
                        breakfastMeals,
                        isDark,
                        settings,
                      ),
                    if (lunchMeals.isNotEmpty)
                      _buildCategorySection(
                        settings.t('lunch'),
                        lunchMeals,
                        isDark,
                        settings,
                      ),
                    if (dinnerMeals.isNotEmpty)
                      _buildCategorySection(
                        settings.t('dinner'),
                        dinnerMeals,
                        isDark,
                        settings,
                      ),
                  ]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(
    String title,
    List<UpcomingMeal> meals,
    bool isDark,
    AppSettingsProvider settings,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF3cad2a)
                      : const Color(0xFF062c6b),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFFf9fafb)
                      : const Color(0xFF1a1a1a),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 280, // Fixed height for the horizontal list
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: meals.length,
            itemBuilder: (context, index) {
              final meal = meals[index];
              final hasVoted = _votedMeals.contains(meal.id);
              return Container(
                width: 200, // Fixed width for each card
                margin: const EdgeInsets.only(right: 16, bottom: 16),
                child: UpcomingMealCard(
                  meal: meal,
                  isDark: isDark,
                  initialHasVoted: hasVoted,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
