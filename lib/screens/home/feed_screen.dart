import 'package:flutter/material.dart';
import 'package:ate_app/utils/constants.dart';
import '../../widgets/feed/feed_header.dart';
import '../../widgets/feed/post_card.dart';
import '../../widgets/feed/comments_sheet.dart';
import '../../data/posts_data.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool _isMonFeedSelected = true;
  late List<Map<String, dynamic>> _posts;

  @override
  void initState() {
    super.initState();
    _posts = List.from(postsData);
  }

  // Simulate refreshing the feed
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {});
  }

  // Like/unlike a post
  void _toggleLike(int postIndex) {
    setState(() {
      final post = _posts[postIndex];
      post['isLiked'] = !post['isLiked'];
      if (post['isLiked']) {
        post['likes'] = post['likes'] + 1;
      } else {
        post['likes'] = post['likes'] - 1;
      }
    });
  }

  // Save/unsave a post
  void _toggleSave(int postIndex) {
    setState(() {
      _posts[postIndex]['isSaved'] = !_posts[postIndex]['isSaved'];
    });
  }

  void _sharePost(int postIndex) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing post...', style: AppTextStyles.body)),
    );
  }

  void _showComments(int postIndex) {
    final post = _posts[postIndex];
    final comments = post['comments'] as List<dynamic>? ?? [];
    CommentsSheet.show(context, comments);
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
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                padding: EdgeInsets.all(AppSpacing.md),
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  final post = _posts[index];
                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 600),
                      child: PostCard(
                        post: post,
                        onTap: () {},
                        onLike: () => _toggleLike(index),
                        onComment: () => _showComments(index),
                        onShare: () => _sharePost(index),
                        onSave: () => _toggleSave(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
