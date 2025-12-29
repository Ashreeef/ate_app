import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/app_localizations.dart';
import '../../models/user.dart';
import '../../repositories/like_repository.dart';
import '../../repositories/profile_repository.dart';
import '../../repositories/auth_repository.dart';
import '../../utils/constants.dart';
import '../profile/other_user_profile_screen.dart';
import 'package:ate_app/screens/home/navigation_shell.dart';

class PostLikesScreen extends StatefulWidget {
  final String postId;

  const PostLikesScreen({super.key, required this.postId});

  @override
  State<PostLikesScreen> createState() => _PostLikesScreenState();
}

class _PostLikesScreenState extends State<PostLikesScreen> {
  final LikeRepository _likeRepo = LikeRepository();
  final ProfileRepository _profileRepo = ProfileRepository();
  
  List<User>? _likers;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchLikers();
  }

  Future<void> _fetchLikers() async {
    try {
      final uids = await _likeRepo.getPostLikes(widget.postId);
      if (uids.isEmpty) {
        setState(() {
          _likers = [];
          _isLoading = false;
        });
        return;
      }

      final users = await _profileRepo.getUsersByUids(uids);
      setState(() {
        _likers = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.likes, style: AppTextStyles.heading4),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text(_error!));
    }

    if (_likers == null || _likers!.isEmpty) {
      return Center(
        child: Text(
          'No likes yet',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMedium),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      itemCount: _likers!.length,
      separatorBuilder: (context, index) => const Divider(height: 1, indent: 70),
      itemBuilder: (context, index) {
        final user = _likers![index];
        return ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: user.profileImage != null && user.profileImage!.isNotEmpty
                ? NetworkImage(user.profileImage!)
                : null,
            backgroundColor: AppColors.background,
            child: user.profileImage == null || user.profileImage!.isEmpty
                ? const Icon(Icons.person, color: AppColors.textMedium)
                : null,
          ),
          title: Text(
            user.username,
            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: user.bio != null && user.bio!.isNotEmpty
              ? Text(
                  user.bio!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption,
                )
              : null,
          onTap: () {
            final currentUserUid = context.read<AuthRepository>().currentUserId;
            if (user.uid == currentUserUid) {
              NavigationShell.selectTab(context, 4);
              Navigator.pop(context); // Close likes list
              // If we were in post detail, we might need another pop
              // but selectTab handles the main navigation.
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OtherUserProfileScreen(
                    userId: user.uid!,
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
