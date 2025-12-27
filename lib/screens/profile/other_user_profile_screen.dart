import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants.dart';
import '../../l10n/app_localizations.dart';
import '../../data/fake_data.dart';
import '../../repositories/profile_repository.dart';
import '../../repositories/post_repository.dart';
import '../../models/user.dart';
import '../../models/post.dart';
import '../../widgets/profile/profile_header.dart';
import '../../widgets/profile/profile_posts_grid.dart';

class OtherUserProfileScreen extends StatefulWidget {
  final String userId;

  const OtherUserProfileScreen({super.key, required this.userId});

  @override
  State<OtherUserProfileScreen> createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {
  final ProfileRepository _repository = ProfileRepository();
  final PostRepository _postRepository = PostRepository();
  User? _user;
  User? _currentUser;
  List<Post> _posts = [];
  bool _isLoading = true;
  bool _isLoadingPosts = true;
  bool _isFollowing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadUser();
  }

  Future<void> _checkFollowingStatus() async {
    if (_currentUser == null || _user == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final followingList =
          prefs.getStringList('following_${_currentUser!.id}') ?? [];
      final isFollowing = followingList.contains(_user!.id.toString());
      print(
        '🔍 Checking follow status: Current user ${_currentUser!.id} -> Other user ${_user!.id}',
      );
      print('   Following list: $followingList');
      print('   Is following: $isFollowing');
      setState(() => _isFollowing = isFollowing);
    } catch (e) {
      print('❌ Error checking follow status: $e');
    }
  }

  Future<void> _saveFollowingStatus(String userId, bool isFollowing) async {
    if (_currentUser == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'following_${_currentUser!.id}';
      final followingList = prefs.getStringList(key) ?? [];
      final userIdStr = userId.toString();

      if (isFollowing && !followingList.contains(userIdStr)) {
        followingList.add(userIdStr);
      } else if (!isFollowing && followingList.contains(userIdStr)) {
        followingList.remove(userIdStr);
      }

      await prefs.setStringList(key, followingList);
      print('💾 Saved follow status: $key = $followingList');
    } catch (e) {
      print('❌ Error saving follow status: $e');
    }
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await _repository.getCurrentUser();
      setState(() => _currentUser = user);
      // Check follow status after current user is loaded
      if (_user != null) {
        await _checkFollowingStatus();
      }
    } catch (e) {
      print('Error loading current user: $e');
    }
  }

  Future<void> _loadUser() async {
    try {
      print('🔍 Loading user with ID: ${widget.userId}');
      setState(() => _isLoading = true);
      // Use getUserByUid or getUserById string version
      final user = await _repository.getUserByUid(widget.userId);
      print('✅ User loaded: ${user?.username} (ID: ${user?.id})');
      setState(() {
        _user = user;
        _isLoading = false;
      });

      // Check follow status after user is loaded
      if (_currentUser != null) {
        await _checkFollowingStatus();
      }

      // Load posts after user is loaded
      if (user != null) {
        _loadPosts();
      }
    } catch (e) {
      print('❌ Error loading user: $e');
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
        _isLoadingPosts = false;
      });
    }
  }

  Future<void> _loadPosts() async {
    try {
      setState(() => _isLoadingPosts = true);
      print(' Loading posts for userId: ${widget.userId}');
      final posts = await _postRepository.getPostsByUserId(widget.userId);
      print(' Posts loaded: ${posts.length} posts found');
      if (mounted) {
        setState(() {
          _posts = posts;
          _isLoadingPosts = false;
        });
      }
    } catch (e) {
      print('Error loading posts: $e');
      if (mounted) {
        setState(() => _isLoadingPosts = false);
      }
    }
  }

  Future<void> _toggleFollow() async {
    if (_currentUser == null || _user == null) return;

    try {
      final currentUser = _currentUser!;
      final otherUser = _user!;
      final newFollowingState = !_isFollowing;

      late User updatedCurrentUser;
      late User updatedOtherUser;

      if (newFollowingState) {
        // Follow: current user's following +1, other user's followers +1
        updatedCurrentUser = User(
          id: currentUser.id,
          displayName: currentUser.displayName,
          username: currentUser.username,
          email: currentUser.email,
          password: currentUser.password,
          phone: currentUser.phone,
          profileImage: currentUser.profileImage,
          bio: currentUser.bio,
          followersCount: currentUser.followersCount,
          followingCount: currentUser.followingCount + 1,
          points: currentUser.points,
          level: currentUser.level,
        );

        updatedOtherUser = User(
          id: otherUser.id,
          displayName: otherUser.displayName,
          username: otherUser.username,
          email: otherUser.email,
          password: otherUser.password,
          phone: otherUser.phone,
          profileImage: otherUser.profileImage,
          bio: otherUser.bio,
          followersCount: otherUser.followersCount + 1,
          followingCount: otherUser.followingCount,
          points: otherUser.points,
          level: otherUser.level,
        );
      } else {
        // Unfollow: current user's following -1, other user's followers -1
        updatedCurrentUser = User(
          id: currentUser.id,
          displayName: currentUser.displayName,
          username: currentUser.username,
          email: currentUser.email,
          password: currentUser.password,
          phone: currentUser.phone,
          profileImage: currentUser.profileImage,
          bio: currentUser.bio,
          followersCount: currentUser.followersCount,
          followingCount: (currentUser.followingCount - 1).clamp(0, 999999),
          points: currentUser.points,
          level: currentUser.level,
        );

        updatedOtherUser = User(
          id: otherUser.id,
          displayName: otherUser.displayName,
          username: otherUser.username,
          email: otherUser.email,
          password: otherUser.password,
          phone: otherUser.phone,
          profileImage: otherUser.profileImage,
          bio: otherUser.bio,
          followersCount: (otherUser.followersCount - 1).clamp(0, 999999),
          followingCount: otherUser.followingCount,
          points: otherUser.points,
          level: otherUser.level,
        );
      }

      // Save both users and follow state
      await _repository.updateUser(updatedCurrentUser);
      await _repository.updateUser(updatedOtherUser);
      await _saveFollowingStatus(otherUser.id!, newFollowingState);

      setState(() {
        _currentUser = updatedCurrentUser;
        _user = updatedOtherUser;
        _isFollowing = newFollowingState;
      });

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        final message = newFollowingState
            ? '${l10n.nowFollowing} ${_user!.username}'
            : '${l10n.unfollowed} ${_user!.username}';
        final bgColor = newFollowingState ? AppColors.success : AppColors.error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            behavior: SnackBarBehavior.floating,
            backgroundColor: bgColor,
          ),
        );
      }
    } catch (e) {
      print('Error toggling follow: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.errorUpdatingFollow),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null || _user == null) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Text(
            _errorMessage ?? 'User not found',
            style: AppTextStyles.bodyMedium,
          ),
        ),
      );
    }

    final username = _user!.username;
    final avatar = _user!.profileImage ?? FakeUserData.avatarUrl;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
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
              alpha: AppConstants.opacityMedium,
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
                          avatarUrl: avatar,
                          username: username,
                          posts: _posts.length,
                          followers: _user!.followersCount,
                          following: _user!.followingCount,
                          rank: _user!.level,
                          points: _user!.points,
                        ),

                        // Divider Line
                        Container(height: 1, color: AppColors.divider),

                        // Follow Button
                        Padding(
                          padding: EdgeInsets.all(AppSpacing.lg),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _toggleFollow,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isFollowing
                                    ? Colors.grey[300]
                                    : AppColors.primary,
                                padding: EdgeInsets.symmetric(
                                  vertical: AppSpacing.md,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.borderRadius,
                                  ),
                                ),
                              ),
                              child: Text(
                                _isFollowing ? 'Followed' : 'Follow',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: _isFollowing
                                      ? AppColors.textDark
                                      : Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),

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
  }

  List<Map<String, dynamic>> _convertPostsToFakeFormat() {
    return _posts.map((post) {
      final images = post.images;
      return {
        'id': post.id,
        'imageUrl': images.isNotEmpty ? images.first : FakeUserData.avatarUrl,
        'likes': post.likesCount,
        'comments': post.commentsCount,
      };
    }).toList();
  }

  /// Show menu with follow and share options
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
                  Icons.person_add_outlined,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text('Follow', style: AppTextStyles.bodyMedium),
                onTap: () {
                  Navigator.pop(context);
                  _toggleFollow();
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.share_outlined,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text(
                  AppLocalizations.of(context)!.shareProfile,
                  style: AppTextStyles.bodyMedium,
                ),
                onTap: () async {
                  Navigator.pop(context);
                  if (_user != null) {
                    final shareText =
                        'Check out @${_user!.username} on Ate!\n\n${_user!.bio ?? ""}';
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Share ${_user!.username}\'s Profile'),
                        content: SelectableText(shareText),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Close'),
                          ),
                          TextButton(
                            onPressed: () {
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
