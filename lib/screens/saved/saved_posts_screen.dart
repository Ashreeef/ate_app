import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/saved_post_repository.dart';
import '../../repositories/auth_repository.dart';
import '../../models/post.dart';
import '../../widgets/profile/profile_posts_grid.dart';
import '../../utils/constants.dart';
import '../../l10n/app_localizations.dart';
import '../home/post_detail_screen.dart';

class SavedPostsScreen extends StatefulWidget {
  const SavedPostsScreen({super.key});

  @override
  State<SavedPostsScreen> createState() => _SavedPostsScreenState();
}

class _SavedPostsScreenState extends State<SavedPostsScreen> {
  final SavedPostRepository _savedPostRepo = SavedPostRepository();
  List<Post> _savedPosts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedPosts();
  }

  Future<void> _loadSavedPosts() async {
    final userUid = context.read<AuthRepository>().currentUserId;
    if (userUid != null) {
      try {
        final posts = await _savedPostRepo.getUserSavedPosts(userUid);
        if (mounted) {
          setState(() {
            _savedPosts = posts;
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } else {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
        title: Text(l10n.savedPosts, style: AppTextStyles.heading4),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _savedPosts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bookmark_border,
                        size: 64,
                        color: AppColors.textMedium.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noSavedPosts,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textMedium,
                        ),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: ProfilePostsGrid(
                    posts: _convertPostsToGridFormat(),
                    onPostTap: (postId) async {
                      final post = _savedPosts.firstWhere((p) => p.postId == postId);
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailScreen(post: post.toFirestore()),
                        ),
                      );
                      // Reload in case they unsaved the post in detail view
                      _loadSavedPosts();
                    },
                  ),
                ),
    );
  }

  List<Map<String, dynamic>> _convertPostsToGridFormat() {
    return _savedPosts.map((post) {
      final images = post.images;
      return {
        'id': post.postId,
        'imageUrl': images.isNotEmpty ? images.first : '',
        'likes': post.likesCount,
        'comments': post.commentsCount,
      };
    }).toList();
  }
}
