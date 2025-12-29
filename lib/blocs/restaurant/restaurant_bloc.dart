import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/restaurant_repository.dart';
import '../../repositories/post_repository.dart';
import '../../models/dish.dart';
import '../../models/post.dart';
import 'restaurant_event.dart';
import 'restaurant_state.dart';

/// Bloc for handling restaurant details loading
class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final RestaurantRepository _restaurantRepository;
  final PostRepository _postRepository;

  RestaurantBloc({
    required RestaurantRepository restaurantRepository,
    required PostRepository postRepository,
  }) : _restaurantRepository = restaurantRepository,
       _postRepository = postRepository,
       super(const RestaurantInitial()) {
    on<LoadRestaurantDetails>(_onLoadRestaurantDetails);
  }

  /// Load restaurant details by ID
  Future<void> _onLoadRestaurantDetails(
    LoadRestaurantDetails event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(const RestaurantLoading());

    try {
      // Fetch core restaurant data
      final restaurant = await _restaurantRepository.getRestaurantById(
        event.restaurantId,
      );

      if (restaurant == null) {
        emit(const RestaurantError(message: 'Restaurant not found'));
        return;
      }

      // Fetch dishes and mentions if requested
      final results = await Future.wait([
        event.loadDishes
            ? _restaurantRepository.getDishesForRestaurant(event.restaurantId)
            : Future.value(<Dish>[]),
        event.loadMentions
            ? _postRepository.getRestaurantPosts(event.restaurantId)
            : Future.value(<Post>[]),
      ]);

      final dishes = (results[0] as List?)?.cast<Dish>() ?? <Dish>[];
      final mentions = (results[1] as List?)?.cast<Post>() ?? <Post>[];

      emit(
        RestaurantLoaded(
          restaurant: restaurant,
          dishes: dishes,
          mentions: mentions,
        ),
      );
    } catch (e) {
      print('RestaurantBloc Error: $e');
      emit(
        RestaurantError(
          message: 'Failed to load restaurant details: ${e.toString()}',
        ),
      );
    }
  }
}
