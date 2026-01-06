
/// State while performing action on dish
class DishActionLoading extends RestaurantState {
  const DishActionLoading();
}

/// State when dish action succeeds
class DishActionSuccess extends RestaurantState {
  final String message;

  const DishActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// State when dish action fails
class DishActionError extends RestaurantState {
  final String message;

  const DishActionError(this.message);

  @override
  List<Object?> get props => [message];
}
