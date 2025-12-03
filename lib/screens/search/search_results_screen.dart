import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/constants.dart';
import '../../widgets/restaurant/restaurant_card.dart';
import '../../models/restaurant.dart';
import '../restaurant/restaurant_page.dart';
import '../../blocs/search/search_bloc.dart';
import '../../blocs/search/search_event.dart';
import '../../blocs/search/search_state.dart';

class SearchResultsScreen extends StatelessWidget {
  final String searchQuery;
  final bool showAll;

  const SearchResultsScreen({
    super.key,
    required this.searchQuery,
    this.showAll = false,
  });

  @override
  Widget build(BuildContext context) {
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
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (showAll && state is! SearchResultsLoaded) {
            context
                .read<SearchBloc>()
                .add(const SearchRestaurantsRequested(query: ''));
          } else if (!showAll &&
              state is! SearchResultsLoaded &&
              searchQuery.isNotEmpty) {
            context
                .read<SearchBloc>()
                .add(SearchRestaurantsRequested(query: searchQuery));
          }

          if (state is SearchLoading || state is SearchInitial) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is SearchError) {
            return Center(
              child: Text(
                state.message,
                style: AppTextStyles.bodyMedium,
              ),
            );
          }

          if (state is SearchResultsLoaded) {
            final results = state.results;

            if (results.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off,
                        size: 64, color: AppColors.textLight),
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
              );
            }

            return ListView.builder(
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
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off,
                    size: 64, color: AppColors.textLight),
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
          );
        },
      ),
    );
  }
}
