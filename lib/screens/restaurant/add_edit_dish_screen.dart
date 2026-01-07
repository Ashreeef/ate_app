import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/constants.dart';
import '../../l10n/app_localizations.dart';
import '../../blocs/restaurant/restaurant_bloc.dart';
import '../../blocs/restaurant/restaurant_event.dart';
import '../../blocs/restaurant/restaurant_state.dart';
import '../../models/dish.dart';
import '../../services/cloudinary_storage_service.dart';

class AddEditDishScreen extends StatefulWidget {
  final String restaurantId;
  final Dish? dish; // If null, we are adding a new dish

  const AddEditDishScreen({
    super.key,
    required this.restaurantId,
    this.dish,
  });

  @override
  State<AddEditDishScreen> createState() => _AddEditDishScreenState();
}

class _AddEditDishScreenState extends State<AddEditDishScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _categoryController;
  
  File? _imageFile;
  String? _currentImageUrl;
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.dish?.name ?? '');
    _descriptionController = TextEditingController(text: widget.dish?.description ?? '');
    _priceController = TextEditingController(text: widget.dish?.price?.toString() ?? '');
    _categoryController = TextEditingController(text: widget.dish?.category ?? '');
    _currentImageUrl = widget.dish?.imageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
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

    String? imageUrl = _currentImageUrl;

    // Handle image upload if new image selected
    if (_imageFile != null) {
      setState(() => _isUploadingImage = true);
      try {
        final storageService = CloudinaryStorageService();
        // We reuse uploadRestaurantImage or create a new one for dishes.
        // Assuming we can use a generic upload or similar path structure.
        // For simplicity, using uploadRestaurantImage logic but maybe passing a flag?
        // Actually Cloudinary service usually takes file and folder/publicId.
        // Let's check CloudinaryService later. For now assume uploadDishImage exists or I use generic.
        // I'll assume uploadDishImage needs to be added or use generic.
        // I'll check CloudinaryStorageService later. If it lacks Dish support, I might break compliance if I don't fix it.
        // Let's assume I need to add `uploadDishImage` to `CloudinaryStorageService`.
        // I will do that in valid step. For now generating call assuming it exists.
        
        // Wait, I should not assume. I will check `CloudinaryStorageService` in next step.
        // For now I will comment out the actual upload call or use a placeholder.
        // NO, I must fix it. I will pause writng this file? No, I will write it assuming methods exist, then fix service.
        
        imageUrl = await storageService.uploadImage(
           _imageFile!,
           folder: 'dishes/${widget.restaurantId}',
        );
      } catch (e) {
        setState(() => _isUploadingImage = false);
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.uploadImageFail(e.toString()))),
          );
        }
        return;
      }
    }

    final dish = Dish(
      id: widget.dish?.id, // Null for new
      restaurantId: widget.restaurantId,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      price: double.tryParse(_priceController.text.trim()),
      category: _categoryController.text.trim().isEmpty ? null : _categoryController.text.trim(),
      imageUrl: imageUrl,
      createdAt: widget.dish?.createdAt, // Preserve creation date if editing
    );

    if (mounted) {
      if (widget.dish == null) {
         context.read<RestaurantBloc>().add(AddDishEvent(dish));
      } else {
         context.read<RestaurantBloc>().add(UpdateDishEvent(dish));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.dish != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? l10n.editDish : l10n.addDish), 
        actions: [
           BlocConsumer<RestaurantBloc, RestaurantState>(
            listener: (context, state) {
              if (state is DishActionSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.success,
                  ),
                );
                Navigator.pop(context);
              } else if (state is DishActionError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is DishActionLoading || _isUploadingImage) {
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
                            Text(l10n.addDishPhoto, style: TextStyle(color: Colors.grey)),
                          ],
                        )
                      : null,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.dishName,
                  border: OutlineInputBorder(),
                ),
                validator: (value) => 
                   value?.isEmpty ?? true ? l10n.fieldRequired : null,
              ),
              const SizedBox(height: AppSpacing.md),

              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: l10n.dishDescription,
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: AppSpacing.md),
              
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: l10n.price,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: AppSpacing.md),
              
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: l10n.category,
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
