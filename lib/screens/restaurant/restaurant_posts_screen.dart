import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/post.dart';
import '../../repositories/post_repository.dart';
import '../../utils/constants.dart';
import '../../l10n/app_localizations.dart';
import '../home/post_detail_screen.dart';
import '../../repositories/auth_repository.dart';
import '../home/navigation_shell.dart';
import '../profile/other_user_profile_screen.dart';
import '../../widgets/feed/post_card.dart';

class RestaurantPostsScreen extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;

  const RestaurantPostsScreen({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
  });

  @override
  State<RestaurantPostsScreen> createState() => _RestaurantPostsScreenState();
}

class _RestaurantPostsScreenState extends State<RestaurantPostsScreen> {
  List<Post> _posts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final postRepository = context.read<PostRepository>();
      final posts = await postRepository.getRestaurantPosts(widget.restaurantId);
      setState(() {
        _posts = posts;
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.restaurantName),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Text(
            '${l10n.error}: $_error',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (_posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.post_add_outlined,
              size: 64,
              color: AppColors.textLight,
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              l10n.noPostsYet,
              style: AppTextStyles.heading4.copyWith(color: AppColors.textMedium),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _posts.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final post = _posts[index];
        final currentUserUid = context.read<AuthRepository>().currentUserId ?? '';

        return PostCard(
          post: post,
          currentUserId: currentUserUid,
          onLike: () {
            // Re-use logic or handle locally
            setState(() {
              final isLiked = post.likedByUids.contains(currentUserUid);
              List<String> newLikedByUids = List.from(post.likedByUids);
              int newLikesCount = post.likesCount;

              if (isLiked) {
                newLikedByUids.remove(currentUserUid);
                newLikesCount = newLikesCount > 0 ? newLikesCount - 1 : 0;
              } else {
                newLikedByUids.add(currentUserUid);
                newLikesCount++;
              }
              
              _posts[index] = post.copyWith(
                likedByUids: newLikedByUids,
                likesCount: newLikesCount,
              );
            });
            // TODO: Call repository to persist optionally
          },
          onComment: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostDetailScreen(post: post.toFirestore()),
              ),
            ).then((_) => _loadPosts());
          },
          onShare: () {
            final String shareLink = 'https://ate-app.com/post/${post.id}';
            Share.share('Check out this meal at ${post.restaurantName} on Ate!\n\n$shareLink');
          },
          onSave: () {
            setState(() {
              final isSaved = post.savedByUids.contains(currentUserUid);
              List<String> newSavedByUids = List.from(post.savedByUids);
              
              if (isSaved) {
                newSavedByUids.remove(currentUserUid);
              } else {
                newSavedByUids.add(currentUserUid);
              }

              _posts[index] = post.copyWith(savedByUids: newSavedByUids);
            });
          },
          onProfileTap: () {
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
        );
      },
    );
  }
}
