import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/constants.dart';
import '../../l10n/app_localizations.dart';
import '../../blocs/restaurant/restaurant_bloc.dart';
import '../../blocs/restaurant/restaurant_event.dart';
import '../../blocs/restaurant/restaurant_state.dart';
import '../../models/dish.dart';
import 'add_edit_dish_screen.dart';

class ManageMenuScreen extends StatelessWidget {
  final String restaurantId;

  const ManageMenuScreen({
    super.key,
    required this.restaurantId,
  });

  void _navigateToAddDish(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditDishScreen(restaurantId: restaurantId),
      ),
    );
  }

  void _navigateToEditDish(BuildContext context, Dish dish) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditDishScreen(
          restaurantId: restaurantId,
          dish: dish,
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Dish dish) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteDish),
        content: Text(AppLocalizations.of(context)!.deleteDishConfirm(dish.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<RestaurantBloc>().add(
                    DeleteDishEvent(
                      restaurantId: restaurantId,
                      dishId: dish.id!,
                    ),
                  );
            },
            child: Text(AppLocalizations.of(context)!.delete, style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // We assume RestaurantBloc is provided by the parent (RestaurantPage/NavShell)
    // or we might need to wrap with BlocProvider.value if navigated from outside.
    // RestaurantPage provides it.

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.manageMenu),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _navigateToAddDish(context),
          ),
        ],
      ),
      body: BlocBuilder<RestaurantBloc, RestaurantState>(
        builder: (context, state) {
          if (state is RestaurantLoading) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (state is RestaurantLoaded) {
             final dishes = state.dishes;
             
             if (dishes.isEmpty) {
               return Center(
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Icon(Icons.restaurant_menu, size: 64, color: AppColors.textLight),
                     SizedBox(height: 16),
                      Text(AppLocalizations.of(context)!.menuEmpty, style: AppTextStyles.heading3),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => _navigateToAddDish(context),
                        child: Text(AppLocalizations.of(context)!.addFirstDish),
                      ),
                   ],
                 ),
               );
             }

             return RefreshIndicator(
               onRefresh: () async {
                  context.read<RestaurantBloc>().add(
                    LoadRestaurantDetails(restaurantId: restaurantId),
                  );
               },
               child: ListView.separated(
                 padding: EdgeInsets.all(AppSpacing.md),
                 itemCount: dishes.length,
                 separatorBuilder: (_, __) => SizedBox(height: AppSpacing.sm),
                 itemBuilder: (context, index) {
                   final dish = dishes[index];
                   return Card(
                     child: ListTile(
                       leading: dish.imageUrl != null 
                         ? ClipRRect(
                             borderRadius: BorderRadius.circular(4),
                             child: Image.network(dish.imageUrl!, width: 50, height: 50, fit: BoxFit.cover),
                           )
                         : Container(
                             width: 50, height: 50, 
                             color: Colors.grey[200], 
                             child: Icon(Icons.fastfood, size: 20),
                           ),
                       title: Text(dish.name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                       subtitle: Text(
                         '${dish.price != null ? '\$${dish.price}' : ''} ${dish.category != null ? '• ${dish.category}' : ''}',
                       ),
                       trailing: Row(
                         mainAxisSize: MainAxisSize.min,
                         children: [
                           IconButton(
                             icon: Icon(Icons.edit, color: AppColors.primary),
                             onPressed: () => _navigateToEditDish(context, dish),
                           ),
                           IconButton(
                             icon: Icon(Icons.delete, color: AppColors.textLight),
                             onPressed: () => _confirmDelete(context, dish),
                           ),
                         ],
                       ),
                     ),
                   );
                 },
               ),
             );
          }
          
          return Center(child: Text(AppLocalizations.of(context)!.couldNotLoadMenu));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddDish(context),
        child: Icon(Icons.add),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
