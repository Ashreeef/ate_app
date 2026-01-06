import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/restaurant_repository.dart';
import '../../repositories/post_repository.dart';
import '../../services/restaurant_conversion_service.dart';
import '../../models/dish.dart';
import '../../models/post.dart';
import '../../services/error_service.dart';
import 'restaurant_event.dart';
import 'restaurant_state.dart';

/// Bloc for handling restaurant details loading and conversion
class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final RestaurantRepository _restaurantRepository;
  final PostRepository _postRepository;
  final RestaurantConversionService? _conversionService;

  RestaurantBloc({
    required RestaurantRepository restaurantRepository,
    required PostRepository postRepository,
    RestaurantConversionService? conversionService,
  })  : _restaurantRepository = restaurantRepository,
        _postRepository = postRepository,
        _conversionService = conversionService,
        super(const RestaurantInitial()) {
    on<LoadRestaurantDetails>(_onLoadRestaurantDetails);
    on<ConvertToRestaurantEvent>(_onConvertToRestaurant);
    on<UpdateRestaurantDetails>(_onUpdateRestaurantDetails);
    on<AddDishEvent>(_onAddDish);
    on<UpdateDishEvent>(_onUpdateDish);
    on<DeleteDishEvent>(_onDeleteDish);
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
    } catch (e, stackTrace) {
      ErrorService().logError(
        e,
        stackTrace,
        context: 'RestaurantBloc._onLoadRestaurantDetails',
      );
      emit(
        RestaurantError(
          message: 'Failed to load restaurant details: ${e.toString()}',
        ),
      );
    }
  }

  /// Convert user to restaurant account
  Future<void> _onConvertToRestaurant(
    ConvertToRestaurantEvent event,
    Emitter<RestaurantState> emit,
  ) async {
    if (_conversionService == null) {
      emit(
        const RestaurantConversionError(
          message: 'Conversion service not available',
        ),
      );
      return;
    }

    emit(const RestaurantConversionLoading());

    try {
      final restaurantId = await _conversionService.convertUserToRestaurant(
        userId: event.userId,
        restaurantName: event.restaurantName,
        cuisineType: event.cuisineType,
        location: event.location,
        hours: event.hours,
        description: event.description,
        imageUrl: event.imageUrl,
      );

      emit(RestaurantConversionSuccess(restaurantId: restaurantId));
    } catch (e, stackTrace) {
      ErrorService().logError(
        e,
        stackTrace,
        context: 'RestaurantBloc._onConvertToRestaurant',
      );
      emit(
        RestaurantConversionError(
          message: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  /// Update restaurant details
  Future<void> _onUpdateRestaurantDetails(
    UpdateRestaurantDetails event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(const RestaurantUpdateLoading());

    try {
      // Get current restaurant data to update fields
      final currentRestaurant = await _restaurantRepository.getRestaurantById(
        event.restaurantId,
      );

      if (currentRestaurant == null) {
        emit(const RestaurantUpdateError('Restaurant not found'));
        return;
      }

      final updatedRestaurant = currentRestaurant.copyWith(
        name: event.name,
        searchName: event.name.toLowerCase(),
        cuisineType: event.cuisineType,
        location: event.location,
        hours: event.hours,
        description: event.description,
        imageUrl: event.imageUrl,
      );

      await _restaurantRepository.updateRestaurant(updatedRestaurant);
      
      emit(const RestaurantUpdateSuccess());
      
      // Reload details to refresh UI if needed
      add(LoadRestaurantDetails(
        restaurantId: event.restaurantId,
        loadDishes: true,
        loadMentions: true,
      ));
    } catch (e) {
      emit(RestaurantUpdateError(e.toString()));
    }
  }

  Future<void> _onAddDish(
    AddDishEvent event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(const DishActionLoading());
    try {
      await _restaurantRepository.addDish(event.dish);
      emit(const DishActionSuccess('Dish added successfully'));
      // Refresh list
      add(LoadRestaurantDetails(
        restaurantId: event.dish.restaurantId,
        loadDishes: true,
        loadMentions: false,
      ));
    } catch (e) {
      emit(DishActionError(e.toString()));
    }
  }

  Future<void> _onUpdateDish(
    UpdateDishEvent event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(const DishActionLoading());
    try {
      await _restaurantRepository.updateDish(event.dish);
      emit(const DishActionSuccess('Dish updated successfully'));
      // Refresh list
      add(LoadRestaurantDetails(
        restaurantId: event.dish.restaurantId,
        loadDishes: true,
        loadMentions: false,
      ));
    } catch (e) {
      emit(DishActionError(e.toString()));
    }
  }

  Future<void> _onDeleteDish(
    DeleteDishEvent event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(const DishActionLoading());
    try {
      await _restaurantRepository.deleteDish(
        event.restaurantId,
        event.dishId,
      );
      emit(const DishActionSuccess('Dish deleted successfully'));
      // Refresh list
      add(LoadRestaurantDetails(
        restaurantId: event.restaurantId,
        loadDishes: true,
        loadMentions: false,
      ));
    } catch (e) {
      emit(DishActionError(e.toString()));
    }
  }
}
