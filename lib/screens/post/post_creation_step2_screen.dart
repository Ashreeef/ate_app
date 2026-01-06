import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../l10n/app_localizations.dart';
import 'package:ate_app/utils/constants.dart';
import '../../blocs/post/post_bloc.dart';
import '../../blocs/post/post_event.dart';
import '../../blocs/post/post_state.dart';
import '../../repositories/auth_repository.dart';
import '../../widgets/post/restaurant_selection_widget.dart';
import '../../models/challenge.dart';
import '../../repositories/challenge_repository.dart';

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
  String? _selectedRestaurantId;

  Future<void> _publishPost() async {
    final l10n = AppLocalizations.of(context)!;
    if (_captionController.text.isEmpty) {
      _showErrorSnackBar(l10n.writeCaption);
      return;
    }

    if (_restaurantController.text.isEmpty) {
      _showErrorSnackBar(l10n.enterRestaurant);
      return;
    }

    if (_rating == 0) {
      _showErrorSnackBar(l10n.rateExperience);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Get current user from AuthRepository
      final authRepo = context.read<AuthRepository>();
      final currentUser = await authRepo.getCurrentUser();

      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Convert XFile to File for Cloudinary upload
      List<File> imageFiles = widget.selectedImages
          .map((xfile) => File(xfile.path))
          .toList();

      // Create post event with new structure
      context.read<PostBloc>().add(
        CreatePostEvent(
          userUid: currentUser.uid!,
          username: currentUser.username,
          userAvatarUrl: currentUser.profileImage,
          caption: _captionController.text,
          imageFiles: imageFiles,
          restaurantUid: _selectedRestaurantId,
          restaurantName: _restaurantController.text,
          dishName: _dishNameController.text.isNotEmpty
              ? _dishNameController.text
              : null,
          rating: _rating,
          explicitChallengeId: _selectedChallengeId,
        ),
      );
    } catch (e) {
      _showErrorSnackBar('${AppLocalizations.of(context)!.error}: $e');
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
        final l10n = AppLocalizations.of(context)!;
        if (state is PostSuccess) {
          _showSuccessSnackBar(l10n.postPublished);
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        } else if (state is PostFailure) {
          _showErrorSnackBar('${l10n.error}: ${state.error}');
          setState(() => _isSubmitting = false);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.newPost,
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
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
                AppLocalizations.of(context)!.publish,
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
              _buildChallengeSelection(), // New Widget
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
      color: Theme.of(context).cardColor,
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
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.edit_note, size: 20, color: AppColors.primary),
              SizedBox(width: AppSpacing.xs),
              Text(l10n.caption, style: AppTextStyles.heading4),
              Text(' *', style: TextStyle(color: AppColors.error)),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              border: Border.all(color: AppColors.border),
            ),
            child: TextField(
              controller: _captionController,
              maxLines: 4,
              maxLength: 500,
              style: AppTextStyles.body,
              decoration: InputDecoration(
                hintText: l10n.captionPlaceholder,
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
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.restaurant, size: 20, color: AppColors.primary),
              SizedBox(width: AppSpacing.xs),
              Text(l10n.restaurant, style: AppTextStyles.heading4),
              Text(' *', style: TextStyle(color: AppColors.error)),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          RestaurantSelectionWidget(
            controller: _restaurantController,
            onSelected: (id, name) {
              setState(() {
                _selectedRestaurantId = id;
              });
            },
          ),
          SizedBox(height: AppSpacing.xs),
          Padding(
            padding: EdgeInsets.only(left: AppSpacing.sm),
            child: Text(
              l10n.restaurantHint,
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
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.dining, size: 20, color: AppColors.primary),
              SizedBox(width: AppSpacing.xs),
              Text(l10n.dishName, style: AppTextStyles.heading4),
              SizedBox(width: AppSpacing.xs),
              Text(
                l10n.dishNameOptional,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMedium,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              border: Border.all(color: AppColors.border),
            ),
            child: TextField(
              controller: _dishNameController,
              style: AppTextStyles.body,
              decoration: InputDecoration(
                hintText: l10n.dishNamePlaceholder,
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
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, size: 20, color: AppColors.starActive),
              SizedBox(width: AppSpacing.xs),
              Text(l10n.yourRating, style: AppTextStyles.heading4),
              Text(' *', style: TextStyle(color: AppColors.error)),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Container(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
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
    final l10n = AppLocalizations.of(context)!;
    switch (rating) {
      case 1:
        return l10n.disappointing;
      case 2:
        return l10n.fair;
      case 3:
        return l10n.good;
      case 4:
        return l10n.veryGood;
      case 5:
        return l10n.excellent;
      default:
        return '';
    }
  }

  // State for challenges
  String? _selectedChallengeId;
  List<Challenge> _activeChallenges = [];
  bool _isLoadingChallenges = false;

  @override
  void initState() {
    super.initState();
    _loadUserChallenges();
  }

  Future<void> _loadUserChallenges() async {
    setState(() => _isLoadingChallenges = true);
    try {
      final authRepo = context.read<AuthRepository>();
      final currentUser = await authRepo.getCurrentUser();
      
      if (currentUser?.uid != null) {
        final challengeRepo = ChallengeRepository();
        final challenges = await challengeRepo.getUserActiveChallenges(currentUser!.uid!);
        if (mounted) {
          setState(() {
            _activeChallenges = challenges;
            _isLoadingChallenges = false;
          });
        }
      } else {
        setState(() => _isLoadingChallenges = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingChallenges = false);
    }
  }

  Widget _buildChallengeSelection() {
    if (_activeChallenges.isEmpty) return SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.emoji_events, size: 20, color: Colors.orange),
              SizedBox(width: AppSpacing.xs),
              Text(l10n.challengesTitle, style: AppTextStyles.heading4),
              SizedBox(width: AppSpacing.xs),
              Text(
                l10n.dishNameOptional, // Removed extra parentheses
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMedium,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          _isLoadingChallenges 
              ? Center(child: CircularProgressIndicator()) 
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedChallengeId,
                      hint: Text(l10n.selectChallenge),
                      items: [
                        DropdownMenuItem<String>(
                          value: null,
                          child: Text(l10n.none),
                        ),
                        ..._activeChallenges.map((challenge) {
                          return DropdownMenuItem<String>(
                            value: challenge.id,
                            child: Text(
                              challenge.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedChallengeId = value;
                        });
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
