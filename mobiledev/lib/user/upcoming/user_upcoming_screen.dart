import 'dart:convert';
import 'package:flutter/material.dart';
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
                fontWeight: FontWeight.bold,
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

              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        _buildMealCard(meals[index], isDark, settings),
                    childCount: meals.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard(
    UpcomingMeal meal,
    bool isDark,
    AppSettingsProvider settings,
  ) {
    final hasVoted = _votedMeals.contains(meal.id);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1a1f2e) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                image: meal.imageUrl != null
                    ? (meal.imageUrl!.startsWith('data:image')
                          ? DecorationImage(
                              image: MemoryImage(
                                base64Decode(meal.imageUrl!.split(',')[1]),
                              ),
                              fit: BoxFit.cover,
                            )
                          : DecorationImage(
                              image: NetworkImage(meal.imageUrl!),
                              fit: BoxFit.cover,
                            ))
                    : null,
                color: isDark ? const Color(0xFF2d3748) : Colors.grey[200],
              ),
              child: meal.imageUrl == null
                  ? Center(
                      child: Icon(
                        Icons.restaurant,
                        color: Colors.grey[400],
                        size: 40,
                      ),
                    )
                  : null,
            ),
          ),

          // Content
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.name[settings.language] ?? meal.name['en'] ?? '',
                        style: TextStyle(
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1a1a1a),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        settings.t(meal.category),
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${meal.price}',
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFF3cad2a)
                              : const Color(0xFF062c6b),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      InkWell(
                        onTap: hasVoted
                            ? null
                            : () async {
                                setState(() => _votedMeals.add(meal.id));
                                await _db.voteForMeal(meal.id);
                              },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: hasVoted
                                ? (isDark ? Colors.white10 : Colors.grey[200])
                                : (isDark
                                      ? const Color(0xFF3cad2a).withOpacity(0.2)
                                      : const Color(
                                          0xFF062c6b,
                                        ).withOpacity(0.1)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                hasVoted ? Icons.check_circle : Icons.thumb_up,
                                size: 14,
                                color: hasVoted
                                    ? Colors.grey
                                    : (isDark
                                          ? const Color(0xFF3cad2a)
                                          : const Color(0xFF062c6b)),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${meal.voteCount}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: hasVoted
                                      ? Colors.grey
                                      : (isDark
                                            ? const Color(0xFF3cad2a)
                                            : const Color(0xFF062c6b)),
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
          ),
        ],
      ),
    );
  }
}
