import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/constants.dart';
import '../../widgets/restaurant/restaurant_header.dart';
import '../../widgets/restaurant/menu_item_card.dart';
import '../../blocs/restaurant/restaurant_bloc.dart';
import '../../blocs/restaurant/restaurant_event.dart';
import '../../blocs/restaurant/restaurant_state.dart';
import '../../l10n/app_localizations.dart';

class RestaurantPage extends StatelessWidget {
  final int restaurantId;

  const RestaurantPage({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<RestaurantBloc, RestaurantState>(
      builder: (context, state) {
        if (state is RestaurantInitial) {
          context.read<RestaurantBloc>().add(
            LoadRestaurantById(restaurantId: restaurantId),
          );
        }

        if (state is RestaurantLoading || state is RestaurantInitial) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.restaurant)),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is RestaurantError) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.restaurant)),
            body: Center(
              child: Text(state.message, style: AppTextStyles.heading3),
            ),
          );
        }

        if (state is RestaurantLoaded) {
          final restaurant = state.restaurant;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.white,
              elevation: 0,
              centerTitle: true,
              title: Text(
                restaurant.name,
                style: AppTextStyles.heading3.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            body: CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: RestaurantHeader(restaurant: restaurant),
                ),
                // Menu Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: AppSpacing.lg),
                        Text(l10n.menu, style: AppTextStyles.heading3),
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
                          label: l10n.rating,
                          value: restaurant.rating.toStringAsFixed(1),
                        ),
                        SizedBox(width: AppSpacing.lg),
                        _StatItem(
                          icon: Icons.message_outlined,
                          label: l10n.posts,
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

        return Scaffold(
          appBar: AppBar(title: Text(l10n.restaurant)),
          body: Center(
            child: Text(l10n.restaurantNotFound, style: AppTextStyles.heading3),
          ),
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
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
