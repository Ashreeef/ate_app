import 'package:flutter/material.dart';
import 'package:ate_app/utils/constants.dart';
import '../../widgets/feed/feed_header.dart';
import '../../widgets/feed/post_card.dart';
import '../../widgets/feed/post_options_sheet.dart';
import '../../widgets/feed/comments_sheet.dart';
import '../../data/posts_data.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool _isMonFeedSelected = true;
  // Load posts
  late List<Map<String, dynamic>> _posts;

  @override
  void initState() {
    super.initState();
    // Initialize posts from data file
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

  void _showPostOptions(BuildContext context, int postIndex) {
    PostOptionsSheet.show(
      context,
      onReport: () => _showReportDialog(context),
      onCopyLink: () => _copyPostLink(postIndex),
      onShare: () => _sharePost(postIndex),
      onSave: () => _toggleSave(postIndex),
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report Post', style: AppTextStyles.heading3),
        content: Text(
          'Why are you reporting this post?',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: AppTextStyles.link),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Post reported successfully',
                    style: AppTextStyles.body,
                  ),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: Text('Report', style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }

  void _copyPostLink(int postIndex) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Post link copied to clipboard',
          style: AppTextStyles.body,
        ),
      ),
    );
  }

  void _sharePost(int postIndex) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing post...', style: AppTextStyles.body)),
    );
  }

  void _showComments(BuildContext context, int postIndex) {
    final post = _posts[postIndex];
    CommentsSheet.show(context, post['comments']);
  }

  void _navigateToProfile(String userName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Navigating to $userName profile',
          style: AppTextStyles.body,
        ),
      ),
    );
    // TODO: Implpement actual navigation to user profile
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
                  return PostCard(
                    post: post,
                    postIndex: index,
                    onLike: () => _toggleLike(index),
                    onSave: () => _toggleSave(index),
                    onComment: () => _showComments(context, index),
                    onMoreOptions: () => _showPostOptions(context, index),
                    onProfileTap: () => _navigateToProfile(post['userName']),
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
