import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../blocs/profile/profile_cubit.dart';
import '../../models/user.dart';
import '../../services/cloudinary_storage_service.dart';
import '../../repositories/post_repository.dart';

/// Screen for editing user profile (bio, display name, phone, avatar)
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();
  File? _tempImageFile;

  @override
  void initState() {
    super.initState();
    // Load profile data after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  /// Load current user data from cubit and populate form fields
  Future<void> _loadUserData() async {
    final cubit = context.read<ProfileCubit>();
    await cubit.loadProfile();

    final user = cubit.state.user;
    if (user != null && mounted) {
      setState(() {
        _fullNameController.text = user.displayName ?? '';
        _usernameController.text = user.username;
        _emailController.text = user.email;
        _phoneController.text = user.phone ?? '';
        _bioController.text = user.bio ?? '';
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  /// Save profile changes to database and show success message
  Future<void> _saveProfile() async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final cubit = context.read<ProfileCubit>();
      final currentUser = cubit.state.user;
      
      final user = User(
        id: currentUser?.id,
        uid: currentUser?.uid,
        displayName: _fullNameController.text.trim(),
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        bio: _bioController.text.trim(),
        profileImage: currentUser?.profileImage,
        followersCount: currentUser?.followersCount ?? 0,
        followingCount: currentUser?.followingCount ?? 0,
        points: currentUser?.points ?? 0,
        level: currentUser?.level ?? 'Bronze',
        createdAt: currentUser?.createdAt,
        updatedAt: DateTime.now().toIso8601String(),
      );

      final PostRepository _postRepo = PostRepository(); // Instantiated PostRepository

      // We need to check if profileImage is a local file and upload it
      if (_tempImageFile != null) {
        // Upload new image
        final imageUrl = await CloudinaryStorageService().uploadProfileImage(
          _tempImageFile!, 
          user.uid ?? 'unknown_user'
        );
        
        // Update user with real URL
        final userWithUrl = user.copyWith(profileImage: imageUrl);
        await cubit.saveProfile(userWithUrl);

        // Sync posts with new avatar & username
        if (user.uid != null) {
          await _postRepo.updatePostUserByUid(
            userUid: user.uid!,
            username: _usernameController.text,
            userAvatarUrl: imageUrl,
          );
        }
      } else {
        await cubit.saveProfile(user);
        
        // Sync posts with new username (avatar unchanged)
        if (user.uid != null) {
          await _postRepo.updatePostUserByUid(
            userUid: user.uid!,
            username: _usernameController.text,
            userAvatarUrl: user.profileImage,
          );
        }
      }

      if (mounted) {
        Navigator.pop(context); // Dismiss loading overlay
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.profileUpdated),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context); // Go back
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Dismiss loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: AppSpacing.sm),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.white
                : AppColors.textDark,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primary),
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.secondary.withValues(alpha: 0.1)
                : AppColors.backgroundLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              borderSide: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.white.withValues(alpha: 0.2)
                    : AppColors.border,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ProfileCubit>();
    final state = cubit.state;
    final user = state.user;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.editProfile,
          style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton.icon(
            onPressed: _saveProfile,
            icon: const Icon(Icons.check, size: 20),
            label: Text(
              AppLocalizations.of(context)!.submit,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Avatar Section
            Container(
              color: Theme.of(context).cardColor,
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 3),
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor:
                            Theme.of(
                                  context,
                                ).cardTheme.color?.withOpacity(0.3) ??
                            Colors.grey[700],
                        backgroundImage:
                            _tempImageFile != null
                                ? FileImage(_tempImageFile!)
                                : (user != null &&
                                        (user.profileImage?.isNotEmpty ??
                                            false))
                                    ? (user.profileImage!.startsWith('http')
                                            ? NetworkImage(user.profileImage!)
                                                as ImageProvider
                                            : FileImage(
                                                File(user.profileImage!)))
                                    : null,
                        child:
                            (_tempImageFile == null &&
                                    (user?.profileImage == null ||
                                        user!.profileImage!.isEmpty))
                                ? Icon(
                                    Icons.person,
                                    size: 60,
                                    color: AppColors.textMedium,
                                  )
                                : null,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () async {
                          final picker = ImagePicker();
                          final picked = await picker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 80,
                          );
                          if (picked == null) return;

                          // Only update local state for preview
                          setState(() {
                            _tempImageFile = File(picked.path);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.shadow,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: AppColors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            // Form Section
            Container(
              color: Theme.of(context).cardColor,
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    label: AppLocalizations.of(context)!.fullName,
                    controller: _fullNameController,
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildTextField(
                    label: AppLocalizations.of(context)!.username,
                    controller: _usernameController,
                    icon: Icons.alternate_email,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildTextField(
                    label: AppLocalizations.of(context)!.email,
                    controller: _emailController,
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildTextField(
                    label: AppLocalizations.of(context)!.phone,
                    controller: _phoneController,
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildTextField(
                    label: AppLocalizations.of(context)!.bio,
                    controller: _bioController,
                    icon: Icons.notes_outlined,
                    maxLines: 3,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
