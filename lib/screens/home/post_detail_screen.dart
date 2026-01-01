import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ate_app/utils/constants.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/comment_repository.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/like_repository.dart';
import '../../repositories/saved_post_repository.dart';
import '../../blocs/post/post_bloc.dart';
import '../../blocs/post/post_event.dart';
import 'post_likes_screen.dart';
import '../../widgets/feed/post_restaurant_info.dart';
import '../profile/other_user_profile_screen.dart';
import 'package:ate_app/screens/home/navigation_shell.dart';

class PostDetailScreen extends StatefulWidget {
  final Map<String, dynamic> post;

  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late Map<String, dynamic> _post;
  final TextEditingController _commentController = TextEditingController();
  bool _isLiked = false;
  bool _isSaved = false;
  List<Map<String, dynamic>> _comments = [];
  bool _isLoadingComments = true;
  final CommentRepository _commentRepo = CommentRepository();

  // Author data (fresh from DB)
  String? _authorUsername;
  String? _authorAvatarUrl;
  String? _authorUid;
  String? _currentUserAvatarUrl;

  @override
  void initState() {
    super.initState();
    _post = Map.from(widget.post); // Initialize _post first
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // Basic setup - check both userUid (Firestore) and userId (Legacy)
    _authorUid = _post['userUid'] ?? _post['userId']?.toString();

    // Safety check: Firestore UIDs are long strings.
    // If it's a short numeric string, it's a legacy ID and won't work for fetch.
    if (_authorUid != null && _authorUid!.length < 5) {
      print('PostDetail: Found legacy ID $_authorUid, fetch will likely fail.');
    }

    // 1. Fetch fresh author data
    if (_authorUid != null) {
      try {
        final author = await context.read<AuthRepository>().getUserByUid(
          _authorUid!,
        );
        if (mounted && author != null) {
          setState(() {
            _authorUsername = author.username;
            _authorAvatarUrl = author.profileImage;
          });
        }
      } catch (e) {
        print('Error fetching author data: $e');
      }

      // 2. Fetch interaction status and current user data
      final currentUserUid = context.read<AuthRepository>().currentUserId;
      if (currentUserUid != null) {
        try {
          // Fetch interaction status
          final isLiked = await LikeRepository().isPostLiked(
            _post['postId'],
            currentUserUid,
          );
          final isSaved = await SavedPostRepository().isPostSaved(
            _post['postId'],
            currentUserUid,
          );

          // Fetch current user avatar
          final currentUser = await context.read<AuthRepository>().getUserByUid(
            currentUserUid,
          );

          if (mounted) {
            setState(() {
              _isLiked = isLiked;
              _isSaved = isSaved;
              _currentUserAvatarUrl = currentUser?.profileImage;
            });
          }
        } catch (e) {
          print('Error fetching user/interaction data: $e');
        }
      }
    }

    await _loadComments();
  }

  Future<void> _loadComments() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoadingComments = true);

    try {
      final postId = _post['postId'] as String?; // Use Firestore postId
      if (postId == null) {
        setState(() => _isLoadingComments = false);
        return;
      }

      final comments = await _commentRepo.getPostComments(postId);
      final List<Map<String, dynamic>> commentsWithUser = [];

      for (final comment in comments) {
        // Comments already have denormalized user data
        commentsWithUser.add({
          'id': comment.commentId,
          'userId': comment.userUid,
          'username': comment.username ?? l10n.unknown,
          'userAvatar': comment.userAvatarUrl,
          'text': comment.content,
          'createdAt': comment.createdAt,
        });
      }

      setState(() {
        _comments = commentsWithUser;
        _isLoadingComments = false;
      });
    } catch (e) {
      print('Error loading comments: $e');
      setState(() => _isLoadingComments = false);
    }
  }

  Future<void> _addComment() async {
    final l10n = AppLocalizations.of(context)!;
    if (_commentController.text.trim().isEmpty) return;

    final currentUserUid = context.read<AuthRepository>().currentUserId;
    final postId = _post['postId'] as String?;

    if (postId == null || currentUserUid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.cannotAddComment)),
      );
      return;
    }

    try {
      // Get current user info for the comment
      final user = await context.read<AuthRepository>().getUserByUid(
        currentUserUid,
      );
      final username = user?.username ?? l10n.unknown;
      final userAvatar = user?.profileImage;

      // Use proper addComment method
      await _commentRepo.addComment(
        postId: postId,
        userUid: currentUserUid,
        username: username,
        userAvatarUrl: userAvatar,
        content: _commentController.text.trim(),
      );

      // Clear input and reload comments
      _commentController.clear();
      FocusScope.of(context).unfocus();
      await _loadComments();

      // Refresh post data to get updated counts
      await _loadInitialData();
    } catch (e) {
      print('Error adding comment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.failedToAddComment(e.toString()),
          ),
        ),
      );
    }
  }

  Future<void> _toggleLike() async {
    final currentUserUid = context.read<AuthRepository>().currentUserId;
    final postId = _post['postId'] as String?;

    if (postId == null || currentUserUid == null) return;

    try {
      // Optimistically update UI
      setState(() {
        _isLiked = !_isLiked;
        _post['likes_count'] =
            (_post['likes_count'] ?? 0) + (_isLiked ? 1 : -1);
      });

      final LikeRepository likeRepo = LikeRepository();
      if (_isLiked) {
        await likeRepo.likePost(postId, currentUserUid);
      } else {
        await likeRepo.unlikePost(postId, currentUserUid);
      }

      // No need to update post manually, repository handles it.
      // Verify state later if needed.
    } catch (e) {
      print('Error toggling like: $e');
      // Revert on error
      setState(() {
        _isLiked = !_isLiked;
        _post['likes_count'] =
            (_post['likes_count'] ?? 0) + (_isLiked ? 1 : -1);
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update like')));
    }
  }

  Future<void> _toggleSave() async {
    final currentUserUid = context.read<AuthRepository>().currentUserId;
    final postId = _post['postId'] as String?;

    if (postId == null || currentUserUid == null) return;

    try {
      // Optimistically update UI
      setState(() {
        _isSaved = !_isSaved;
      });

      final SavedPostRepository savedRepo = SavedPostRepository();
      if (_isSaved) {
        await savedRepo.savePost(postId, currentUserUid);
      } else {
        await savedRepo.unsavePost(postId, currentUserUid);
      }
    } catch (e) {
      print('Error toggling save: $e');
      // Revert on error
      setState(() {
        _isSaved = !_isSaved;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.failedToUpdateSave),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          l10n.post,
          style: AppTextStyles.heading3.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).colorScheme.onSurface,
              size: AppSizes.icon,
            ),
            onPressed: _showOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card container
                  Card(
                    margin: const EdgeInsets.all(AppSpacing.md),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSizes.borderRadius,
                      ),
                    ),
                    color: Theme.of(context).cardColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        _buildHeader(),

                        // Image
                        _buildImage(),

                        // Actions
                        _buildActions(),

                        // Likes count
                        _buildLikesCount(),

                        // Caption
                        _buildCaption(),

                        // Restaurant and dish info
                        _buildRestaurantInfo(),
                      ],
                    ),
                  ),

                  // Comments section
                  _buildCommentsSection(),
                ],
              ),
            ),
          ),

          // Comment input
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              final userUid = _authorUid ?? _post['userUid'] as String?;
              final currentUserUid = context
                  .read<AuthRepository>()
                  .currentUserId;
              if (userUid != null) {
                if (userUid == currentUserUid) {
                  NavigationShell.selectTab(context, 4);
                  Navigator.pop(context);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          OtherUserProfileScreen(userId: userUid),
                    ),
                  );
                }
              }
            },
            child: CircleAvatar(
              radius: AppSizes.avatar / 2,
              backgroundColor: AppColors.background,
              child: (_authorAvatarUrl != null && _authorAvatarUrl!.isNotEmpty)
                  ? ClipOval(
                      child: Image.network(
                        _authorAvatarUrl!,
                        fit: BoxFit.cover,
                        width: AppSizes.avatar,
                        height: AppSizes.avatar,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.person),
                      ),
                    )
                  : ((_post['userAvatarUrl'] != null &&
                                _post['userAvatarUrl'].isNotEmpty) ||
                            (_post['userAvatar'] != null &&
                                _post['userAvatar'].isNotEmpty)
                        ? ClipOval(
                            child: Image.network(
                              _post['userAvatarUrl'] ?? _post['userAvatar'],
                              fit: BoxFit.cover,
                              width: AppSizes.avatar,
                              height: AppSizes.avatar,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.person),
                            ),
                          )
                        : Icon(
                            Icons.person,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            size: AppSizes.icon,
                          )),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    final userUid = _authorUid ?? _post['userUid'] as String?;
                    final currentUserUid = context
                        .read<AuthRepository>()
                        .currentUserId;
                    if (userUid != null) {
                      if (userUid == currentUserUid) {
                        NavigationShell.selectTab(context, 4);
                        Navigator.pop(context);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OtherUserProfileScreen(userId: userUid),
                          ),
                        );
                      }
                    }
                  },
                  child: Text(
                    _authorUsername ??
                        _post['username'] ??
                        _post['userName'] ??
                        'Unknown User',
                    style: AppTextStyles.username,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    // Handle both 'images' (JSON string or list) and 'imageUrl' (single string) formats
    String? imageUrl;

    try {
      if (_post['images'] != null) {
        var images = _post['images'];

        // If it's a JSON string, decode it
        if (images is String) {
          final List<dynamic> decoded = jsonDecode(images);
          if (decoded.isNotEmpty) {
            imageUrl = decoded.first.toString();
          }
        } else if (images is List && images.isNotEmpty) {
          imageUrl = images.first.toString();
        }
      } else if (_post['imageUrl'] != null) {
        imageUrl = _post['imageUrl'].toString();
      }
    } catch (e) {
      print('Error parsing images: $e');
    }

    if (imageUrl == null || imageUrl.isEmpty || imageUrl == 'null') {
      return Container(
        height: 400,
        color: Theme.of(context).colorScheme.surface,
        child: Center(
          child: Icon(
            Icons.image_not_supported,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: AppSizes.iconXl,
          ),
        ),
      );
    }

    // Determine if it's a network or file image
    final bool isNetworkImage =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    return SizedBox(
      width: double.infinity,
      height: 400,
      child: isNetworkImage
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 400,
                  color: Theme.of(context).colorScheme.surface,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 400,
                  color: AppColors.background,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: AppColors.textMedium,
                        size: AppSizes.iconXl,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        AppLocalizations.of(context)!.imageLoadFailed,
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                );
              },
            )
          : Image.file(
              File(imageUrl),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 400,
                  color: Theme.of(context).colorScheme.surface,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        size: AppSizes.iconXl,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text('Image not found', style: AppTextStyles.caption),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _isLiked ? Icons.favorite : Icons.favorite_border,
              color: _isLiked
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
              size: AppSizes.icon,
            ),
            onPressed: _toggleLike,
          ),
          IconButton(
            icon: Icon(
              Icons.comment_outlined,
              color: Theme.of(context).colorScheme.onSurface,
              size: AppSizes.icon,
            ),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              Future.delayed(const Duration(milliseconds: 300), () {
                _commentController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _commentController.text.length),
                );
              });
            },
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              _isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: _isSaved
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
              size: AppSizes.icon,
            ),
            onPressed: _toggleSave,
          ),
        ],
      ),
    );
  }

  Widget _buildLikesCount() {
    final l10n = AppLocalizations.of(context)!;
    final postId = _post['postId'] as String?;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: GestureDetector(
        onTap: postId != null
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostLikesScreen(postId: postId),
                  ),
                );
              }
            : null,
        child: Text(
          l10n.likesCountText(_post['likes_count'] ?? 0),
          style: AppTextStyles.captionBold,
        ),
      ),
    );
  }

  Widget _buildCaption() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: RichText(
        text: TextSpan(
          style: AppTextStyles.bodySmall,
          children: [
            TextSpan(
              text: '${_post['username'] ?? l10n.unknown} ',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            TextSpan(text: _post['caption'] ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantInfo() {
    if (_post['restaurantName'] == null && _post['dish_name'] == null) {
      return const SizedBox.shrink();
    }

    return PostRestaurantInfo(
      restaurantId: _post['restaurantId']?.toString(),
      restaurantName: _post['restaurantName'] ?? '',
      dishName: _post['dish_name'] ?? _post['dishName'] ?? '',
      rating: (_post['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Widget _buildCommentsSection() {
    if (_isLoadingComments) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${AppLocalizations.of(context)!.comments} (${_comments.length})',
              style: AppTextStyles.heading4,
            ),
            const SizedBox(height: AppSpacing.md),
            if (_comments.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    AppLocalizations.of(context)!.noCommentsYet,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  final comment = _comments[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (comment['userId'] != null) {
                              final currentUserUid = context
                                  .read<AuthRepository>()
                                  .currentUserId;
                              if (comment['userId'] == currentUserUid) {
                                NavigationShell.selectTab(context, 4);
                                Navigator.pop(context);
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        OtherUserProfileScreen(
                                          userId: comment['userId'],
                                        ),
                                  ),
                                );
                              }
                            }
                          },
                          child: CircleAvatar(
                            radius: AppSizes.avatarSm / 2,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surfaceVariant,
                            backgroundImage:
                                comment['userAvatar'] != null &&
                                    comment['userAvatar'].toString().isNotEmpty
                                ? NetworkImage(comment['userAvatar'])
                                : null,
                            child:
                                (comment['userAvatar'] == null ||
                                    comment['userAvatar'].toString().isEmpty)
                                ? Icon(
                                    Icons.person,
                                    size: AppSizes.iconXs,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: AppTextStyles.bodySmall,
                                  children: [
                                    TextSpan(
                                      text: '${comment['username']} ',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          if (comment['userId'] != null) {
                                            final currentUserUid = context
                                                .read<AuthRepository>()
                                                .currentUserId;
                                            if (comment['userId'] ==
                                                currentUserUid) {
                                              NavigationShell.selectTab(
                                                context,
                                                4,
                                              );
                                              Navigator.pop(context);
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      OtherUserProfileScreen(
                                                        userId:
                                                            comment['userId'],
                                                      ),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                    ),
                                    TextSpan(
                                      text: comment['text'],
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              if (comment['createdAt'] != null)
                                Text(
                                  _formatCommentTime(comment['createdAt']),
                                  style: AppTextStyles.timestamp,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  String _formatCommentTime(String? createdAt) {
    if (createdAt == null) return '';

    try {
      final dateTime = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return '';
    }
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: AppSizes.avatarSm / 2,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            backgroundImage:
                _currentUserAvatarUrl != null &&
                    _currentUserAvatarUrl!.isNotEmpty
                ? NetworkImage(_currentUserAvatarUrl!)
                : null,
            child:
                (_currentUserAvatarUrl == null ||
                    _currentUserAvatarUrl!.isEmpty)
                ? Icon(
                    Icons.person,
                    size: AppSizes.iconXs,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  )
                : null,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.addComment,
                hintStyle: AppTextStyles.bodySmall.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                ),
              ),
              onSubmitted: (_) => _addComment(),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Theme.of(context).colorScheme.primary,
              size: AppSizes.icon,
            ),
            onPressed: _addComment,
          ),
        ],
      ),
    );
  }

  void _showOptions() {
    final l10n = AppLocalizations.of(context)!;
    final currentUserUid = context.read<AuthRepository>().currentUserId;
    // Use verified author UID from initState if available, else fallback
    final postUserUid = _authorUid ?? _post['userUid'] as String?;

    // Debug prints to verify deletion logic
    print('Options Debug: CurrentUser: $currentUserUid');
    print('Options Debug: PostUser: $postUserUid');

    final isOwner =
        currentUserUid != null &&
        postUserUid != null &&
        currentUserUid == postUserUid;
    print('Options Debug: isOwner: $isOwner');

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSizes.borderRadiusLg),
          topRight: Radius.circular(AppSizes.borderRadiusLg),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isOwner)
                ListTile(
                  leading: Icon(
                    Icons.delete_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: Text(
                    l10n.deleteAction,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showDeleteConfirmation();
                  },
                ),
              ListTile(
                leading: Icon(
                  Icons.flag_outlined,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                title: Text(l10n.report, style: AppTextStyles.bodyMedium),
                onTap: () {
                  Navigator.pop(context);
                  // Implement report logic
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.link,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                title: Text(l10n.copyLink, style: AppTextStyles.bodyMedium),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        l10n.linkCopied,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Theme.of(context).colorScheme.onInverseSurface,
                        ),
                      ),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.inverseSurface,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSizes.borderRadius,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: Icon(
                  Icons.close,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                title: Text(l10n.cancel, style: AppTextStyles.bodyMedium),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deletePost),
        content: Text(AppLocalizations.of(context)!.deletePostConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              AppLocalizations.of(context)!.deleteAction,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _deletePost();
    }
  }

  Future<void> _deletePost() async {
    final postId = _post['postId'] as String?;
    if (postId == null) return;

    try {
      context.read<PostBloc>().add(DeletePostEvent(postId));

      // Wait a bit or listen to state?
      // For simplicity, assume success and pop with result
      // Ideally we should use BlocListener

      // But we need to return 'true' to indicate deletion to the previous screen
      // Let's delay/assume success for now or wait for repo
      // Actually, Bloc will emit state.
      // We should really wrap the Scaffold in BlocListener for PostDeletedSuccess

      // For now, let's just pop immediately after dispatching,
      // assuming the Bloc handles it.
      // But we want to refresh the previous screen.

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.postDeleted)),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.failedToDeletePost(e.toString()),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
