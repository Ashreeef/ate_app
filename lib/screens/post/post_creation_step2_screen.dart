import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ate_app/utils/constants.dart';
import '../../utils/image_utils.dart';
import '../../blocs/post/post_bloc.dart';
import '../../blocs/post/post_event.dart';
import '../../blocs/post/post_state.dart';
import '../../models/post.dart';

class PostCreationStep2Screen extends StatefulWidget {
  final List<XFile> selectedImages;

  const PostCreationStep2Screen({super.key, required this.selectedImages});

  @override
  State<PostCreationStep2Screen> createState() =>
      _PostCreationStep2ScreenState();
}

class _PostCreationStep2ScreenState extends State<PostCreationStep2Screen> {
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _dishNameController = TextEditingController();
  final TextEditingController _restaurantController = TextEditingController();
  double _rating = 0;
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();
  bool _isSubmitting = false;

  Future<void> _publishPost() async {
    if (_captionController.text.isEmpty) {
      _showErrorSnackBar('Veuillez écrire une légende');
      return;
    }

    if (_restaurantController.text.isEmpty) {
      _showErrorSnackBar('Veuillez saisir un restaurant');
      return;
    }

    if (_rating == 0) {
      _showErrorSnackBar('Veuillez évaluer votre expérience');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Compress and save images
      List<String> compressedImagePaths = [];
      for (var xfile in widget.selectedImages) {
        final file = File(xfile.path);
        final compressed = await ImageUtils.compressAndGetFile(
          file,
          quality: 65,
        );
        compressedImagePaths.add(compressed.path);
      }

      // Create post object
      final post = Post(
        userId: 1, // TODO: Get from AuthService.instance.currentUserId!
        username: 'Sondes', // TODO: Get from UserBloc or UserRepository
        caption: _captionController.text,
        restaurantId: null,
        restaurantName: _restaurantController.text,
        dishName: _dishNameController.text.isNotEmpty
            ? _dishNameController.text
            : null,
        rating: _rating,
        images: compressedImagePaths,
        userAvatarPath: null,
      );

      // Emit create post event
      context.read<PostBloc>().add(CreatePostEvent(post));

      _showSuccessSnackBar('Post publié avec succès!');
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } catch (e) {
      _showErrorSnackBar('Erreur lors de la publication: $e');
      setState(() => _isSubmitting = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppTextStyles.body),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppTextStyles.body),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _captionController.dispose();
    _dishNameController.dispose();
    _restaurantController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state is PostSuccess) {
          _showSuccessSnackBar('Post publié avec succès!');
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        } else if (state is PostFailure) {
          _showErrorSnackBar('Erreur: ${state.message}');
          setState(() => _isSubmitting = false);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('Nouveau post', style: AppTextStyles.heading3),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).iconTheme.color,
              size: AppSizes.icon,
            ),
            onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          ),
          actions: [
            TextButton(
              onPressed: _isSubmitting ? null : _publishPost,
              child: Text(
                'Publier',
                style: AppTextStyles.link.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildImageCarousel(),
              SizedBox(height: AppSpacing.lg),
              _buildCaptionInput(),
              SizedBox(height: AppSpacing.lg),
              _buildRestaurantInput(),
              SizedBox(height: AppSpacing.lg),
              _buildDishNameInput(),
              SizedBox(height: AppSpacing.lg),
              _buildRatingInput(),
              SizedBox(height: AppSpacing.xl * 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Container(
      height: 320,
      color: AppColors.white,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.selectedImages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      AppSizes.borderRadiusLg,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                    image: DecorationImage(
                      image: FileImage(File(widget.selectedImages[index].path)),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          if (widget.selectedImages.length > 1) ...[
            SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.selectedImages.length, (index) {
                return GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: _currentImageIndex == index ? 24 : 8,
                    height: 8,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: _currentImageIndex == index
                          ? AppColors.primary
                          : AppColors.textLight,
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }

  Widget _buildCaptionInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.edit_note, size: 20, color: AppColors.primary),
              SizedBox(width: AppSpacing.xs),
              Text('Légende', style: AppTextStyles.heading4),
              Text(' *', style: TextStyle(color: AppColors.error)),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              border: Border.all(color: AppColors.border),
            ),
            child: TextField(
              controller: _captionController,
              maxLines: 4,
              maxLength: 500,
              style: AppTextStyles.body,
              decoration: InputDecoration(
                hintText: 'Partagez votre expérience culinaire...',
                hintStyle: AppTextStyles.body.copyWith(
                  color: AppColors.textLight,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(AppSpacing.md),
                counterStyle: AppTextStyles.caption.copyWith(
                  color: AppColors.textLight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.restaurant, size: 20, color: AppColors.primary),
              SizedBox(width: AppSpacing.xs),
              Text('Restaurant', style: AppTextStyles.heading4),
              Text(' *', style: TextStyle(color: AppColors.error)),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              border: Border.all(color: AppColors.border),
            ),
            child: TextField(
              controller: _restaurantController,
              style: AppTextStyles.body,
              decoration: InputDecoration(
                hintText: 'Nom du restaurant...',
                hintStyle: AppTextStyles.body.copyWith(
                  color: AppColors.textLight,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(AppSpacing.md),
                prefixIcon: Icon(
                  Icons.location_on,
                  color: AppColors.textMedium,
                ),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Padding(
            padding: EdgeInsets.only(left: AppSpacing.sm),
            child: Text(
              'Tapez le nom du restaurant',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDishNameInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.dining, size: 20, color: AppColors.primary),
              SizedBox(width: AppSpacing.xs),
              Text('Nom du plat', style: AppTextStyles.heading4),
              SizedBox(width: AppSpacing.xs),
              Text(
                '(Optionnel)',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMedium,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              border: Border.all(color: AppColors.border),
            ),
            child: TextField(
              controller: _dishNameController,
              style: AppTextStyles.body,
              decoration: InputDecoration(
                hintText: 'ex: Couscous Royal, Poisson Grillé...',
                hintStyle: AppTextStyles.body.copyWith(
                  color: AppColors.textLight,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(AppSpacing.md),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, size: 20, color: AppColors.starActive),
              SizedBox(width: AppSpacing.xs),
              Text('Votre évaluation', style: AppTextStyles.heading4),
              Text(' *', style: TextStyle(color: AppColors.error)),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Container(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _rating = (index + 1).toDouble();
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                    child: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: index < _rating
                          ? AppColors.starActive
                          : AppColors.textLight,
                      size: 40,
                    ),
                  ),
                );
              }),
            ),
          ),
          if (_rating > 0) ...[
            SizedBox(height: AppSpacing.sm),
            Center(
              child: Text(
                _getRatingText(_rating.toInt()),
                style: AppTextStyles.body.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Décevant';
      case 2:
        return 'Moyen';
      case 3:
        return 'Bien';
      case 4:
        return 'Très bien';
      case 5:
        return 'Excellent!';
      default:
        return '';
    }
  }
}
