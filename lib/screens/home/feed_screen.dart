import 'package:flutter/material.dart';
import 'package:ate_app/utils/constants.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  // Temporary data until FakeData is ready
  final List<Map<String, dynamic>> _posts = [
    {
      'id': '1',
      'userName': '@foodie_alger',
      'userAvatar': ' ',
      'caption': 'Amazing Couscous ! The best in Algiers! ',
      'restaurantName': 'Hicham cook',
      'dishName': 'Couscous Royal',
      'rating': 5,
      'likes': 24,
      'isLiked': false,
      'isSaved': false,
      'imageUrl': 'https://plus.unsplash.com/premium_photo-1713089941197-0a4c8b3dfeca?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1169', // Couscous image
      'comments': [
        {'user': '@algerian_foodie', 'text': 'This looks incredible! '},
        {'user': '@travel_eater', 'text': 'Need to visit this place! '},
      ],
    },
    {
      'id': '2',
      'userName': '@foodie_doodie',
      'userAvatar': ' ',
      'caption': 'Fresh seafood by the port today! ',
      'restaurantName': 'La Pêcherie',
      'dishName': 'Grilled Sea Bream',
      'rating': 4,
      'likes': 18,
      'isLiked': false,
      'isSaved': false,
      'imageUrl': 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400', // Seafood image
      'comments': [
        {'user': '@seafood_lover', 'text': 'Fresh catch! '},
      ],
    },
    {
      'id': '3',
      'userName': '@El_moustghanmia',
      'userAvatar': ' ',
      'caption': ' Tasty traditional dishes are waiting for you here :)',
      'restaurantName': 'دار ماني',
      'dishName': 'CHAKHCHOUKHA BESKRIA',
      'rating': 5,
      'likes': 42,
      'isLiked': false,
      'isSaved': false,
      'imageUrl': 'https://images.unsplash.com/photo-1541518763669-27fef04b14ea?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1033', // couscous image
      'comments': [
        {'user': '@developer_friend', 'text': 'Looking great! '},
        {'user': '@beta_tester', 'text': 'Can\'t wait to try it! '},
      ],
    },
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // REMOVED the duplicate AppBar - using the one from navigation shell
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
          
          // Post image with pinch-to-zoom
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
            child: Text(
              post['userAvatar'],
              style: TextStyle(fontSize: 16),
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
        onDoubleTap: () {
          // Double tap to like (Instagram-like feature)
          _toggleLike(postIndex);
        },
        child: InteractiveViewer(
          minScale: 1.0,
          maxScale: 5.0,
          panEnabled: true,
          scaleEnabled: true,
          boundaryMargin: EdgeInsets.all(20),
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