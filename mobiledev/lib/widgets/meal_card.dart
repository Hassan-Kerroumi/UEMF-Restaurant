import 'dart:convert';
import 'package:flutter/material.dart';
import '../data/meal_model.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  final bool isDark;
  final String language; // To show correct name
  final bool isAdmin;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MealCard({
    super.key,
    required this.meal,
    required this.isDark,
    required this.language,
    this.isAdmin = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Determine localized name
    final localizedName = meal.name[language] ?? meal.name['en'] ?? 'Unknown';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1a1f2e) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // === TOP: IMAGE & TAGS ===
            Expanded(
              flex: 6, // 60% height for image
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: _buildImage(meal.imageUrl),
                  ),
                  // Gradient Overlay for readability if needed
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.0),
                            Colors.black.withOpacity(0.05),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Price Tag (Floating Top Left)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF3cad2a).withOpacity(0.9) : const Color(0xFF062c6b).withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                           BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2))
                        ]
                      ),
                      child: Text(
                        '${meal.price.toStringAsFixed(0)} MAD',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  // Admin Actions (Floating Top Right)
                  if (isAdmin)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Row(
                        children: [
                          _buildCircleBtn(Icons.edit_rounded, Colors.blue, onEdit),
                          const SizedBox(width: 8),
                          _buildCircleBtn(Icons.delete_rounded, Colors.red, onDelete),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            
            // === BOTTOM: INFO ===
            Expanded(
              flex: 4, // 40% height for info
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
                          localizedName,
                          style: TextStyle(
                            color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            fontFamily: 'Poppins',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.restaurant_menu, size: 12, color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF9ca3af)),
                            const SizedBox(width: 4),
                            Text(
                              meal.category.toUpperCase(),
                              style: TextStyle(
                                color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF9ca3af),
                                fontSize: 10,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    // User specific: Add to cart indicator
                    if (!isAdmin)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                           Container(
                             padding: const EdgeInsets.all(8),
                             decoration: BoxDecoration(
                               color: (isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b)).withOpacity(0.1),
                               shape: BoxShape.circle,
                             ),
                             child: Icon(
                               Icons.add_shopping_cart_rounded,
                               size: 18,
                               color: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
                             ),
                           ),
                        ],
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to handle Network vs Base64 vs Errors
  Widget _buildImage(String? url) {
    if (url == null || url.isEmpty) {
        return _buildPlaceholder();
    }
    
    // Handle Base64 images (Web/Legacy)
    if (url.startsWith('data:image')) {
        try {
            return Image.memory(
                base64Decode(url.split(',')[1]),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildPlaceholder(),
            );
        } catch (e) {
            return _buildPlaceholder();
        }
    }
    
    // Handle Network images
    return Image.network(
        url,
        fit: BoxFit.cover,
        loadingBuilder: (ctx, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
                child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                    strokeWidth: 2,
                    color: isDark ? Colors.white24 : Colors.black12,
                ),
            );
        },
        errorBuilder: (ctx, error, stackTrace) {
            return _buildPlaceholder();
        },
    );
  }

  Widget _buildPlaceholder() {
      return Container(
          color: isDark ? const Color(0xFF2d3748) : const Color(0xFFe2e8f0),
          child: Center(
              child: Icon(
                  Icons.fastfood_rounded,
                  size: 32,
                  color: isDark ? const Color(0xFF4a5568) : const Color(0xFFcbd5e0),
              ),
          ),
      );
  }

  Widget _buildCircleBtn(IconData icon, Color color, VoidCallback? onTap) {
      return GestureDetector(
          onTap: onTap,
          child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  shape: BoxShape.circle,
                  boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)
                  ]
              ),
              child: Icon(icon, size: 16, color: color),
          ),
      );
  }
}