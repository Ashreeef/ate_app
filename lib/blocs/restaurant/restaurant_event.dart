import 'package:equatable/equatable.dart';

/// Base class for all restaurant events
abstract class RestaurantEvent extends Equatable {
  const RestaurantEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load a single restaurant by ID
class LoadRestaurantById extends RestaurantEvent {
  final String restaurantId;

  const LoadRestaurantById({required this.restaurantId});

  @override
  List<Object?> get props => [restaurantId];
}


