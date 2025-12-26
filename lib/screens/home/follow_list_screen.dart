import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/app_localizations.dart';
import '../../models/user.dart';
import '../../repositories/follow_repository.dart';
import '../../repositories/profile_repository.dart';
import '../../repositories/auth_repository.dart';
import '../../utils/constants.dart';
import '../profile/other_user_profile_screen.dart';
import 'navigation_shell.dart';

class FollowListScreen extends StatefulWidget {
  final String userId;
  final bool isFollowers;

  const FollowListScreen({
    super.key,
    required this.userId,
    required this.isFollowers,
  });

  @override
  State<FollowListScreen> createState() => _FollowListScreenState();
}

class _FollowListScreenState extends State<FollowListScreen> {
  final FollowRepository _followRepo = FollowRepository();
  final ProfileRepository _profileRepo = ProfileRepository();
  
  List<User>? _users;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final uids = widget.isFollowers
          ? await _followRepo.getFollowerIds(widget.userId)
          : await _followRepo.getFollowingIds(widget.userId);

      if (uids.isEmpty) {
        setState(() {
          _users = [];
          _isLoading = false;
        });
        return;
      }

      final users = await _profileRepo.getUsersByUids(uids);
      setState(() {
        _users = users;
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
    final title = widget.isFollowers ? l10n.followers : l10n.following;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(title, style: AppTextStyles.heading4),
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

    if (_users == null || _users!.isEmpty) {
      return Center(
        child: Text(
          widget.isFollowers ? l10n.noFollowers : l10n.noFollowing,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMedium),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      itemCount: _users!.length,
      separatorBuilder: (context, index) => const Divider(height: 1, indent: 70),
      itemBuilder: (context, index) {
        final user = _users![index];
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
              // Pop back to profile from screens pushed onto it
              Navigator.of(context).popUntil((route) => route.isFirst);
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
