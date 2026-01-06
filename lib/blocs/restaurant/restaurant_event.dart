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

/// Event to convert user account to restaurant account
class ConvertToRestaurantEvent extends RestaurantEvent {
  final String userId;
  final String restaurantName;
  final String cuisineType;
  final String location;
  final String? hours;
  final String? description;
  final String? imageUrl;

  const ConvertToRestaurantEvent({
    required this.userId,
    required this.restaurantName,
    required this.cuisineType,
    required this.location,
    this.hours,
    this.description,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
        userId,
        restaurantName,
        cuisineType,
        location,
        hours,
        description,
        imageUrl,
      ];
}

