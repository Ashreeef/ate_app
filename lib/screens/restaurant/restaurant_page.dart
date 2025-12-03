import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/restaurant/restaurant_header.dart';
import '../../widgets/restaurant/menu_item_card.dart';
import '../../data/fake_restaurants.dart';

class RestaurantPage extends StatelessWidget {
  final int restaurantId;

  const RestaurantPage({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    final restaurant = FakeData.getRestaurantById(restaurantId);

    if (restaurant == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Restaurant')),
        body: Center(
          child: Text('Restaurant non trouvé', style: AppTextStyles.heading3),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          restaurant.name,
          style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
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
                    icon: Icons.star_outline,
                    label: 'Note',
                    value: restaurant.rating.toStringAsFixed(1),
                  ),
                  SizedBox(width: AppSpacing.lg),
                  _StatItem(
                    icon: Icons.message_outlined,
                    label: 'Posts',
                    value: '${restaurant.postsCount}',
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

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

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
