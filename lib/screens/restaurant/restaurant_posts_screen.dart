import 'package:flutter/material.dart';
import '../../models/post.dart';
import '../../repositories/post_repository.dart';
import '../../utils/constants.dart';
import '../../l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../home/post_detail_screen.dart';
import '../../repositories/auth_repository.dart';
import '../home/navigation_shell.dart';
import '../profile/other_user_profile_screen.dart';

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
            'Error: $_error',
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
      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
      itemBuilder: (context, index) {
        final post = _posts[index];
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
                      : const CircleAvatar(child: Icon(Icons.person)),
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
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetailScreen(post: post.toFirestore()),
                      ),
                    );
                    _loadPosts(); // Refresh on return
                  },
                  child: Container(
                    height: 200,
                    color: AppColors.backgroundLight,
                    child: Image.network(
                      post.images.first,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (post.dishName != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppSizes.borderRadiusSm),
                        ),
                        child: Text(
                          post.dishName!,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
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
                          onPressed: () {}, // Interaction logic can be added/reused
                        ),
                        Text('${post.likesCount}', style: AppTextStyles.body),
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
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
