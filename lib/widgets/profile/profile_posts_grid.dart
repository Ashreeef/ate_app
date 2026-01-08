import 'package:flutter/material.dart';
import '../../utils/constants.dart';

/// Enhanced grid layout displaying user's posts with improved interaction and styling
class ProfilePostsGrid extends StatelessWidget {
  final List<Map<String, dynamic>> posts;
  final Function(String)? onPostTap;

  const ProfilePostsGrid({super.key, required this.posts, this.onPostTap});

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return _buildEmptyState(context);
    }

    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: AppSpacing.xs,
          mainAxisSpacing: AppSpacing.xs,
          childAspectRatio: 1,
        ),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return GestureDetector(
            onTap: () {
              if (onPostTap != null) {
                onPostTap!(post['id'] as String);
              }
            },
            child: _PostThumbnail(
              imageUrl: post['imageUrl'] as String,
              likes: post['likes'] as int,
              comments: post['comments'] as int? ?? 0,
              index: index,
            ),
          );
        },
      ),
    );
  }

  /// Build empty state when no posts are available
  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 64,
            color: AppColors.textLight,
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'No posts yet',
            style: AppTextStyles.heading3.copyWith(color: AppColors.textMedium),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Share your first culinary experience!',
            style: AppTextStyles.body.copyWith(color: AppColors.textLight),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _PostThumbnail extends StatefulWidget {
  final String imageUrl;
  final int likes;
  final int comments;
  final int index;

  const _PostThumbnail({
    required this.imageUrl,
    required this.likes,
    this.comments = 0,
    required this.index,
  });

  @override
  State<_PostThumbnail> createState() => _PostThumbnailState();
}

class _PostThumbnailState extends State<_PostThumbnail>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _scaleController.forward(),
            onTapUp: (_) => _scaleController.reverse(),
            onTapCancel: () => _scaleController.reverse(),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Image with hero animation for smooth transitions
                    Hero(
                      tag: 'post_${widget.imageUrl}_${widget.index}',
                      child: Image.network(
                        widget.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Theme.of(context).cardTheme.color,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.broken_image_outlined,
                                  color: AppColors.textLight,
                                  size: AppSizes.iconLg,
                                ),
                                SizedBox(height: AppSpacing.xs),
                                Text(
                                  'Failed to load',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textLight,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Theme.of(context).cardTheme.color,
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Gradient overlay for better text readability
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                            stops: [0.6, 1.0],
                          ),
                        ),
                      ),
                    ),

                    // Enhanced stats overlay
                    Positioned(
                      right: AppSpacing.xs,
                      bottom: AppSpacing.xs,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.comments > 0) ...[
                            _buildStatBadge(
                              Icons.chat_bubble_outline_rounded,
                              widget.comments,
                            ),
                            SizedBox(width: AppSpacing.xs),
                          ],
                          _buildStatBadge(
                            Icons.favorite,
                            widget.likes,
                            isLike: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build stat badge for likes/comments
  Widget _buildStatBadge(IconData icon, int count, {bool isLike = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isLike ? AppColors.error : Colors.white, size: 12),
          SizedBox(width: 2),
          Text(
            count > 999 ? '999+' : count.toString(),
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
