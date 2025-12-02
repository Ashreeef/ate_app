import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants.dart';
import '../../l10n/app_localizations.dart';
import '../../data/fake_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/profile/profile_cubit.dart';
import '../../blocs/profile/profile_state.dart';
import '../../models/post.dart';
import '../../repositories/post_repository.dart';
import '../../widgets/profile/profile_header.dart';
import '../../widgets/profile/profile_posts_grid.dart';
import 'edit_profile_screen.dart';
import 'other_user_profile_screen.dart';
import '../settings/settings_screen.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final PostRepository _postRepository = PostRepository();
  List<Post> _posts = [];
  bool _isLoadingPosts = true;

  @override
  void initState() {
    super.initState();
    _loadProfileAndPosts();
  }

  Future<void> _loadProfileAndPosts() async {
    //  reload profile from database
    final cubit = context.read<ProfileCubit>();
    await cubit.loadProfile();

    // Then load posts
    await _loadPosts();
  }

  Future<void> _loadPosts() async {
    final cubit = context.read<ProfileCubit>();
    final userId = cubit.state.user?.id;

    if (userId != null) {
      try {
        final posts = await _postRepository.getPostsByUserId(userId);
        if (mounted) {
          setState(() {
            _posts = posts;
            _isLoadingPosts = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoadingPosts = false);
        }
      }
    } else {
      if (mounted) {
        setState(() => _isLoadingPosts = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // Show loading indicator while profile is being loaded
        if (state.status == ProfileStatus.loading || _isLoadingPosts) {
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              backgroundColor: AppColors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text('Profile', style: AppTextStyles.heading4),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = state.user;

        // Debug: print user data
        print(' MyProfileScreen - User: ${user?.username}, ID: ${user?.id}');
        print(
          ' Stats - Followers: ${user?.followersCount}, Points: ${user?.points}',
        );

        final username = user?.username ?? FakeUserData.username;
        final avatar = user?.profileImage ?? FakeUserData.avatarUrl;

        return Scaffold(
          backgroundColor: AppColors.white,

          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              '@$username',
              style: AppTextStyles.heading4.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).iconTheme.color,
                ),
                tooltip: 'More options',
                onPressed: () {
                  _showOptionsMenu(context);
                },
              ),
            ],
          ),

          body: Column(
            children: [
              // Subtle divider under app bar
              Container(height: 1, color: AppColors.divider.withOpacity(0.5)),

              Expanded(
                child: _isLoadingPosts
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            // Profile Header Component
                            ProfileHeader(
                              avatarUrl: avatar,
                              username: username,
                              posts: _posts.length,
                              followers: user?.followersCount ?? 0,
                              following: user?.followingCount ?? 0,
                              rank: user?.level ?? 'Bronze',
                              points: user?.points ?? 0,
                            ),

                            // Divider Line
                            Container(height: 1, color: AppColors.divider),

                            // Posts Grid Component
                            _posts.isEmpty
                                ? Padding(
                                    padding: EdgeInsets.all(AppSpacing.xl),
                                    child: Text(
                                      'No posts yet',
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                  )
                                : ProfilePostsGrid(
                                    posts: _convertPostsToFakeFormat(),
                                  ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> _convertPostsToFakeFormat() {
    return _posts.map((post) {
      final images = post.getImageList();
      return {
        'id': post.id,
        'imageUrl': images.isNotEmpty ? images.first : FakeUserData.avatarUrl,
        'likes': post.likesCount,
        'comments': post.commentsCount,
      };
    }).toList();
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.borderRadiusLg),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.settings_outlined,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text(
                  AppLocalizations.of(context)!.settingsTitle,
                  style: AppTextStyles.bodyMedium,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.edit_outlined,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text(
                  AppLocalizations.of(context)!.editProfile,
                  style: AppTextStyles.bodyMedium,
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(),
                    ),
                  );
                  // Reload profile and posts after returning from edit screen
                  if (mounted) {
                    await _loadProfileAndPosts();
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.share_outlined),
                title: Text(
                  AppLocalizations.of(context)!.shareProfile,
                  style: AppTextStyles.bodyMedium,
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final user = context.read<ProfileCubit>().state.user;
                  if (user != null) {
                    final shareText =
                        'Check out my profile on Ate!\n\nUsername: @${user.username}\nBio: ${user.bio}';
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Share Profile'),
                        content: SelectableText(shareText),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Close'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Copy to clipboard
                              Clipboard.setData(ClipboardData(text: shareText));
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Copied to clipboard'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Text('Copy'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.person_outline),
                title: Text('View Other Profile'),
                onTap: () async {
                  Navigator.pop(context);
                  final prefs = await SharedPreferences.getInstance();
                  final otherUserId = prefs.getInt('other_user_id') ?? 2;
                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OtherUserProfileScreen(userId: otherUserId),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
