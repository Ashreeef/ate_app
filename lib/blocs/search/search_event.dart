import 'package:equatable/equatable.dart';

/// Base class for all search events
abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load initial search data (trending restaurants, recent searches)
class LoadSearchOverview extends SearchEvent {
  final String userId;

  const LoadSearchOverview({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Event to perform a restaurant search
class SearchRestaurantsRequested extends SearchEvent {
  final String query;

  const SearchRestaurantsRequested({required this.query});

  @override
  List<Object?> get props => [query];
}

/// Event to remove a single recent search entry from UI/history
class RemoveRecentSearchEntry extends SearchEvent {
  final String query;
  final String userId;

  const RemoveRecentSearchEntry({
    required this.query,
    required this.userId,
  });

  @override
  List<Object?> get props => [query, userId];
}


