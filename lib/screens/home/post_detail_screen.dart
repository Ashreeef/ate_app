import 'package:flutter/material.dart';
import 'package:ate_app/utils/constants.dart';

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

  @override
  void initState() {
    super.initState();
    _post = Map.from(widget.post);
    _isLiked = _post['isLiked'] ?? false;
    _isSaved = _post['isSaved'] ?? false;
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _post['isLiked'] = _isLiked;
      _post['likes'] = (_post['likes'] ?? 0) + (_isLiked ? 1 : -1);
    });
  }

  void _toggleSave() {
    setState(() {
      _isSaved = !_isSaved;
      _post['isSaved'] = _isSaved;
    });
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;

    final newComment = {
      'user': '@you', // Placeholder - would be current user in real app
      'text': _commentController.text.trim(),
    };

    setState(() {
      if (_post['comments'] == null) {
        _post['comments'] = [];
      }
      _post['comments'].insert(0, newComment);
      _commentController.clear();
    });

    // Hide keyboard
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text('Post', style: AppTextStyles.heading3),
        actions: [
          IconButton(
            icon: Icon(
              Icons.share_outlined,
              color: AppColors.textDark,
              size: AppSizes.icon,
            ),
            onPressed: _sharePost,
          ),
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
                  Text(
                    _post['restaurantName'],
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMedium,
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
    return SizedBox(
      width: double.infinity,
      height: 400,
      child: Image.network(
        _post['imageUrl'],
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
                  'Échec du chargement de l\'image',
                  style: AppTextStyles.caption,
                ),
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
          IconButton(
            icon: Icon(
              Icons.share_outlined,
              color: AppColors.textDark,
              size: AppSizes.icon,
            ),
            onPressed: _sharePost,
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
        '${_post['likes'] ?? 0} likes',
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
              text: '${_post['userName']} ',
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
          if (_post['dishName'] != null)
            Text(
              _post['dishName'],
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
    final comments = _post['comments'] as List<dynamic>? ?? [];

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
            if (comments.isNotEmpty)
              Text('Commentaires', style: AppTextStyles.heading4),
            const SizedBox(height: AppSpacing.md),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: AppTextStyles.bodySmall,
                                children: [
                                  TextSpan(
                                    text: '${comment['user']} ',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  TextSpan(text: comment['text']),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            const Text(
                              'Il y a 2 heures', // Placeholder
                              style: AppTextStyles.timestamp,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.favorite_border,
                          size: AppSizes.iconXs,
                          color: AppColors.textMedium,
                        ),
                        onPressed: () {},
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
                hintText: 'Add a comment...',
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

  void _sharePost() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
        ),
        title: Text('Partager le post', style: AppTextStyles.heading3),
        content: Text(
          'La fonctionnalité de partage sera implémentée ici.',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: AppTextStyles.link),
          ),
        ],
      ),
    );
  }

  void _showOptions() {
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
                title: Text('Signaler', style: AppTextStyles.bodyMedium),
                onTap: () {
                  Navigator.pop(context);
                  // Implement report logic
                },
              ),
              ListTile(
                leading: Icon(Icons.link, color: AppColors.textDark),
                title: Text('Copier le lien', style: AppTextStyles.bodyMedium),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Lien copié dans le presse-papiers',
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
                title: Text('Annuler', style: AppTextStyles.bodyMedium),
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
