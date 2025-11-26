import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/restaurant/restaurant_card.dart';
import '../../data/fake_restaurants.dart';
import '../../models/restaurant.dart';
import '../restaurant/restaurant_page.dart';

class SearchResultsScreen extends StatelessWidget {
  final String searchQuery;
  final bool showAll;

  const SearchResultsScreen({
    Key? key,
    required this.searchQuery,
    this.showAll = false,
  }) : super(key: key);

  List<Restaurant> _getResults() {
    if (showAll) {
      return FakeData.getRestaurants();
    }
    if (searchQuery.isEmpty) {
      return [];
    }
    return FakeData.searchRestaurants(searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    final results = _getResults();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          showAll
              ? 'Tous les restaurants'
              : searchQuery.isEmpty
              ? 'Résultats'
              : 'Résultats pour "$searchQuery"',
        ),
      ),
      body: results.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: AppColors.textLight),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    showAll
                        ? 'Aucun restaurant disponible'
                        : 'Aucun résultat trouvé',
                    style: AppTextStyles.heading4,
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    showAll ? '' : 'Essayez avec d\'autres mots-clés',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(AppSpacing.md),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final restaurant = results[index];
                return RestaurantCard(
                  restaurant: restaurant,
                  onTap: () {
                    if (restaurant.id != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RestaurantPage(restaurantId: restaurant.id!),
                        ),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}
