import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../repositories/follow_repository.dart';
import '../../utils/constants.dart';
import '../../l10n/app_localizations.dart';
import '../../data/fake_data.dart';
import '../../repositories/profile_repository.dart';
import '../../repositories/post_repository.dart';
import '../../models/user.dart';
import '../../models/post.dart';
import '../../widgets/profile/profile_header.dart';
import '../../widgets/profile/profile_posts_grid.dart';
import '../home/post_detail_screen.dart';

class OtherUserProfileScreen extends StatefulWidget {
  final String userId;

  const OtherUserProfileScreen({super.key, required this.userId});

  @override
  State<OtherUserProfileScreen> createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {
  final ProfileRepository _repository = ProfileRepository();
  final PostRepository _postRepository = PostRepository();
  final FollowRepository _followRepository = FollowRepository();
  
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
      final isFollowing = await _followRepository.isFollowing(
        _currentUser!.uid!, 
        _user!.uid!
      );
      if (mounted) {
        setState(() => _isFollowing = isFollowing);
      }
    } catch (e) {
      print('❌ Error checking follow status: $e');
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
      print('🔍 Loading user with UID: ${widget.userId}');
      setState(() => _isLoading = true);
      // Use Firestore UID
      final user = await _repository.getUserByUid(widget.userId);
      print('✅ User loaded: ${user?.username} (UID: ${user?.uid})');
      
      if (mounted) {
        setState(() {
          _user = user;
          _isLoading = false;
        });
      }

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
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
          _isLoadingPosts = false;
        });
      }
    }
  }

  Future<void> _loadPosts() async {
    try {
      setState(() => _isLoadingPosts = true);
      print(' Loading posts for userId: ${widget.userId}');
      // Use Firestore method
      final posts = await _postRepository.getUserPosts(widget.userId);
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
    if (_currentUser == null || _user == null) {
      print('⚠️ Cannot toggle follow: _currentUser or _user is null');
      return;
    }

    final currentUid = _currentUser!.uid;
    final targetUid = _user!.uid;

    if (currentUid == null || targetUid == null) {
      return;
    }

    // Optimistic update
    setState(() => _isFollowing = !_isFollowing);

    try {
      if (_isFollowing) {
        await _followRepository.followUser(
          currentUserId: currentUid,
          targetUserId: targetUid,
        );
      } else {
        await _followRepository.unfollowUser(
          currentUserId: currentUid,
          targetUserId: targetUid,
        );
      }

      // Reload user data to get updated counts
      final updatedUser = await _repository.getUserByUid(widget.userId);
      if (mounted && updatedUser != null) {
        setState(() => _user = updatedUser);
        
        final l10n = AppLocalizations.of(context)!;
        final message = _isFollowing
            ? l10n.nowFollowing(_user!.username)
            : l10n.unfollowed(_user!.username);
        final bgColor = _isFollowing ? AppColors.success : AppColors.error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            behavior: SnackBarBehavior.floating,
            backgroundColor: bgColor,
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      // Revert on error
      if (mounted) {
        setState(() => _isFollowing = !_isFollowing);
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
            _errorMessage ?? AppLocalizations.of(context)!.userNotFound,
            style: AppTextStyles.bodyMedium,
          ),
        ),
      );
    }

    final username = _user!.username;
    // Use userAvatarUrl if available, fallback to legacy field or fake
    final avatar = _user!.userAvatarUrl ?? _user!.profileImage ?? FakeUserData.avatarUrl;

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
                          userId: _user!.uid,
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
                                _isFollowing 
                                    ? AppLocalizations.of(context)!.followed 
                                    : AppLocalizations.of(context)!.follow,
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
                                  AppLocalizations.of(context)!.noPosts,
                                  style: AppTextStyles.bodyMedium,
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
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => 
                                          PostDetailScreen(post: post.toFirestore()),
                                      ),
                                    );
                                    
                                    // Refresh posts when coming back (to update likes/comments counts)
                                    if (mounted) {
                                      _loadPosts();
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
  }

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
                title: Text(AppLocalizations.of(context)!.follow, style: AppTextStyles.bodyMedium),
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
                        title: Text(AppLocalizations.of(context)!.shareUserProfileTitle(_user!.username)),
                        content: SelectableText(shareText),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(AppLocalizations.of(context)!.close),
                          ),
                          TextButton(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: shareText));
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(AppLocalizations.of(context)!.copiedToClipboard),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Text(AppLocalizations.of(context)!.copy),
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
