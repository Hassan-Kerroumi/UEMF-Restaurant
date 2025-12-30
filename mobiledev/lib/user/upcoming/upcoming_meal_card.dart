import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import '../../data/upcoming_meal_model.dart';
import '../../providers/app_settings_provider.dart';
import '../../services/database_service.dart';

class UpcomingMealCard extends StatefulWidget {
  final UpcomingMeal meal;
  final bool isDark;
  final bool initialHasVoted;

  const UpcomingMealCard({
    super.key,
    required this.meal,
    required this.isDark,
    required this.initialHasVoted,
  });

  @override
  State<UpcomingMealCard> createState() => _UpcomingMealCardState();
}

class _UpcomingMealCardState extends State<UpcomingMealCard> {
  late bool _hasVoted;
  late int _localVoteCount;
  final DatabaseService _db = DatabaseService();
  bool _isVoting = false;

  @override
  void initState() {
    super.initState();
    _hasVoted = widget.initialHasVoted;
    _localVoteCount = widget.meal.voteCount;
  }

  // Update local state if parent passes new data, though we try to stay independent
  @override
  void didUpdateWidget(UpcomingMealCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.meal.voteCount != widget.meal.voteCount) {
      // Only update from parent if we are not currently optimistically updating
      // or if the difference is significant (e.g. real-time update from another user)
      if (!_isVoting) {
        _localVoteCount = widget.meal.voteCount;
      }
    }
    // We don't blindly update _hasVoted because local toggle is the source of truth for "my vote"
  }

  Future<void> _toggleVote() async {
    if (_isVoting) return;

    setState(() {
      _isVoting = true;
      if (_hasVoted) {
        _hasVoted = false;
        _localVoteCount--;
      } else {
        _hasVoted = true;
        _localVoteCount++;
      }
    });

    try {
      if (_hasVoted) {
        await _db.voteForMeal(widget.meal.id);
      } else {
        await _db.removeVoteForMeal(widget.meal.id);
      }
    } catch (e) {
      // Revert on error
      if (mounted) {
        setState(() {
          if (_hasVoted) {
            _hasVoted = false;
            _localVoteCount--;
          } else {
            _hasVoted = true;
            _localVoteCount++;
          }
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to vote: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isVoting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingsProvider>(context, listen: false);

    return Container(
      decoration: BoxDecoration(
        color: widget.isDark ? const Color(0xFF1a1f2e) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: widget.isDark
                ? Colors.black.withOpacity(0.2)
                : const Color(0xFF062c6b).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Container(
                color: widget.isDark
                    ? const Color(0xFF2d3748)
                    : Colors.grey[200],
                width: double.infinity,
                child: widget.meal.imageUrl != null
                    ? (widget.meal.imageUrl!.startsWith('data:image')
                          ? Image.memory(
                              base64Decode(widget.meal.imageUrl!.split(',')[1]),
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: widget.meal.imageUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: widget.isDark
                                    ? const Color(0xFF2d3748)
                                    : Colors.grey[300]!,
                                highlightColor: widget.isDark
                                    ? const Color(0xFF4a5568)
                                    : Colors.grey[100]!,
                                child: Container(color: Colors.white),
                              ),
                              errorWidget: (context, url, error) => Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ))
                    : Center(
                        child: Icon(
                          Icons.restaurant,
                          color: Colors.grey[400],
                          size: 40,
                        ),
                      ),
              ),
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
                        widget.meal.name[settings.language] ??
                            widget.meal.name['en'] ??
                            '',
                        style: TextStyle(
                          color: widget.isDark
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
                        settings.t(widget.meal.category),
                        style: TextStyle(
                          color: widget.isDark
                              ? Colors.grey[400]
                              : Colors.grey[600],
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
                        '${widget.meal.price} MAD',
                        style: TextStyle(
                          color: widget.isDark
                              ? const Color(0xFF3cad2a)
                              : const Color(0xFF062c6b),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      InkWell(
                        onTap: _toggleVote,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _hasVoted
                                ? (widget.isDark
                                      ? const Color(0xFF3cad2a).withOpacity(0.2)
                                      : const Color(
                                          0xFF062c6b,
                                        ).withOpacity(0.1))
                                : (widget.isDark
                                      ? Colors.white10
                                      : Colors.grey[200]),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _hasVoted
                                    ? Icons.thumb_up_rounded
                                    : Icons.thumb_up_outlined,
                                size: 14,
                                color: _hasVoted
                                    ? (widget.isDark
                                          ? const Color(0xFF3cad2a)
                                          : const Color(0xFF062c6b))
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$_localVoteCount',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _hasVoted
                                      ? (widget.isDark
                                            ? const Color(0xFF3cad2a)
                                            : const Color(0xFF062c6b))
                                      : Colors.grey,
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
