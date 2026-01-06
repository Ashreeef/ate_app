import 'package:equatable/equatable.dart';
import '../../models/restaurant.dart';
import '../../models/dish.dart';
import '../../models/post.dart';

/// Base class for all restaurant states
abstract class RestaurantState extends Equatable {
  const RestaurantState();

  @override
  List<Object?> get props => [];
}

/// Initial state before restaurant is loaded
class RestaurantInitial extends RestaurantState {
  const RestaurantInitial();
}

/// State while restaurant details are loading
class RestaurantLoading extends RestaurantState {
  const RestaurantLoading();
}

class RestaurantLoaded extends RestaurantState {
  final Restaurant restaurant;
  final List<Dish> dishes;
  final List<Post> mentions;

  RestaurantLoaded({
    required this.restaurant,
    required this.dishes,
    required this.mentions,
  });

  @override
  List<Object?> get props => [restaurant, dishes, mentions];
}

/// State when loading restaurant fails
class RestaurantError extends RestaurantState {
  final String message;

  const RestaurantError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// State while converting user to restaurant
class RestaurantConversionLoading extends RestaurantState {
  const RestaurantConversionLoading();
}

/// State when conversion succeeds
class RestaurantConversionSuccess extends RestaurantState {
  final String restaurantId;

  const RestaurantConversionSuccess({required this.restaurantId});

  @override
  List<Object?> get props => [restaurantId];
}

/// State when conversion fails
class RestaurantConversionError extends RestaurantState {
  final String message;

  const RestaurantConversionError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// State while updating restaurant details
class RestaurantUpdateLoading extends RestaurantState {
  const RestaurantUpdateLoading();
}

/// State when update succeeds
class RestaurantUpdateSuccess extends RestaurantState {
  const RestaurantUpdateSuccess();
}

/// State when update fails
class RestaurantUpdateError extends RestaurantState {
  final String message;

  const RestaurantUpdateError(this.message);

  @override
  List<Object?> get props => [message];
}
