import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../blocs/profile/profile_cubit.dart';
import '../../models/user.dart';

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
    final cubit = context.read<ProfileCubit>();
    final currentUser = cubit.state.user;
    final user = User(
      id: currentUser?.id,
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
    );

    await cubit.saveProfile(user);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.profileUpdated),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
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
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primary),
            filled: true,
            fillColor: AppColors.backgroundLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              borderSide: BorderSide(color: AppColors.border),
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
            icon: Icon(Icons.check, size: 20),
            label: Text(
              AppLocalizations.of(context)!.submit,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
          ),
          SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Avatar Section
            Container(
              color: AppColors.white,
              padding: EdgeInsets.all(AppSpacing.xl),
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
                            (user != null &&
                                (user.profileImage?.isNotEmpty ?? false))
                            ? (user.profileImage!.startsWith('http')
                                  ? NetworkImage(user.profileImage!)
                                        as ImageProvider
                                  : FileImage(File(user.profileImage!)))
                            : null,
                        child:
                            (user?.profileImage == null ||
                                user!.profileImage!.isEmpty)
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

                          final current = context
                              .read<ProfileCubit>()
                              .state
                              .user;
                          final updatedUser = User(
                            id: current?.id,
                            displayName:
                                _fullNameController.text.trim().isNotEmpty
                                ? _fullNameController.text.trim()
                                : current?.displayName,
                            username: _usernameController.text.trim().isNotEmpty
                                ? _usernameController.text.trim()
                                : current?.username ?? '',
                            email: _emailController.text.trim().isNotEmpty
                                ? _emailController.text.trim()
                                : current?.email ?? '',
                            phone: _phoneController.text.trim().isNotEmpty
                                ? _phoneController.text.trim()
                                : current?.phone,
                            bio: _bioController.text.trim().isNotEmpty
                                ? _bioController.text.trim()
                                : current?.bio,
                            profileImage: picked.path,
                            followersCount: current?.followersCount ?? 0,
                            followingCount: current?.followingCount ?? 0,
                            points: current?.points ?? 0,
                            level: current?.level ?? 'Bronze',
                          );
                          if (mounted) {
                            await context.read<ProfileCubit>().saveProfile(
                              updatedUser,
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadow,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
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

            SizedBox(height: AppSpacing.sm),

            // Form Section
            Container(
              color: AppColors.white,
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    label: AppLocalizations.of(context)!.fullName,
                    controller: _fullNameController,
                    icon: Icons.person_outline,
                  ),
                  SizedBox(height: AppSpacing.lg),
                  _buildTextField(
                    label: AppLocalizations.of(context)!.username,
                    controller: _usernameController,
                    icon: Icons.alternate_email,
                  ),
                  SizedBox(height: AppSpacing.lg),
                  _buildTextField(
                    label: AppLocalizations.of(context)!.email,
                    controller: _emailController,
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: AppSpacing.lg),
                  _buildTextField(
                    label: AppLocalizations.of(context)!.phone,
                    controller: _phoneController,
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: AppSpacing.lg),
                  _buildTextField(
                    label: AppLocalizations.of(context)!.bio,
                    controller: _bioController,
                    icon: Icons.notes_outlined,
                    maxLines: 3,
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
