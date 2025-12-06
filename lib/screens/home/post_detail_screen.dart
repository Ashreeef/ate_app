import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ate_app/utils/constants.dart';
import '../../l10n/app_localizations.dart';
import '../../models/comment.dart';
import '../../repositories/comment_repository.dart';
import '../../repositories/profile_repository.dart';
import '../../repositories/post_repository.dart';
import '../../services/auth_service.dart';
import '../restaurant/restaurant_page.dart';

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
  final ProfileRepository _profileRepo = ProfileRepository();
  final PostRepository _postRepo = PostRepository();

  @override
  void initState() {
    super.initState();
    _post = Map.from(widget.post);
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final currentUserId = AuthService.instance.currentUserId ?? 1;
    final postId = _post['id'] as int?;

    if (postId != null) {
      // Load the full post from database to get accurate like/save status
      final post = await _postRepo.getPostById(postId);
      if (post != null) {
        setState(() {
          _isLiked = post.likedBy.contains(currentUserId);
          _isSaved = post.savedBy.contains(currentUserId);
          _post['likes_count'] = post.likesCount;
          _post['comments_count'] = post.commentsCount;
        });
      }
    }

    await _loadComments();
  }

  Future<void> _loadComments() async {
    setState(() => _isLoadingComments = true);

    try {
      final postId = _post['id'] as int?;
      if (postId == null) {
        setState(() => _isLoadingComments = false);
        return;
      }

      final comments = await _commentRepo.getCommentsByPostId(postId);
      final List<Map<String, dynamic>> commentsWithUser = [];

      for (final comment in comments) {
        final user = await _profileRepo.getUserById(comment.userId);
        commentsWithUser.add({
          'id': comment.id,
          'userId': comment.userId,
          'username': user?.username ?? 'Unknown',
          'userAvatar': user?.profileImage,
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
    if (_commentController.text.trim().isEmpty) return;

    final currentUserId = AuthService.instance.currentUserId ?? 1;
    final postId = _post['id'] as int?;

    if (postId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot add comment to this post')),
      );
      return;
    }

    try {
      // Create comment in database
      final comment = Comment(
        postId: postId,
        userId: currentUserId,
        content: _commentController.text.trim(),
        createdAt: DateTime.now().toIso8601String(),
      );

      await _commentRepo.createComment(comment);

      // Update post comments count
      final post = await _postRepo.getPostById(postId);
      if (post != null) {
        final updatedPost = post.copyWith(
          commentsCount: post.commentsCount + 1,
        );
        await _postRepo.updatePost(updatedPost);
      }

      // Clear input and reload comments
      _commentController.clear();
      FocusScope.of(context).unfocus();
      await _loadComments();

      // Update local post data
      setState(() {
        _post['comments_count'] = (_post['comments_count'] ?? 0) + 1;
      });
    } catch (e) {
      print('Error adding comment: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add comment')));
    }
  }

  Future<void> _toggleLike() async {
    final currentUserId = AuthService.instance.currentUserId ?? 1;
    final postId = _post['id'] as int?;

    if (postId == null) return;

    try {
      final post = await _postRepo.getPostById(postId);
      if (post == null) return;

      // Optimistically update UI
      setState(() {
        _isLiked = !_isLiked;
        _post['likes_count'] =
            (_post['likes_count'] ?? 0) + (_isLiked ? 1 : -1);
      });

      // Update database
      List<int> likedBy = List.from(post.likedBy);
      if (_isLiked) {
        if (!likedBy.contains(currentUserId)) {
          likedBy.add(currentUserId);
        }
      } else {
        likedBy.remove(currentUserId);
      }

      final updatedPost = post.copyWith(
        likedBy: likedBy,
        likesCount: likedBy.length,
      );
      await _postRepo.updatePost(updatedPost);
    } catch (e) {
      print('Error toggling like: $e');
      // Revert on error
      setState(() {
        _isLiked = !_isLiked;
        _post['likes_count'] =
            (_post['likes_count'] ?? 0) + (_isLiked ? 1 : -1);
      });
    }
  }

  Future<void> _toggleSave() async {
    final currentUserId = AuthService.instance.currentUserId ?? 1;
    final postId = _post['id'] as int?;

    if (postId == null) return;

    try {
      final post = await _postRepo.getPostById(postId);
      if (post == null) return;

      // Optimistically update UI
      setState(() {
        _isSaved = !_isSaved;
      });

      // Update database
      List<int> savedBy = List.from(post.savedBy);
      if (_isSaved) {
        if (!savedBy.contains(currentUserId)) {
          savedBy.add(currentUserId);
        }
      } else {
        savedBy.remove(currentUserId);
      }

      final updatedPost = post.copyWith(savedBy: savedBy);
      await _postRepo.updatePost(updatedPost);
    } catch (e) {
      print('Error toggling save: $e');
      // Revert on error
      setState(() {
        _isSaved = !_isSaved;
      });
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
        title: Text(l10n.post, style: AppTextStyles.heading3),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: AppColors.textDark,
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
                    color: AppColors.white,
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
    final restaurantId = _post['restaurantId'] as int?;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          CircleAvatar(
            radius: AppSizes.avatar / 2,
            backgroundColor: AppColors.background,
            child: _post['userAvatar'] != null && _post['userAvatar'].isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      _post['userAvatar'],
                      fit: BoxFit.cover,
                      width: AppSizes.avatar,
                      height: AppSizes.avatar,
                    ),
                  )
                : Icon(
                    Icons.person,
                    color: AppColors.textMedium,
                    size: AppSizes.icon,
                  ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _post['userName'] ?? 'Unknown User',
                  style: AppTextStyles.username,
                ),
                if (_post['restaurantName'] != null)
                  GestureDetector(
                    onTap: () {
                      if (restaurantId != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RestaurantPage(restaurantId: restaurantId),
                          ),
                        );
                      }
                    },
                    child: Text(
                      _post['restaurantName'],
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMedium,
                        decoration: restaurantId != null
                            ? TextDecoration.underline
                            : null,
                      ),
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
        color: AppColors.background,
        child: Center(
          child: Icon(
            Icons.image_not_supported,
            color: AppColors.textMedium,
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
                  color: AppColors.background,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                      color: AppColors.primary,
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
              color: _isLiked ? AppColors.primary : AppColors.textDark,
              size: AppSizes.icon,
            ),
            onPressed: _toggleLike,
          ),
          IconButton(
            icon: Icon(
              Icons.comment_outlined,
              color: AppColors.textDark,
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
              color: _isSaved ? AppColors.primary : AppColors.textDark,
              size: AppSizes.icon,
            ),
            onPressed: _toggleSave,
          ),
        ],
      ),
    );
  }

  Widget _buildLikesCount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Text(
        '${_post['likes_count'] ?? 0} likes',
        style: AppTextStyles.captionBold,
      ),
    );
  }

  Widget _buildCaption() {
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
              text: '${_post['username'] ?? 'Unknown'} ',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            TextSpan(text: _post['caption'] ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_post['dish_name'] != null)
            Text(
              _post['dish_name'],
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
            ),
          const SizedBox(height: AppSpacing.xs),
          if (_post['rating'] != null)
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: AppColors.starActive,
                  size: AppSizes.icon,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '${_post['rating']}.0',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
        ],
      ),
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
        color: AppColors.white,
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
      color: AppColors.white,
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
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(
                    'No comments yet. Be the first to comment!',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textMedium,
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
                        CircleAvatar(
                          radius: AppSizes.avatarSm / 2,
                          backgroundColor: AppColors.background,
                          backgroundImage: comment['userAvatar'] != null
                              ? NetworkImage(comment['userAvatar'])
                              : null,
                          child: comment['userAvatar'] == null
                              ? Icon(
                                  Icons.person,
                                  size: AppSizes.iconXs,
                                  color: AppColors.textMedium,
                                )
                              : null,
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
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                    TextSpan(
                                      text: comment['text'],
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textDark,
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
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: AppSizes.avatarSm / 2,
            backgroundColor: AppColors.background,
            child: Icon(
              Icons.person,
              size: AppSizes.iconXs,
              color: AppColors.textMedium,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.addComment,
                hintStyle: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textMedium,
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
              color: AppColors.primary,
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
        return SizedBox(
          height: 180,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.flag_outlined, color: AppColors.textDark),
                title: Text(l10n.report, style: AppTextStyles.bodyMedium),
                onTap: () {
                  Navigator.pop(context);
                  // Implement report logic
                },
              ),
              ListTile(
                leading: Icon(Icons.link, color: AppColors.textDark),
                title: Text(l10n.copyLink, style: AppTextStyles.bodyMedium),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        l10n.linkCopied,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      backgroundColor: AppColors.textDark,
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
                leading: Icon(Icons.close, color: AppColors.textDark),
                title: Text(l10n.cancel, style: AppTextStyles.bodyMedium),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
