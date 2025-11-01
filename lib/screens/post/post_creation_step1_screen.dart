import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ate_app/utils/constants.dart';
import 'package:ate_app/screens/post/post_creation_step2_screen.dart';

class PostCreationStep1Screen extends StatefulWidget {
  //  GlobalKey so navigation shell can access this screen
  static final GlobalKey<_PostCreationStep1ScreenState> globalKey = GlobalKey();
  
  PostCreationStep1Screen({Key? key}) : super(key: key ?? globalKey); 

  @override
  State<PostCreationStep1Screen> createState() => _PostCreationStep1ScreenState();
}

class _PostCreationStep1ScreenState extends State<PostCreationStep1Screen> {
  final ImagePicker _imagePicker = ImagePicker();
  List<XFile> _selectedImages = [];
  final int _maxImages = 3;

  //  Getter for navigation shell to check if images are selected
  bool get hasSelectedImages => _selectedImages.isNotEmpty;
  
  //  Method for navigation shell to trigger navigation
  void navigateToNextStep() {
    _navigateToStep2();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );
      
      if (image != null && _selectedImages.length < _maxImages) {
        setState(() {
          _selectedImages.add(image);
        });
      } else if (_selectedImages.length >= _maxImages) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vous pouvez sélectionner jusqu\'à $_maxImages images', style: AppTextStyles.body),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Échec de la sélection d\'image: $e', style: AppTextStyles.body),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _navigateToStep2() {
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez sélectionner au moins une image', style: AppTextStyles.body),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostCreationStep2Screen(selectedImages: _selectedImages),
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.borderRadiusLg)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choisir une photo',
                style: AppTextStyles.heading3,
              ),
              SizedBox(height: AppSpacing.md),
              ListTile(
                leading: Icon(Icons.photo_library, color: AppColors.primary, size: AppSizes.iconLg),
                title: Text('Galerie', style: AppTextStyles.body),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.photo_camera, color: AppColors.primary, size: AppSizes.iconLg),
                title: Text('Prendre une photo', style: AppTextStyles.body),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              SizedBox(height: AppSpacing.sm),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // REMOVED AppBar - navigation shell handles it now
      body: Column(
        children: [
          if (_selectedImages.isNotEmpty) _buildSelectedImages(),
          Expanded(
            child: _selectedImages.isEmpty ? _buildEmptyState() : _buildImageGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedImages() {
    return Container(
      height: 100,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedImages.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                margin: EdgeInsets.only(right: AppSpacing.sm),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  border: Border.all(color: AppColors.primary, width: 2),
                  image: DecorationImage(
                    image: FileImage(File(_selectedImages[index].path)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: -4,
                right: AppSpacing.sm - 4,
                child: GestureDetector(
                  onTap: () => _removeImage(index),
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(Icons.close, size: 16, color: AppColors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined, 
              size: 80, 
              color: AppColors.textLight
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              'Ajouter des photos', 
              style: AppTextStyles.heading2.copyWith(color: AppColors.textDark)
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Partagez votre expérience culinaire\navec de belles photos',
              style: AppTextStyles.body.copyWith(color: AppColors.textMedium),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: _showImageSourceDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl, 
                  vertical: AppSpacing.md
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                ),
              ),
              icon: Icon(Icons.add_photo_alternate, color: AppColors.white),
              label: Text('Sélectionner des photos', style: AppTextStyles.button),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(AppSpacing.md),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
      ),
      itemCount: _selectedImages.length < _maxImages ? _selectedImages.length + 1 : _selectedImages.length,
      itemBuilder: (context, index) {
        if (index == _selectedImages.length) {
          return GestureDetector(
            onTap: _showImageSourceDialog,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                border: Border.all(color: AppColors.border, width: 2, style: BorderStyle.solid),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add, 
                    size: AppSizes.iconLg, 
                    color: AppColors.primary
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Ajouter',
                    style: AppTextStyles.caption.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  image: DecorationImage(
                    image: FileImage(File(_selectedImages[index].path)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => _removeImage(index),
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(Icons.close, size: 16, color: AppColors.white),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}