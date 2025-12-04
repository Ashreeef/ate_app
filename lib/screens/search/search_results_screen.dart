import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/constants.dart';
import '../../widgets/restaurant/restaurant_card.dart';
import '../restaurant/restaurant_page.dart';
import '../../blocs/search/search_bloc.dart';
import '../../blocs/search/search_event.dart';
import '../../blocs/search/search_state.dart';
import '../../l10n/app_localizations.dart';

class SearchResultsScreen extends StatefulWidget {
  final String searchQuery;
  final bool showAll;

  const SearchResultsScreen({
    super.key,
    required this.searchQuery,
    this.showAll = false,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.showAll) {
      context.read<SearchBloc>().add(
        const SearchRestaurantsRequested(query: ''),
      );
    } else if (widget.searchQuery.isNotEmpty) {
      context.read<SearchBloc>().add(
        SearchRestaurantsRequested(query: widget.searchQuery),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.showAll
              ? l10n.allRestaurants
              : widget.searchQuery.isEmpty
              ? l10n.results
              : l10n.resultsFor(widget.searchQuery),
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchLoading || state is SearchInitial) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is SearchError) {
            return Center(
              child: Text(state.message, style: AppTextStyles.bodyMedium),
            );
          }

          if (state is SearchResultsLoaded) {
            final results = state.results;

            if (results.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 64,
                      color: AppColors.textLight,
                    ),
                    SizedBox(height: AppSpacing.md),
                    Text(
                      widget.showAll
                          ? l10n.noRestaurantsAvailable
                          : l10n.noResultsFound,
                      style: AppTextStyles.heading4,
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      widget.showAll ? '' : l10n.tryOtherKeywords,
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
                Icon(Icons.search_off, size: 64, color: AppColors.textLight),
                SizedBox(height: AppSpacing.md),
                Text(
                  widget.showAll
                      ? AppLocalizations.of(context)!.noRestaurantsAvailable
                      : AppLocalizations.of(context)!.noResultsFound,
                  style: AppTextStyles.heading4,
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  widget.showAll
                      ? ''
                      : AppLocalizations.of(context)!.tryOtherKeywords,
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
