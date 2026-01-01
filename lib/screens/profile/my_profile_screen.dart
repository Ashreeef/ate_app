import 'package:flutter/material.dart';
import '../../utils/constants.dart' show AppColors;
import '../../l10n/app_localizations.dart';
import '../../data/fake_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/profile/profile_cubit.dart';
import '../../blocs/profile/profile_state.dart';
import '../../models/post.dart';
import '../../repositories/post_repository.dart';
import 'edit_profile_screen.dart';
import '../settings/settings_screen.dart';
import '../home/post_detail_screen.dart';

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
    _initializeProfile();
  }

  @override
  void dispose() {
    // Clear any pending operations
    super.dispose();
  }

  /// Initialize profile data safely
  Future<void> _initializeProfile() async {
    if (!mounted) return;

    try {
      await _loadProfileAndPosts();
    } catch (e) {
      print(' Error initializing profile: $e');
    }
  }

  /// Reload user profile and their posts from database
  Future<void> _loadProfileAndPosts() async {
    if (!mounted) return;

    try {
      // Refresh profile data from database
      final cubit = context.read<ProfileCubit>();
      await cubit.loadProfile();

      if (!mounted) return;

      // Load user's posts
      await _loadPosts();
    } catch (e) {
      print(' Error loading profile and posts: $e');
      if (mounted) {
        setState(() => _isLoadingPosts = false);
      }
    }
  }

  /// Fetch posts for current user from database
  Future<void> _loadPosts() async {
    if (!mounted) return;

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
        print(' Error loading posts: $e');
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
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  elevation: 1,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: Text(
                    l10n.profile,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () => _showOptionsMenu(context),
                    ),
                  ],
                ),
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          );
        }

        final user = state.user;

        // Debug: print user data
        print(' MyProfileScreen - User: ${user?.username}, UID: ${user?.uid}');
        print(
          ' Stats - Followers: ${user?.followersCount}, Points: ${user?.points}',
        );

        final username = user?.username ?? FakeUserData.username;

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: CustomScrollView(
            slivers: [
              /// ================= TOP BAR =================
              SliverAppBar(
                pinned: true,
                elevation: 1,
                backgroundColor: Theme.of(context).colorScheme.surface,
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: Text(
                  '@$username',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () => _showOptionsMenu(context),
                  ),
                ],
              ),

              /// ================= PROFILE HEADER =================
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    _buildEnhancedAvatar(user),
                    const SizedBox(height: 12),
                    Text(
                      user?.displayName ?? username,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${user?.level ?? 'Bronze'} Member ⭐',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    if (user?.bio?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          user!.bio!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              /// ================= STATS =================
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatItem(title: 'Posts', value: '${_posts.length}'),
                      const _VerticalDivider(),
                      _StatItem(
                        title: 'Followers',
                        value: '${user?.followersCount ?? 0}',
                      ),
                      const _VerticalDivider(),
                      _StatItem(
                        title: 'Following',
                        value: '${user?.followingCount ?? 0}',
                      ),
                    ],
                  ),
                ),
              ),

              /// ================= STATUS CARDS =================
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(child: _RankCard(user: user)),
                      const SizedBox(width: 12),
                      Expanded(child: _PointsCard(user: user)),
                    ],
                  ),
                ),
              ),

              /// ================= ACTION BUTTONS =================
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(),
                        ),
                      );
                      _loadProfileAndPosts();
                    },
                    icon: const Icon(Icons.edit),
                    label: Text(l10n.editProfile),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
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
                              color: Colors.grey.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.noPosts,
                              style: const TextStyle(
                                fontSize: 16,
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
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final post = _posts[index];
                          final imageUrl = post.images.isNotEmpty
                              ? post.images[0]
                              : '';
                          return GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostDetailScreen(
                                    post: post.toFirestore(),
                                  ),
                                ),
                              );
                              _loadProfileAndPosts();
                            },
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    image: imageUrl.isNotEmpty
                                        ? DecorationImage(
                                            image: NetworkImage(imageUrl),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                    color: imageUrl.isEmpty
                                        ? Colors.grey.withOpacity(0.3)
                                        : null,
                                  ),
                                  child: imageUrl.isEmpty
                                      ? const Icon(
                                          Icons.image,
                                          color: Colors.grey,
                                        )
                                      : null,
                                ),
                                // Interaction overlay
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.3),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // Like and comment indicators
                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Like indicator with animation
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Simple direct heart animation
                                            AnimatedScale(
                                              scale: post.likesCount > 0
                                                  ? 1.1
                                                  : 1.0,
                                              duration: const Duration(
                                                milliseconds: 100,
                                              ),
                                              child: Icon(
                                                post.likesCount > 0
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: post.likesCount > 0
                                                    ? Colors.red
                                                    : Colors.white,
                                                size: 14,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            AnimatedSwitcher(
                                              duration: const Duration(
                                                milliseconds: 100,
                                              ),
                                              transitionBuilder:
                                                  (child, animation) {
                                                    return ScaleTransition(
                                                      scale: animation,
                                                      child: child,
                                                    );
                                                  },
                                              child: Text(
                                                '${post.likesCount}',
                                                key: ValueKey(post.likesCount),
                                                style: TextStyle(
                                                  color: post.likesCount > 0
                                                      ? Colors.white
                                                      : Colors.white
                                                            .withOpacity(0.8),
                                                  fontSize: 12,
                                                  fontWeight:
                                                      post.likesCount > 0
                                                      ? FontWeight.bold
                                                      : FontWeight.w600,
                                                  shadows: post.likesCount > 0
                                                      ? [
                                                          Shadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                  0.3,
                                                                ),
                                                            blurRadius: 2,
                                                          ),
                                                        ]
                                                      : null,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      // Comment indicator
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.chat_bubble_outline,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${post.commentsCount}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Tap feedback overlay
                                Positioned.fill(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () async {
                                        // Add subtle tap animation
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PostDetailScreen(
                                                  post: post.toFirestore(),
                                                ),
                                          ),
                                        );
                                        _loadProfileAndPosts();
                                      },
                                      splashColor: AppColors.primary
                                          .withOpacity(0.2),
                                      highlightColor: AppColors.primary
                                          .withOpacity(0.1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }, childCount: _posts.length),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 1,
                              crossAxisSpacing: 1,
                            ),
                      ),
                    ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        );
      },
    );
  }

  /// Convert database posts to grid display format (kept for compatibility)

  /// Build enhanced avatar with fallback
  Widget _buildEnhancedAvatar(user) {
    final username = user?.username ?? '';
    final avatarUrl = user?.profileImage ?? '';

    return Stack(
      children: [
        CircleAvatar(
          radius: 56,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: avatarUrl.isNotEmpty
              ? ClipOval(
                  child: Image.network(
                    avatarUrl,
                    width: 112,
                    height: 112,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildDefaultAvatar(username);
                    },
                  ),
                )
              : _buildDefaultAvatar(username),
        ),
      ],
    );
  }

  /// Build default avatar with user initial
  Widget _buildDefaultAvatar(String username) {
    return Container(
      width: 112,
      height: 112,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
      ),
      child: Center(
        child: Text(
          username.isNotEmpty ? username[0].toUpperCase() : '?',
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
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
            leading: const Icon(Icons.settings_outlined),
            title: Text(
              l10n.settingsTitle,
              style: Theme.of(context).textTheme.bodyMedium,
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
            leading: const Icon(Icons.share_outlined),
            title: Text(
              l10n.shareProfile,
              style: Theme.of(context).textTheme.bodyMedium,
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
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(shareText),
                        SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Profile link copied to clipboard!',
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Text('Copy'),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
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
        Text(
          title.toUpperCase(),
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 32, color: Colors.grey.withOpacity(0.3));
  }
}

class _RankCard extends StatelessWidget {
  final user;

  const _RankCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final level = user?.level ?? 'Bronze';
    final progress = _getLevelProgress(level);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
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
  final user;

  const _PointsCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final points = user?.points ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
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
            '+120 this week',
            style: TextStyle(fontSize: 10, color: Colors.green),
          ),
        ],
      ),
    );
  }
}
