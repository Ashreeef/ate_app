import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/constants.dart';
import '../../widgets/restaurant/restaurant_header.dart';
import '../../widgets/restaurant/menu_item_card.dart';
import '../../blocs/restaurant/restaurant_bloc.dart';
import '../../blocs/restaurant/restaurant_event.dart';
import '../../blocs/restaurant/restaurant_state.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/restaurant_repository.dart';
import '../../repositories/post_repository.dart';
import 'restaurant_posts_screen.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import 'edit_restaurant_screen.dart';
import 'manage_menu_screen.dart';
import 'add_review_screen.dart';
import '../../widgets/review/review_list_widget.dart';

class RestaurantPage extends StatefulWidget {
  final String restaurantId;

  const RestaurantPage({super.key, required this.restaurantId});

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  late RestaurantBloc _restaurantBloc;

  @override
  void initState() {
    super.initState();
    _restaurantBloc = RestaurantBloc(
      restaurantRepository: context.read<RestaurantRepository>(),
      postRepository: context.read<PostRepository>(),
    )..add(LoadRestaurantDetails(restaurantId: widget.restaurantId));
  }

  @override
  void dispose() {
    _restaurantBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider.value(
      value: _restaurantBloc,
      child: BlocBuilder<RestaurantBloc, RestaurantState>(
        builder: (context, state) {
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
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  restaurant.name,
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                ),
                actions: [
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, authState) {
                      if (authState is Authenticated &&
                          authState.user.restaurantId == restaurant.id) {
                        return Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.menu_book),
                                  tooltip: l10n.manageMenu,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ManageMenuScreen(
                                        restaurantId: restaurant.id!),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              tooltip: l10n.editRestaurant,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EditRestaurantScreen(restaurant: restaurant),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
              body: CustomScrollView(
                slivers: [
                  // Header
                  SliverToBoxAdapter(
                    child: RestaurantHeader(
                      restaurant: restaurant,
                      onMentionsTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RestaurantPostsScreen(
                              restaurantId: widget.restaurantId,
                              restaurantName: restaurant.name,
                            ),
                          ),
                        );
                      },
                    ),
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
                          if (state.dishes.isEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: AppSpacing.lg,
                              ),
                              child: Center(
                                child: Text(
                                  l10n.noDishes,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textLight,
                                  ),
                                ),
                              ),
                            )
                          else
                            ...state.dishes.map(
                              (dish) => MenuItemCard(
                                name: dish.name,
                                imageUrl: dish.imageUrl,
                                rating: dish.rating,
                                reviewCount:
                                    0, // TODO: Implement dish review count
                                onTap: () {
                                  // TODO: Navigate to dish detail if needed
                                },
                              ),
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
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RestaurantPostsScreen(
                                      restaurantId: widget.restaurantId,
                                      restaurantName: restaurant.name,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.message_outlined,
                                    size: AppSizes.iconLg,
                                    color: AppColors.primary,
                                  ),
                                  SizedBox(height: AppSpacing.xs),
                                  Text(
                                    '${restaurant.postsCount}',
                                    style: AppTextStyles.heading4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Reviews Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(l10n.reviews, style: AppTextStyles.heading3),
                              TextButton.icon(
                                icon: const Icon(Icons.rate_review),
                                label: Text(l10n.writeReview),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AddReviewScreen(
                                        restaurantId: restaurant.id!,
                                      ),
                                    ),
                                  ).then((result) {
                                    if (result == true) {
                                      // Refresh restaurant details to get updated rating
                                      context.read<RestaurantBloc>().add(
                                          LoadRestaurantDetails(
                                              restaurantId: widget.restaurantId));
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                          ReviewListWidget(restaurantId: restaurant.id!),
                          const SizedBox(height: AppSpacing.xxl), // Bottom padding
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
              child: Text(
                l10n.restaurantNotFound,
                style: AppTextStyles.heading3,
              ),
            ),
          );
        },
      ),
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
