import 'package:equatable/equatable.dart';
import '../../models/restaurant.dart';

/// Base class for all search states
abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

/// Initial state before anything is loaded
class SearchInitial extends SearchState {
  const SearchInitial();
}

/// State while loading search data (overview or results)
class SearchLoading extends SearchState {
  const SearchLoading();
}

/// State when search overview (trending + recent searches) is loaded
class SearchOverviewLoaded extends SearchState {
  final List<String> recentSearches;
  final List<Restaurant> trendingRestaurants;

  const SearchOverviewLoaded({
    required this.recentSearches,
    required this.trendingRestaurants,
  });

  @override
  List<Object?> get props => [recentSearches, trendingRestaurants];
}

/// State when search results are loaded
class SearchResultsLoaded extends SearchState {
  final String query;
  final List<Restaurant> results;

  const SearchResultsLoaded({
    required this.query,
    required this.results,
  });

  @override
  List<Object?> get props => [query, results];
}

/// State when a search-related error occurs
class SearchError extends SearchState {
  final String message;

  const SearchError({required this.message});

  @override
  List<Object?> get props => [message];
}


