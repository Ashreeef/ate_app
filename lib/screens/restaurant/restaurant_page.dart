import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/restaurant/restaurant_header.dart';
import '../../widgets/restaurant/post_thumbnail.dart';
import '../../widgets/restaurant/menu_item_card.dart';
import '../../data/fake_data.dart';
import '../home/post_detail_screen.dart';

class RestaurantPage extends StatelessWidget {
  final String restaurantId;

  const RestaurantPage({Key? key, required this.restaurantId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final restaurant = FakeData.getRestaurantById(restaurantId);
    final posts = FakeData.getPostsByRestaurant(restaurantId);

    if (restaurant == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Restaurant')),
        body: Center(
          child: Text('Restaurant non trouvé', style: AppTextStyles.heading3),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(child: RestaurantHeader(restaurant: restaurant)),
          // Menu Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppSpacing.lg),
                  Text('Menu', style: AppTextStyles.heading3),
                  SizedBox(height: AppSpacing.md),
                  MenuItemCard(
                    name: 'Indian Spices',
                    rating: 4.0,
                    reviewCount: 15,
                    onTap: () {
                      // TODO: Navigate to dish detail
                    },
                    onReviewsTap: () {
                      // TODO: Show reviews
                    },
                  ),
                ],
              ),
            ),
          ),
          // Stats Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  _StatItem(
                    icon: Icons.photo_outlined,
                    label: 'Posts',
                    value: '${posts.length}',
                  ),
                  SizedBox(width: AppSpacing.lg),
                  _StatItem(
                    icon: Icons.star_outline,
                    label: 'Note',
                    value: restaurant.rating.toStringAsFixed(1),
                  ),
                  SizedBox(width: AppSpacing.lg),
                  _StatItem(
                    icon: Icons.message_outlined,
                    label: 'Avis',
                    value: '${restaurant.reviewCount}',
                  ),
                ],
              ),
            ),
          ),
          // Posts Grid Section
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Publications', style: AppTextStyles.heading3),
                  SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
          if (posts.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.photo_library_outlined,
                      size: 64,
                      color: AppColors.textLight,
                    ),
                    SizedBox(height: AppSpacing.md),
                    Text('Aucune publication', style: AppTextStyles.heading4),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      'Les posts de ce restaurant apparaîtront ici',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.only(bottom: AppSpacing.xl),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: AppSpacing.sm,
                  mainAxisSpacing: AppSpacing.sm,
                  childAspectRatio: 1,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final post = posts[index];
                  return PostThumbnail(
                    post: post,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PostDetailScreen(postId: post.id),
                        ),
                      );
                    },
                  );
                }, childCount: posts.length),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: AppSizes.iconLg, color: AppColors.primary),
          SizedBox(height: AppSpacing.xs),
          Text(value, style: AppTextStyles.heading4),
          SizedBox(height: AppSpacing.xs / 2),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
