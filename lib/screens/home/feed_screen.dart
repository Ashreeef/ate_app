import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ate_app/utils/constants.dart';
import '../../widgets/feed/feed_header.dart';
import '../../blocs/feed/feed_bloc.dart';
import '../../blocs/feed/feed_event.dart';
import '../../blocs/feed/feed_state.dart';
import '../../blocs/post/post_bloc.dart';
import '../../blocs/post/post_event.dart';
import '../../models/post.dart';
import '../../services/auth_service.dart';
import '../../l10n/app_localizations.dart';
import 'post_detail_screen.dart';
import '../profile/other_user_profile_screen.dart';
import '../restaurant/restaurant_page.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool _isMonFeedSelected = true;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    // Load initial posts
    context.read<FeedBloc>().add(LoadFeed());
  }

  void _onScroll() {
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels != 0) {
      context.read<FeedBloc>().add(LoadMoreFeed());
    }
  }

  // Simulate refreshing the feed
  Future<void> _onRefresh() async {
    context.read<FeedBloc>().add(LoadFeed(refresh: true));
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
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          FeedHeader(
            isMonFeedSelected: _isMonFeedSelected,
            onMonFeedTap: () => setState(() => _isMonFeedSelected = true),
            onMesAmisTap: () => setState(() => _isMonFeedSelected = false),
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

  Widget _buildPostCard(Post post) {
    final currentUserId = AuthService.instance.currentUserId ?? 1;
    final isLiked = post.likedBy.contains(currentUserId);
    final isSaved = post.savedBy.contains(currentUserId);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        OtherUserProfileScreen(userId: post.userId),
                  ),
                );
              },
              child: post.userAvatarPath != null
                  ? CircleAvatar(
                      backgroundImage: FileImage(File(post.userAvatarPath!)),
                    )
                  : CircleAvatar(child: Icon(Icons.person)),
            ),
            title: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        OtherUserProfileScreen(userId: post.userId),
                  ),
                );
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailScreen(post: post.toMap()),
                  ),
                );
              },
              child: Container(
                height: 200,
                color: AppColors.backgroundLight,
                child: PageView(
                  children: post.images
                      .map(
                        (imagePath) => Image.file(
                          File(imagePath),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(Icons.image_not_supported),
                            );
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post.dishName != null)
                  Text(
                    '${AppLocalizations.of(context)!.dish}: ${post.dishName}',
                    style: AppTextStyles.caption,
                  ),
                if (post.restaurantName != null && post.restaurantId != null)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RestaurantPage(restaurantId: post.restaurantId!),
                        ),
                      );
                    },
                    child: Text(
                      '${AppLocalizations.of(context)!.restaurant}: ${post.restaurantName}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                if (post.restaurantName != null && post.restaurantId == null)
                  Text(
                    '${AppLocalizations.of(context)!.restaurant}: ${post.restaurantName}',
                    style: AppTextStyles.caption,
                  ),
                if (post.rating != null)
                  Text(
                    '${AppLocalizations.of(context)!.rating}: ${post.rating}/5',
                    style: AppTextStyles.caption,
                  ),
                SizedBox(height: AppSpacing.sm),
                Text(post.caption, style: AppTextStyles.body),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
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
                      onPressed: () {
                        context.read<PostBloc>().add(
                          ToggleLikeEvent(post.id!, currentUserId),
                        );
                      },
                    ),
                    Text('${post.likesCount}', style: AppTextStyles.body),
                    SizedBox(width: AppSpacing.sm),
                    IconButton(
                      icon: Icon(
                        Icons.chat_bubble_outline,
                        color: AppColors.textMedium,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PostDetailScreen(post: post.toMap()),
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
                  onPressed: () {
                    context.read<PostBloc>().add(
                      ToggleSaveEvent(post.id!, currentUserId),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
