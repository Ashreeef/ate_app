import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/restaurant_repository.dart';
import '../../repositories/search_history_repository.dart';
import '../../services/auth_service.dart';
import 'search_event.dart';
import 'search_state.dart';

/// Bloc for handling search logic (restaurants + history)
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final RestaurantRepository _restaurantRepository;
  final SearchHistoryRepository _searchHistoryRepository;
  final AuthService _authService;

  SearchBloc({
    required RestaurantRepository restaurantRepository,
    required SearchHistoryRepository searchHistoryRepository,
    required AuthService authService,
  })  : _restaurantRepository = restaurantRepository,
        _searchHistoryRepository = searchHistoryRepository,
        _authService = authService,
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
      final trendingRestaurants =
          await _restaurantRepository.getTrendingRestaurants(limit: 10);

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
    if (event.query.trim().isEmpty) {
      emit(const SearchResultsLoaded(query: '', results: []));
      return;
    }

    emit(const SearchLoading());

    try {
      final results =
          await _restaurantRepository.searchRestaurants(event.query.trim());

      // Save search query to history for current user if logged in
      if (_authService.isLoggedIn && _authService.currentUserId != null) {
        await _searchHistoryRepository.addSearchQuery(
          _authService.currentUserId!,
          event.query.trim(),
        );
      }

      emit(
        SearchResultsLoaded(
          query: event.query.trim(),
          results: results,
        ),
      );
    } catch (e) {
      emit(
        SearchError(
          message: 'Failed to perform search: ${e.toString()}',
        ),
      );
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
        final trendingRestaurants =
            await _restaurantRepository.getTrendingRestaurants(limit: 10);

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


