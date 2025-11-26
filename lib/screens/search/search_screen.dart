import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/restaurant/restaurant_card.dart';
import '../../data/fake_restaurants.dart';
import '../../models/restaurant.dart';
import 'search_results_screen.dart';
import '../restaurant/restaurant_page.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<String> _recentSearches;
  late List<Restaurant> _trendingRestaurants;

  @override
  void initState() {
    super.initState();
    try {
      _recentSearches = FakeData.getRecentSearches();
      _trendingRestaurants = FakeData.getTrendingRestaurants();
    } catch (e) {
      _recentSearches = [];
      _trendingRestaurants = [];
    }
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              CustomTextField.search(
                controller: _searchController,
                hint: 'Rechercher des restaurants...',
                onChanged: (value) {},
                onSubmitted: _handleSearch,
              ),
              SizedBox(height: AppSpacing.lg),

              // Trending Nearby Section
              if (_trendingRestaurants.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tendances près de vous',
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
                      child: Text('Voir tout', style: AppTextStyles.link),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 343,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _trendingRestaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = _trendingRestaurants[index];
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        margin: EdgeInsets.only(
                          right: index < _trendingRestaurants.length - 1
                              ? AppSpacing.md
                              : 0,
                        ),
                        child: RestaurantCard(
                          restaurant: restaurant,
                          onTap: () {
                            if (restaurant.id != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RestaurantPage(
                                    restaurantId: restaurant.id!,
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
              if (_recentSearches.isNotEmpty) ...[
                Text('Recherches récentes', style: AppTextStyles.heading3),
                SizedBox(height: AppSpacing.md),
                ..._recentSearches.map((search) {
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
                        setState(() {
                          _recentSearches.remove(search);
                        });
                      },
                    ),
                    onTap: () {
                      _searchController.text = search;
                      _handleSearch(search);
                    },
                  );
                }),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
