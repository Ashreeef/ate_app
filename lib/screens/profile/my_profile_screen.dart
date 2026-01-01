import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart' show AppColors, AppSpacing, AppSizes;
import '../../utils/constants.dart' as constants;
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
import '../settings/settings_screen.dart';
import '../home/post_detail_screen.dart';
import '../saved/saved_posts_screen.dart';

/// Current user's profile screen with posts and profile management
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

  /// Reload user profile and their posts from database
  Future<void> _loadProfileAndPosts() async {
    // Refresh profile data from database
    final cubit = context.read<ProfileCubit>();
    await cubit.loadProfile();

    // Load user's posts
    await _loadPosts();
  }

  /// Fetch posts for current user from database
  Future<void> _loadPosts() async {
    final cubit = context.read<ProfileCubit>();
    final user = cubit.state.user;
    final userUid = user?.uid;

    if (userUid != null) {
      try {
        final posts = await _postRepository.getUserPosts(userUid);
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
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // Show loading indicator while profile is being loaded
        if (state.status == ProfileStatus.loading || _isLoadingPosts) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              elevation: 0,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text(
                l10n.profile,
                style: constants.AppTextStyles.heading4,
              ),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = state.user;

        // Debug: print user data
        print(' MyProfileScreen - User: ${user?.username}, UID: ${user?.uid}');
        print(
          ' Stats - Followers: ${user?.followersCount}, Points: ${user?.points}',
        );

        final username = user?.username ?? FakeUserData.username;
        final avatar = user?.profileImage ?? FakeUserData.avatarUrl;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,

          appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 0,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              '@$username',
              style: constants.AppTextStyles.heading4.copyWith(
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
                tooltip: AppLocalizations.of(context)!.moreOptions,
                onPressed: () {
                  _showOptionsMenu(context);
                },
              ),
            ],
          ),

          body: Column(
            children: [
              // Subtle divider under app bar
              Container(
                height: 1,
                color: AppColors.divider.withValues(
                  alpha: constants.AppConstants.opacityMedium,
                ),
              ),

              Expanded(
                child: _isLoadingPosts
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            // Profile Header Component
                            ProfileHeader(
                              userId: user?.uid,
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
                                      AppLocalizations.of(context)!.noPosts,
                                      style: constants.AppTextStyles.bodyMedium,
                                    ),
                                  )
                                : ProfilePostsGrid(
                                    posts: _convertPostsToFakeFormat(),
                                    onPostTap: (postId) async {
                                      try {
                                        final post = _posts.firstWhere(
                                          (p) => p.postId == postId,
                                        );
                                        // Navigate to detail screen
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PostDetailScreen(
                                                  post: post.toFirestore(),
                                                ),
                                          ),
                                        );

                                        // If post was deleted (result == true), reload posts
                                        if (result == true && mounted) {
                                          _loadPosts();
                                          // Also refresh user profile stats (post count)
                                          context
                                              .read<ProfileCubit>()
                                              .loadProfile();
                                        }
                                      } catch (e) {
                                        print('Error navigating to post: $e');
                                      }
                                    },
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

  /// Convert database posts to grid display format
  List<Map<String, dynamic>> _convertPostsToFakeFormat() {
    return _posts.map((post) {
      final images = post.images;
      return {
        'id': post.postId,
        'imageUrl': images.isNotEmpty ? images.first : FakeUserData.avatarUrl,
        'likes': post.likesCount,
        'comments': post.commentsCount,
      };
    }).toList();
  }

  /// Show profile options menu (settings, edit, share)
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
                  style: constants.AppTextStyles.bodyMedium,
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
                  Icons.bookmark_outline,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text(
                  AppLocalizations.of(context)!.savedPosts,
                  style: constants.AppTextStyles.bodyMedium,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SavedPostsScreen(),
                    ),
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
                  style: constants.AppTextStyles.bodyMedium,
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
                  style: constants.AppTextStyles.bodyMedium,
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
                        title: Text(
                          AppLocalizations.of(context)!.shareProfileTitle,
                        ),
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
            ],
          ),
        );
      },
    );
  }
}
