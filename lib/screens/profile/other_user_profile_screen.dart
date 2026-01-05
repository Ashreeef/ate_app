import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../repositories/follow_repository.dart';
import '../../utils/constants.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/profile_repository.dart';
import '../../repositories/post_repository.dart';
import '../../models/user.dart';
import '../../models/post.dart';
import '../home/post_detail_screen.dart';
import '../home/follow_list_screen.dart';

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
  bool _isFollowing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeProfile();
  }

  @override
  void dispose() {
    // Clear any pending operations or listeners
    super.dispose();
  }

  /// Initialize profile data in proper sequence
  Future<void> _initializeProfile() async {
    if (!mounted) return;

    try {
      // Load current user first
      await _loadCurrentUser();
      if (!mounted) return;

      // Then load the profile user
      await _loadUser();
      if (!mounted) return;

      // Finally load posts
      await _loadPosts();
    } catch (e) {
      print('❌ Error initializing profile: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> _checkFollowingStatus() async {
    if (_currentUser == null || _user == null) return;
    try {
      final isFollowing = await _followRepository.isFollowing(
        _currentUser!.uid!,
        _user!.uid!,
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
        // Check follow status after user is loaded
        await _checkFollowingStatus();
      }
    } catch (e) {
      print('❌ Error loading user: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> _loadPosts() async {
    if (!mounted) return;

    print(' Loading posts for user: ${widget.userId}');

    try {
      final posts = await _postRepository.getUserPosts(widget.userId);
      print(' Loaded ${posts.length} posts');
      if (mounted) {
        setState(() {
          _posts = posts;
        });
      }
    } catch (e) {
      print(' Error loading posts: $e');
      // Don't change loading state here as it might conflict with user loading
    }
  }

  Future<void> _toggleFollow() async {
    if (_currentUser == null || _user == null) return;

    final currentUserId = _currentUser!.uid!;
    final targetUserId = _user!.uid!;
    print(' Toggle follow: $currentUserId -> $targetUserId');

    try {
      if (_isFollowing) {
        await _followRepository.unfollowUser(
          currentUserId: currentUserId,
          targetUserId: targetUserId,
        );
      } else {
        await _followRepository.followUser(
          currentUserId: currentUserId,
          targetUserId: targetUserId,
        );
      }

      // Update user data
      final updatedUser = await _repository.getUserByUid(widget.userId);
      if (mounted) {
        setState(() => _user = updatedUser);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isFollowing
                  ? 'Unfollowed ${_user!.username}'
                  : AppLocalizations.of(context)!.followed,
            ),
          ),
        );
      }

      // Update following status
      if (mounted) {
        setState(() => _isFollowing = !_isFollowing);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Follow status updated!')));
      }
    } catch (e) {
      print(' Error toggling follow: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating follow status')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _errorMessage!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _loadUser, child: Text('Try Again')),
            ],
          ),
        ),
      );
    }

    if (_user == null) return const SizedBox();

    final user = _user!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          /// ================= SLIVER APP BAR =================
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
                onPressed: () => _showOptionsMenu(context),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.1),
                      Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: 0.9),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),

                      /// Enhanced Avatar
                      _buildEnhancedAvatar(user),

                      const SizedBox(height: 16),

                      /// Username
                      Text(
                        user.username,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyLarge!.color,
                            ),
                      ),

                      const SizedBox(height: 8),

                      /// Bio
                      if (user.bio?.isNotEmpty == true)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            user.bio!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[600]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// ================= STATS ROW =================
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatItem(title: 'Posts', value: '${_posts.length}'),
                  _VerticalDivider(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FollowListScreen(
                            userId: user.uid!,
                            isFollowers: true,
                          ),
                        ),
                      );
                    },
                    child: _StatItem(
                      title: 'Followers',
                      value: '${user.followersCount}',
                    ),
                  ),
                  _VerticalDivider(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FollowListScreen(
                            userId: user.uid!,
                            isFollowers: false,
                          ),
                        ),
                      );
                    },
                    child: _StatItem(
                      title: 'Following',
                      value: '${user.followingCount}',
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// ================= RANK & POINTS CARDS =================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _RankCard(
                      rank: (user.level is int) ? user.level as int : 1,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: _PointsCard(points: user.points)),
                ],
              ),
            ),
          ),

          /// ================= ACTION BUTTONS =================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _toggleFollow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isFollowing
                            ? Colors.grey[300]
                            : AppColors.primary,
                        foregroundColor: _isFollowing
                            ? Colors.black87
                            : Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      icon: Icon(
                        _isFollowing ? Icons.person_remove : Icons.person_add,
                        size: 20,
                      ),
                      label: Text(
                        _isFollowing
                            ? AppLocalizations.of(context)!.followed
                            : AppLocalizations.of(context)!.follow,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          /// ================= PHOTO GRID =================
          _posts.isEmpty
              ? SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.photo_library_outlined,
                          size: 64,
                          color: Colors.grey.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.noPosts,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.all(1),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final post = _posts[index];
                      final imageUrl = post.images.isNotEmpty
                          ? post.images.first
                          : '';
                      return GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PostDetailScreen(post: post.toFirestore()),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                image: imageUrl.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(imageUrl),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                                color: imageUrl.isEmpty
                                    ? Colors.grey.withValues(alpha: 0.3)
                                    : null,
                              ),
                              child: imageUrl.isEmpty
                                  ? const Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey,
                                        size: 32,
                                      ),
                                    )
                                  : null,
                            ),
                            // Likes count overlay
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${post.likesCount}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }, childCount: _posts.length),
                  ),
                ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  /// Build enhanced avatar with fallback
  Widget _buildEnhancedAvatar(User user) {
    final avatar = user.profileImage ?? '';
    final username = user.username;

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 48,
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
        child: avatar.isEmpty
            ? Text(
                username.isNotEmpty ? username[0].toUpperCase() : 'U',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              )
            : null,
      ),
    );
  }

  /// Show options menu
  void _showOptionsMenu(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(
              _isFollowing ? Icons.person_remove : Icons.person_add,
            ),
            title: Text(_isFollowing ? l10n.followed : l10n.follow),
            onTap: () {
              Navigator.pop(context);
              _handleFollowAction();
            },
          ),
          ListTile(
            leading: const Icon(Icons.share_outlined),
            title: Text(l10n.shareProfile),
            onTap: () async {
              Navigator.pop(context);
              final shareText =
                  'Check out @${_user!.username} on Ate!\n\nBio: ${_user!.bio}';
              await Clipboard.setData(ClipboardData(text: shareText));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile link copied to clipboard!'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Handle follow/unfollow action
  Future<void> _handleFollowAction() async {
    await _toggleFollow();
  }
}

/// ================= HELPER WIDGETS =================

class _StatItem extends StatelessWidget {
  final String title;
  final String value;

  const _StatItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.withValues(alpha: 0.3),
    );
  }
}

class _RankCard extends StatelessWidget {
  final int rank;

  const _RankCard({required this.rank});

  @override
  Widget build(BuildContext context) {
    final level = _getRankLevel(rank);
    final progress = _getLevelProgress(level);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.stars, color: Colors.amber),
              SizedBox(width: 6),
              Text('RANK', style: TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            level,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
          ),
        ],
      ),
    );
  }

  String _getRankLevel(int rank) {
    if (rank <= 10) return 'Bronze';
    if (rank <= 25) return 'Silver';
    if (rank <= 50) return 'Gold';
    return 'Platinum';
  }

  double _getLevelProgress(String level) {
    switch (level.toLowerCase()) {
      case 'bronze':
        return 0.25;
      case 'silver':
        return 0.5;
      case 'gold':
        return 0.75;
      case 'platinum':
        return 1.0;
      default:
        return 0.1;
    }
  }
}

class _PointsCard extends StatelessWidget {
  final int points;

  const _PointsCard({required this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.emoji_events, color: AppColors.primary),
              const SizedBox(width: 6),
              const Text(
                'POINTS',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            points.toString(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'User points',
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
