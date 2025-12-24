import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/restaurant_repository.dart';
import 'restaurant_event.dart';
import 'restaurant_state.dart';

/// Bloc for handling restaurant details loading
class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final RestaurantRepository _restaurantRepository;

  RestaurantBloc({
    required RestaurantRepository restaurantRepository,
  })  : _restaurantRepository = restaurantRepository,
        super(const RestaurantInitial()) {
    on<LoadRestaurantById>(_onLoadRestaurantById);
  }

  /// Load restaurant details by ID from repository
  Future<void> _onLoadRestaurantById(
    LoadRestaurantById event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(const RestaurantLoading());

    try {
      final restaurant =
          await _restaurantRepository.getRestaurantById(event.restaurantId);

      if (restaurant != null) {
        emit(RestaurantLoaded(restaurant: restaurant));
      } else {
        emit(const RestaurantError(message: 'Restaurant not found'));
      }
    } catch (e) {
      emit(RestaurantError(message: e.toString()));
    }
  }
}


