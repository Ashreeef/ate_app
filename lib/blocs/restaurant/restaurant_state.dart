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
