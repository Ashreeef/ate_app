import 'package:equatable/equatable.dart';

/// Base class for all restaurant events
abstract class RestaurantEvent extends Equatable {
  const RestaurantEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all restaurant details (info, dishes, mentions)
class LoadRestaurantDetails extends RestaurantEvent {
  final String restaurantId;
  final bool loadDishes;
  final bool loadMentions;

  const LoadRestaurantDetails({
    required this.restaurantId,
    this.loadDishes = true,
    this.loadMentions = true,
  });

  @override
  List<Object?> get props => [restaurantId, loadDishes, loadMentions];
}


