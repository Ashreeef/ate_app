import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/restaurant/restaurant_bloc.dart';
import '../../blocs/restaurant/restaurant_event.dart';
import '../../blocs/restaurant/restaurant_state.dart';
import '../../models/user.dart';
import '../../utils/constants.dart';
import '../../l10n/app_localizations.dart';
import 'restaurant_page.dart';

class RestaurantConversionScreen extends StatefulWidget {
  final User user;

  const RestaurantConversionScreen({super.key, required this.user});

  @override
  State<RestaurantConversionScreen> createState() =>
      _RestaurantConversionScreenState();
}

class _RestaurantConversionScreenState
    extends State<RestaurantConversionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _restaurantNameController = TextEditingController();
  final _cuisineController = TextEditingController();
  final _locationController = TextEditingController();
  final _hoursController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _restaurantNameController.dispose();
    _cuisineController.dispose();
    _locationController.dispose();
    _hoursController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showConfirmationDialog() {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.confirmConversion ?? 'Confirm Conversion'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.conversionWarning ??
                  'This action cannot be undone. Once you convert to a restaurant account, you will not be able to revert back to a regular user account.',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.doYouWantToContinue ?? 'Do you want to continue?',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel ?? 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _submitConversion();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: Text(l10n.confirm ?? 'Confirm'),
          ),
        ],
      ),
    );
  }

  void submit() {
    if (_formKey.currentState!.validate()) {
      _showConfirmationDialog();
    }
  }

  void _submitConversion() {
    if (widget.user.uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)?.errorOccurred ?? 'User ID not found',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<RestaurantBloc>().add(
          ConvertToRestaurantEvent(
            userId: widget.user.uid!,
            restaurantName: _restaurantNameController.text.trim(),
            cuisineType: _cuisineController.text.trim(),
            location: _locationController.text.trim(),
            hours: _hoursController.text.trim().isEmpty
                ? null
                : _hoursController.text.trim(),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.convertToRestaurant ?? 'Convert to Restaurant'),
        centerTitle: true,
      ),
      body: BlocListener<RestaurantBloc, RestaurantState>(
        listener: (context, state) {
          if (state is RestaurantConversionSuccess) {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  l10n.conversionSuccessful ??
                      'Successfully converted to restaurant account!',
                ),
                backgroundColor: Colors.green,
              ),
            );

            // Navigate to restaurant page
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => RestaurantPage(
                  restaurantId: state.restaurantId,
                ),
              ),
            );
          } else if (state is RestaurantConversionError) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        },
        child: BlocBuilder<RestaurantBloc, RestaurantState>(
          builder: (context, state) {
            final isLoading = state is RestaurantConversionLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Icon(
                      Icons.store,
                      size: 80,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      l10n.becomeARestaurant ?? 'Become a Restaurant',
                      style: AppTextStyles.heading2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.fillInRestaurantDetails ??
                          'Fill in your restaurant details below',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Restaurant Name
                    TextFormField(
                      controller: _restaurantNameController,
                      decoration: InputDecoration(
                        labelText:
                            l10n.restaurantName ?? 'Restaurant Name *',
                        hintText: l10n.enterRestaurantName ??
                            'Enter restaurant name',
                        prefixIcon: const Icon(Icons.restaurant),
                        border: const OutlineInputBorder(),
                      ),
                      enabled: !isLoading,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.restaurantNameRequired ??
                              'Restaurant name is required';
                        }
                        if (value.trim().length < 3) {
                          return l10n.restaurantNameTooShort ??
                              'Restaurant name must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Cuisine Type
                    TextFormField(
                      controller: _cuisineController,
                      decoration: InputDecoration(
                        labelText: l10n.cuisineType ?? 'Cuisine Type *',
                        hintText: l10n.enterCuisineType ??
                            'e.g., Italian, Chinese, French',
                        prefixIcon: const Icon(Icons.fastfood),
                        border: const OutlineInputBorder(),
                      ),
                      enabled: !isLoading,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.cuisineTypeRequired ??
                              'Cuisine type is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Location
                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: l10n.location ?? 'Location *',
                        hintText: l10n.enterLocation ??
                            'Enter restaurant location',
                        prefixIcon: const Icon(Icons.location_on),
                        border: const OutlineInputBorder(),
                      ),
                      enabled: !isLoading,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.locationRequired ??
                              'Location is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Hours (Optional)
                    TextFormField(
                      controller: _hoursController,
                      decoration: InputDecoration(
                        labelText: l10n.hours ?? 'Hours (Optional)',
                        hintText: l10n.enterHours ??
                            'e.g., Mon-Fri: 9AM-10PM',
                        prefixIcon: const Icon(Icons.access_time),
                        border: const OutlineInputBorder(),
                      ),
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Description (Optional)
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: l10n.description ?? 'Description (Optional)',
                        hintText: l10n.enterDescription ??
                            'Tell us about your restaurant',
                        prefixIcon: const Icon(Icons.description),
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 4,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Warning Box
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        border: Border.all(color: Colors.orange),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.orange.shade700,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              l10n.conversionWarning ??
                                  'This action cannot be undone!',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.orange.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Submit Button
                    ElevatedButton(
                      onPressed: isLoading ? null : _submitConversion,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                        backgroundColor: AppColors.primary,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              l10n.convertNow ?? 'Convert Now',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
