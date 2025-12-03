import 'package:equatable/equatable.dart';
import '../../models/restaurant.dart';

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

/// State when restaurant details are loaded successfully
class RestaurantLoaded extends RestaurantState {
  final Restaurant restaurant;

  const RestaurantLoaded({required this.restaurant});

  @override
  List<Object?> get props => [restaurant];
}

/// State when loading restaurant fails
class RestaurantError extends RestaurantState {
  final String message;

  const RestaurantError({required this.message});

  @override
  List<Object?> get props => [message];
}


