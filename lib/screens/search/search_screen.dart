import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/constants.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/restaurant/restaurant_card.dart';
import 'search_results_screen.dart';
import '../restaurant/restaurant_page.dart';
import '../../blocs/search/search_bloc.dart';
import '../../blocs/search/search_event.dart';
import '../../blocs/search/search_state.dart';
import '../../repositories/auth_repository.dart';
import '../../l10n/app_localizations.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final authRepository = context.read<AuthRepository>();
    final currentUserId = authRepository.currentUserId ?? '0';
    context.read<SearchBloc>().add(LoadSearchOverview(userId: currentUserId));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    if (query.trim().isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsScreen(searchQuery: query),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authRepository = context.read<AuthRepository>();
    final currentUserId = authRepository.currentUserId ?? '0';
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  CustomTextField.search(
                    controller: _searchController,
                    hint: l10n.searchRestaurants,
                    onChanged: (value) {},
                    onSubmitted: _handleSearch,
                  ),
                  SizedBox(height: AppSpacing.lg),

                  if (state is SearchLoading) ...[
                    Center(child: CircularProgressIndicator()),
                  ] else if (state is SearchOverviewLoaded) ...[
                    // Trending Nearby Section
                    if (state.trendingRestaurants.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.trendingNearYou,
                            style: AppTextStyles.heading3,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchResultsScreen(
                                    searchQuery: '',
                                    showAll: true,
                                  ),
                                ),
                              );
                            },
                            child: Text(l10n.seeAll, style: AppTextStyles.link),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.md),
                      SizedBox(
                        height: 343,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.trendingRestaurants.length,
                          itemBuilder: (context, index) {
                            final restaurant = state.trendingRestaurants[index];
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              margin: EdgeInsets.only(
                                right:
                                    index < state.trendingRestaurants.length - 1
                                    ? AppSpacing.md
                                    : 0,
                              ),
                              child: RestaurantCard(
                                restaurant: restaurant,
                                onTap: () {
                                  if (restaurant.restaurantId != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RestaurantPage(
                                          restaurantId: restaurant.restaurantId!,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: AppSpacing.xl),
                    ],

                    // Recent Searches Section
                    if (state.recentSearches.isNotEmpty) ...[
                      Text(l10n.recentSearches, style: AppTextStyles.heading3),
                      SizedBox(height: AppSpacing.md),
                      ...state.recentSearches.map((search) {
                        return ListTile(
                          leading: Icon(
                            Icons.history,
                            color: AppColors.textMedium,
                            size: AppSizes.iconSm,
                          ),
                          title: Text(search, style: AppTextStyles.bodyMedium),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.close,
                              size: AppSizes.iconSm,
                              color: AppColors.textMedium,
                            ),
                            onPressed: () {
                              context.read<SearchBloc>().add(
                                RemoveRecentSearchEntry(
                                  query: search,
                                  userId: currentUserId,
                                ),
                              );
                            },
                          ),
                          onTap: () {
                            _searchController.text = search;
                            _handleSearch(search);
                          },
                        );
                      }),
                    ],
                  ] else if (state is SearchError) ...[
                    Center(
                      child: Text(
                        state.message,
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
