import 'package:flutter/material.dart';
import 'package:ate_app/data/posts_data.dart';
import 'package:ate_app/utils/constants.dart';
import 'package:ate_app/widgets/feed/feed_header.dart'; // Add this import

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  // Use Ashref's data from posts_data.dart
  List<Map<String, dynamic>> _posts = [];
  bool _isMonFeedSelected = true; // Track which tab is selected

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  void _loadPosts() {
    // Use Ashref's postsData directly
    setState(() {
      _posts = List.from(postsData);
    });
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

  // Show post options menu
  void _showPostOptions(BuildContext context, int postIndex) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildOptionItem(Icons.flag, 'Report', () {
                Navigator.pop(context);
                _showReportDialog(context);
              }),
              _buildOptionItem(Icons.link, 'Copy Link', () {
                Navigator.pop(context);
                _copyPostLink(postIndex);
              }),
              _buildOptionItem(Icons.share, 'Share', () {
                Navigator.pop(context);
                _sharePost(postIndex);
              }),
              _buildOptionItem(Icons.bookmark_border, 'Save to Collection', () {
                Navigator.pop(context);
                _toggleSave(postIndex);
              }),
              SizedBox(height: AppSpacing.sm),
              Container(
                height: 1,
                color: AppColors.border,
              ),
              SizedBox(height: AppSpacing.sm),
              _buildOptionItem(Icons.cancel, 'Cancel', () {
                Navigator.pop(context);
              }, isCancel: true),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionItem(IconData icon, String text, VoidCallback onTap, {bool isCancel = false}) {
    return ListTile(
      leading: Icon(
        icon,
        color: isCancel ? AppColors.error : AppColors.textDark,
        size: AppSizes.icon,
      ),
      title: Text(
        text,
        style: isCancel 
            ? AppTextStyles.body.copyWith(color: AppColors.error)
            : AppTextStyles.body,
      ),
      onTap: onTap,
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report Post', style: AppTextStyles.heading3),
        content: Text('Why are you reporting this post?', style: AppTextStyles.body),
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
                  content: Text('Post reported successfully', style: AppTextStyles.body),
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
        content: Text('Post link copied to clipboard', style: AppTextStyles.body),
      ),
    );
  }

  void _sharePost(int postIndex) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing post...', style: AppTextStyles.body),
      ),
    );
  }

  void _showComments(BuildContext context, int postIndex) {
    final post = _posts[postIndex];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Comments', style: AppTextStyles.heading3),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, size: AppSizes.icon),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: post['comments'].length,
                  itemBuilder: (context, index) {
                    final comment = post['comments'][index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: Text(
                          comment['user'][1], // First character after @
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                      title: Text(
                        comment['user'],
                        style: AppTextStyles.username.copyWith(color: AppColors.primary),
                      ),
                      subtitle: Text(comment['text'], style: AppTextStyles.body),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          hintStyle: AppTextStyles.body.copyWith(color: AppColors.textLight),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppSizes.borderRadiusRound),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.send, color: AppColors.primary),
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

  void _navigateToProfile(String userName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigating to $userName profile', style: AppTextStyles.body),
      ),
    );
    // TODO: Implement actual navigation to user profile
  }

  // Add this method for post detail navigation
  void _navigateToPostDetail(int postIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.textDark),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text('Post', style: AppTextStyles.heading3),
          ),
          body: SingleChildScrollView(
            child: _buildPostCard(_posts[postIndex], postIndex),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // Use the custom FeedHeader
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100), // Adjust height as needed
        child: FeedHeader(
          isMonFeedSelected: _isMonFeedSelected,
          onMonFeedTap: () {
            setState(() {
              _isMonFeedSelected = true;
            });
          },
          onMesAmisTap: () {
            setState(() {
              _isMonFeedSelected = false;
            });
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
          padding: EdgeInsets.all(AppSpacing.md),
          itemCount: _posts.length,
          itemBuilder: (context, index) {
            final post = _posts[index];
            return _buildPostCard(post, index);
          },
        ),
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post, int postIndex) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: AppSpacing.lg),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User header
          _buildUserHeader(post, postIndex),
          
          // Post image - FIXED: No more InteractiveViewer
          _buildPostImage(post, postIndex),
          
          // Engagement buttons
          _buildEngagementBar(post, postIndex),
          
          // Likes count
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              '${post['likes']} likes',
              style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          
          // Caption with username
          _buildCaption(post),
          SizedBox(height: AppSpacing.sm),
          
          // Restaurant info
          _buildRestaurantInfo(post),
          SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  Widget _buildUserHeader(Map<String, dynamic> post, int postIndex) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withOpacity(0.1),
            radius: AppSizes.avatarSm / 2,
            child: Icon(
              Icons.person,
              color: AppColors.primary,
              size: AppSizes.iconSm,
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: GestureDetector(
              onTap: () => _navigateToProfile(post['userName']),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Text(
                      post['userName'],
                      style: AppTextStyles.heading4.copyWith(
                        color: AppColors.primary, // Username in red
                      ),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '2 hours ago',
                    style: AppTextStyles.timestamp,
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () => _showPostOptions(context, postIndex),
            icon: Icon(
              Icons.more_vert,
              color: AppColors.textLight,
              size: AppSizes.icon,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostImage(Map<String, dynamic> post, int postIndex) {
    return Container(
      height: AppSizes.postImageHeight,
      width: double.infinity,
      child: GestureDetector(
        onTap: () {
          // Navigate to post detail when image is tapped
          _navigateToPostDetail(postIndex);
        },
        onDoubleTap: () {
          // Double tap to like (Instagram-like feature)
          _toggleLike(postIndex);
        },
        child: Image.network(
          post['imageUrl'],
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: AppColors.backgroundLight,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppColors.backgroundLight,
              child: Center(
                child: Icon(
                  Icons.photo,
                  color: AppColors.textLight,
                  size: AppSizes.iconXl,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEngagementBar(Map<String, dynamic> post, int postIndex) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _toggleLike(postIndex),
            icon: Icon(
              post['isLiked'] ? Icons.favorite : Icons.favorite_border,
              color: post['isLiked'] ? AppColors.error : AppColors.textLight,
              size: AppSizes.icon,
            ),
          ),
          IconButton(
            onPressed: () => _showComments(context, postIndex),
            icon: Icon(
              Icons.chat_bubble_outline,
              color: AppColors.textLight,
              size: AppSizes.icon,
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () => _toggleSave(postIndex),
            icon: Icon(
              post['isSaved'] ? Icons.bookmark : Icons.bookmark_border,
              color: post['isSaved'] ? AppColors.textDark : AppColors.textLight,
              size: AppSizes.icon,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaption(Map<String, dynamic> post) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '${post['userName']} ',
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary, // Username in red in caption too
              ),
            ),
            TextSpan(
              text: post['caption'],
              style: AppTextStyles.body,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantInfo(Map<String, dynamic> post) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        child: Row(
          children: [
            Icon(
              Icons.restaurant,
              size: AppSizes.iconSm,
              color: AppColors.primary,
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post['restaurantName'],
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    post['dishName'],
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: AppColors.starActive,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  '${post['rating']}.0',
                  style: AppTextStyles.captionBold,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}