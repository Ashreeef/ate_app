import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/restaurant_repository.dart';
import '../../repositories/search_history_repository.dart';
import '../../repositories/auth_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

/// Bloc for handling search logic (restaurants + history)
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final RestaurantRepository _restaurantRepository;
  final SearchHistoryRepository _searchHistoryRepository;
  final AuthRepository _authRepository;

  SearchBloc({
    required RestaurantRepository restaurantRepository,
    required SearchHistoryRepository searchHistoryRepository,
    required AuthRepository authRepository,
  }) : _restaurantRepository = restaurantRepository,
       _searchHistoryRepository = searchHistoryRepository,
       _authRepository = authRepository,
       super(const SearchInitial()) {
    on<LoadSearchOverview>(_onLoadSearchOverview);
    on<SearchRestaurantsRequested>(_onSearchRestaurantsRequested);
    on<RemoveRecentSearchEntry>(_onRemoveRecentSearchEntry);
  }

  /// Load trending restaurants and recent searches
  Future<void> _onLoadSearchOverview(
    LoadSearchOverview event,
    Emitter<SearchState> emit,
  ) async {
    emit(const SearchLoading());

    try {
      final recentSearches = await _searchHistoryRepository
          .getUniqueRecentSearchQueries(event.userId);
      final trendingRestaurants = await _restaurantRepository
          .getTrendingRestaurants(limit: 10);

      emit(
        SearchOverviewLoaded(
          recentSearches: recentSearches,
          trendingRestaurants: trendingRestaurants,
        ),
      );
    } catch (e) {
      emit(SearchError(message: 'Failed to load search data: ${e.toString()}'));
    }
  }

  /// Perform restaurant search and save query to history (if logged in)
  Future<void> _onSearchRestaurantsRequested(
    SearchRestaurantsRequested event,
    Emitter<SearchState> emit,
  ) async {
    final trimmedQuery = event.query.trim();

    if (trimmedQuery.isEmpty) {
      // For "show all" scenario, load all restaurants
      final results = await _restaurantRepository.getAllRestaurants();
      emit(SearchResultsLoaded(query: '', results: results));
      return;
    }

    emit(const SearchLoading());

    try {
      final results = await _restaurantRepository.searchRestaurants(
        trimmedQuery,
      );

      // Save search query to history for current user if logged in
      // Note: Will need to migrate search history to use UID instead of integer ID
      if (_authRepository.isAuthenticated &&
          _authRepository.currentUserId != null) {
        // TODO: Migrate search history to use Firebase UID
        // For now, skip saving search history until migration is complete
      }

      emit(SearchResultsLoaded(query: trimmedQuery, results: results));
    } catch (e) {
      emit(SearchError(message: 'Failed to perform search: ${e.toString()}'));
    }
  }

  /// Remove a recent search entry and refresh overview
  Future<void> _onRemoveRecentSearchEntry(
    RemoveRecentSearchEntry event,
    Emitter<SearchState> emit,
  ) async {
    try {
      await _searchHistoryRepository.deleteSearchQuery(
        event.userId,
        event.query,
      );

      // Reload overview after deletion if current state is overview
      if (state is SearchOverviewLoaded) {
        final recentSearches = await _searchHistoryRepository
            .getUniqueRecentSearchQueries(event.userId);
        final trendingRestaurants = await _restaurantRepository
            .getTrendingRestaurants(limit: 10);

        emit(
          SearchOverviewLoaded(
            recentSearches: recentSearches,
            trendingRestaurants: trendingRestaurants,
          ),
        );
      }
    } catch (e) {
      emit(
        SearchError(
          message: 'Failed to update search history: ${e.toString()}',
        ),
      );
    }
  }
}
