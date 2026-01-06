
import '../../models/dish.dart';

class AddDishEvent extends RestaurantEvent {
  final Dish dish;

  const AddDishEvent(this.dish);

  @override
  List<Object?> get props => [dish];
}

class UpdateDishEvent extends RestaurantEvent {
  final Dish dish;

  const UpdateDishEvent(this.dish);

  @override
  List<Object?> get props => [dish];
}

class DeleteDishEvent extends RestaurantEvent {
  final String restaurantId;
  final String dishId;

  const DeleteDishEvent({required this.restaurantId, required this.dishId});

  @override
  List<Object?> get props => [restaurantId, dishId];
}
