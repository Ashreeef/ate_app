import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/constants.dart';
import '../../l10n/app_localizations.dart';
import '../../blocs/restaurant/restaurant_bloc.dart';
import '../../blocs/restaurant/restaurant_event.dart';
import '../../blocs/restaurant/restaurant_state.dart';
import '../../models/restaurant.dart';
import '../../services/cloudinary_storage_service.dart';

class EditRestaurantScreen extends StatefulWidget {
  final Restaurant restaurant;

  const EditRestaurantScreen({
    super.key,
    required this.restaurant,
  });

  @override
  State<EditRestaurantScreen> createState() => _EditRestaurantScreenState();
}

class _EditRestaurantScreenState extends State<EditRestaurantScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _cuisineController;
  late TextEditingController _locationController;
  late TextEditingController _hoursController;
  late TextEditingController _descriptionController;
  
  File? _imageFile;
  String? _currentImageUrl;
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.restaurant.name);
    _cuisineController = TextEditingController(text: widget.restaurant.cuisineType);
    _locationController = TextEditingController(text: widget.restaurant.location);
    _hoursController = TextEditingController(text: widget.restaurant.hours);
    _descriptionController = TextEditingController(text: widget.restaurant.description);
    _currentImageUrl = widget.restaurant.imageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cuisineController.dispose();
    _locationController.dispose();
    _hoursController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 600,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isUploadingImage) return;

    final l10n = AppLocalizations.of(context)!;

    String? imageUrl = _currentImageUrl;

    // Handle image upload if new image selected
    if (_imageFile != null) {
      setState(() => _isUploadingImage = true);
      try {
        final storageService = CloudinaryStorageService();
        imageUrl = await storageService.uploadRestaurantImage(
          _imageFile!,
          widget.restaurant.id!,
        );
      } catch (e) {
        setState(() => _isUploadingImage = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload image: $e')),
          );
        }
        return;
      }
    }

    if (mounted) {
      context.read<RestaurantBloc>().add(
        UpdateRestaurantDetails(
          restaurantId: widget.restaurant.id!,
          name: _nameController.text.trim(),
          cuisineType: _cuisineController.text.trim(),
          location: _locationController.text.trim(),
          hours: _hoursController.text.trim(),
          description: _descriptionController.text.trim(),
          imageUrl: imageUrl,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editRestaurant), 
        actions: [
          BlocConsumer<RestaurantBloc, RestaurantState>(
            listener: (context, state) {
              if (state is RestaurantUpdateSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.restaurantUpdatedSuccess),
                    backgroundColor: AppColors.success,
                  ),
                );
                Navigator.pop(context);
              } else if (state is RestaurantUpdateError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is RestaurantUpdateLoading || _isUploadingImage) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              }
              return IconButton(
                onPressed: _submitForm,
                icon: const Icon(Icons.check),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                    image: _imageFile != null
                        ? DecorationImage(
                            image: FileImage(_imageFile!),
                            fit: BoxFit.cover,
                          )
                        : (_currentImageUrl != null
                            ? DecorationImage(
                                image: NetworkImage(_currentImageUrl!),
                                fit: BoxFit.cover,
                              )
                            : null),
                  ),
                  child: (_imageFile == null && _currentImageUrl == null)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                            SizedBox(height: 8),
                            Text(l10n.addCoverPhoto, style: TextStyle(color: Colors.grey)),
                          ],
                        )
                      : null,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Fields
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.restaurantName,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.store),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? l10n.fieldRequired : null,
              ),
              const SizedBox(height: AppSpacing.md),

              TextFormField(
                controller: _cuisineController,
                decoration: InputDecoration(
                  labelText: l10n.cuisineType,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.restaurant_menu),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? l10n.fieldRequired : null,
              ),
              const SizedBox(height: AppSpacing.md),

              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: l10n.location,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? l10n.fieldRequired : null,
              ),
              const SizedBox(height: AppSpacing.md),

              TextFormField(
                controller: _hoursController,
                decoration: InputDecoration(
                  labelText: l10n.openingHours,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: l10n.description,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
