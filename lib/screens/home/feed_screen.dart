import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ate_app/utils/constants.dart';
import '../../widgets/feed/feed_header.dart';
import '../../blocs/feed/feed_bloc.dart';
import '../../blocs/feed/feed_event.dart';
import '../../blocs/feed/feed_state.dart';
import '../../models/post.dart';
import '../../services/error_service.dart';
import 'package:ate_app/repositories/post_repository.dart';
import 'package:ate_app/repositories/like_repository.dart';
import 'package:ate_app/repositories/saved_post_repository.dart';
import 'package:ate_app/repositories/auth_repository.dart';
import 'package:ate_app/l10n/app_localizations.dart';
import 'post_likes_screen.dart';
import 'post_detail_screen.dart';
import 'package:ate_app/screens/profile/other_user_profile_screen.dart';
import 'package:ate_app/screens/home/navigation_shell.dart';
import '../restaurant/restaurant_page.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool _isMonFeedSelected = true;
  late ScrollController _scrollController;
  final PostRepository _postRepo = PostRepository();
  final LikeRepository _likeRepo = LikeRepository();
  final SavedPostRepository _savedPostRepo = SavedPostRepository();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    // Load initial posts
    context.read<FeedBloc>().add(const LoadFeed());
  }

  void _onScroll() {
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels != 0) {
      final type = _isMonFeedSelected ? FeedType.global : FeedType.friends;
      context.read<FeedBloc>().add(LoadMoreFeed(type: type));
    }
  }

  // Simulate refreshing the feed
  Future<void> _onRefresh() async {
    final type = _isMonFeedSelected ? FeedType.global : FeedType.friends;
    context.read<FeedBloc>().add(LoadFeed(refresh: true, type: type));
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          FeedHeader(
            isMonFeedSelected: _isMonFeedSelected,
            onMonFeedTap: () {
              if (!_isMonFeedSelected) {
                setState(() => _isMonFeedSelected = true);
                context.read<FeedBloc>().add(const LoadFeed(type: FeedType.global));
              }
            },
            onMesAmisTap: () {
              if (_isMonFeedSelected) {
                setState(() => _isMonFeedSelected = false);
                context.read<FeedBloc>().add(const LoadFeed(type: FeedType.friends));
              }
            },
          ),
          Expanded(
            child: BlocBuilder<FeedBloc, FeedState>(
              builder: (context, state) {
                final l10n = AppLocalizations.of(context)!;

                if (state is FeedLoading && state is! FeedLoaded) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state is FeedError) {
                  return Center(child: Text('${l10n.error}: ${state.message}'));
                }

                if (state is FeedLoaded) {
                  if (state.posts.isEmpty) {
                    return Center(child: Text(l10n.noPosts));
                  }

                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.all(AppSpacing.md),
                      itemCount: state.posts.length + (state.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.posts.length) {
                          return Center(child: CircularProgressIndicator());
                        }
                        final post = state.posts[index];
                        return Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 600),
                            child: _buildPostCard(post),
                          ),
                        );
                      },
                    ),
                  );
                }

                return Center(child: Text(l10n.noPostsAvailable));
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleLike(Post post) async {
    // Use Firestore UID instead of int ID
    final postId = post.postId;

    if (postId == null) return;

    try {
      final fullPost = await _postRepo.getPostById(postId);
      if (fullPost == null) return;

      // Use LikeRepository to toggle like
      // Get current user UID from AuthRepository
      final currentUserUid = context.read<AuthRepository>().currentUserId;
      if (currentUserUid == null) return;

      final isLiked = fullPost.likedByUids.contains(currentUserUid);
      if (isLiked) {
        await _likeRepo.unlikePost(postId, currentUserUid);
      } else {
        await _likeRepo.likePost(postId, currentUserUid);
      }

      // Refresh feed
      context.read<FeedBloc>().add(const LoadFeed());
    } catch (e, stackTrace) {
      ErrorService().logError(e, stackTrace, context: 'FeedScreen._toggleLike');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update like')));
    }
  }

  Future<void> _toggleSave(Post post) async {
    // Use Firestore UID instead of int ID
    final postId = post.postId;

    if (postId == null) return;

    try {
      final fullPost = await _postRepo.getPostById(postId);
      if (fullPost == null) return;

      // Use SavedPostRepository to toggle save
      // Get current user UID from AuthRepository
      final currentUserUid = context.read<AuthRepository>().currentUserId;
      if (currentUserUid == null) return;

      final isSaved = fullPost.savedByUids.contains(currentUserUid);
      if (isSaved) {
        await _savedPostRepo.unsavePost(postId, currentUserUid);
      } else {
        await _savedPostRepo.savePost(postId, currentUserUid);
      }

      // Refresh feed
      context.read<FeedBloc>().add(const LoadFeed());
    } catch (e, stackTrace) {
      ErrorService().logError(e, stackTrace, context: 'FeedScreen._toggleSave');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update save')));
    }
  }

  Widget _buildPostCard(Post post) {
    // Use Firestore UIDs for like/save status
    final currentUserUid = context.read<AuthRepository>().currentUserId;
    final isLiked = currentUserUid != null && post.likedByUids.contains(currentUserUid);
    final isSaved = currentUserUid != null && post.savedByUids.contains(currentUserUid);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: GestureDetector(
              onTap: () {
                if (post.userUid == currentUserUid) {
                  NavigationShell.selectTab(context, 4);
                } else if (post.userUid != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          OtherUserProfileScreen(userId: post.userUid!),
                    ),
                  );
                }
              },
              child: post.userAvatarUrl != null && post.userAvatarUrl!.isNotEmpty
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(post.userAvatarUrl!),
                    )
                  : (post.userAvatarPath != null
                      ? CircleAvatar(
                          backgroundImage: FileImage(File(post.userAvatarPath!)),
                        )
                      : const CircleAvatar(child: Icon(Icons.person))),
            ),
            title: GestureDetector(
              onTap: () {
                if (post.userUid == currentUserUid) {
                  NavigationShell.selectTab(context, 4);
                } else if (post.userUid != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          OtherUserProfileScreen(userId: post.userUid!),
                    ),
                  );
                }
              },
              child: Text(
                post.username,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            subtitle: Text(post.createdAt.toLocal().toString().split('.')[0]),
          ),
          if (post.images.isNotEmpty)
            GestureDetector(
              onTap: () async {
                // Navigate to detail screen and refresh feed on return
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailScreen(post: post.toFirestore()),
                  ),
                );
                if (mounted) {
                  context.read<FeedBloc>().add(const RefreshFeed());
                }
              },
              child: Container(
                height: 200,
                color: AppColors.backgroundLight,
                child: PageView(
                  children: post.images
                      .map(
                        (imageUrl) => Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.broken_image, color: Colors.grey),
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post.restaurantName != null && post.restaurantUid != null)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RestaurantPage(restaurantId: post.restaurantUid!),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSizes.borderRadiusSm),
                      ),
                      child: Text(
                        '${post.restaurantName}${post.dishName != null ? " • ${post.dishName}" : ""}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                else if (post.restaurantName != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.textLight.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusSm),
                    ),
                    child: Text(
                      '${post.restaurantName}${post.dishName != null ? " • ${post.dishName}" : ""}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMedium,
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.sm),
                Text(post.caption, style: AppTextStyles.body),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : AppColors.textMedium,
                      ),
                      onPressed: () => _toggleLike(post),
                    ),
                    GestureDetector(
                      onTap: post.postId != null
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PostLikesScreen(postId: post.postId!),
                                ),
                              );
                            }
                          : null,
                      child: Text('${post.likesCount}', style: AppTextStyles.body),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    IconButton(
                      icon: const Icon(
                        Icons.chat_bubble_outline,
                        color: AppColors.textMedium,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PostDetailScreen(post: post.toFirestore()),
                          ),
                        );
                      },
                    ),
                    Text('${post.commentsCount}', style: AppTextStyles.body),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: isSaved ? AppColors.primary : AppColors.textMedium,
                  ),
                  onPressed: () => _toggleSave(post),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
