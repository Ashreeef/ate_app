import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../l10n/app_localizations.dart';
import '../../data/fake_data.dart';
import '../../repositories/profile_repository.dart';
import '../../repositories/post_repository.dart';
import '../../models/user.dart';
import '../../models/post.dart';
import '../../widgets/profile/profile_header.dart';
import '../../widgets/profile/profile_posts_grid.dart';

class OtherUserProfileScreen extends StatefulWidget {
  final int userId;

  const OtherUserProfileScreen({Key? key, required this.userId})
    : super(key: key);

  @override
  State<OtherUserProfileScreen> createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {
  final ProfileRepository _repository = ProfileRepository();
  final PostRepository _postRepository = PostRepository();
  User? _user;
  List<Post> _posts = [];
  bool _isLoading = true;
  bool _isLoadingPosts = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      setState(() => _isLoading = true);
      final user = await _repository.getUserById(widget.userId);
      setState(() {
        _user = user;
        _isLoading = false;
      });

      // Load posts after user is loaded
      if (user != null) {
        _loadPosts();
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
        _isLoadingPosts = false;
      });
    }
  }

  Future<void> _loadPosts() async {
    try {
      setState(() => _isLoadingPosts = true);
      final posts = await _postRepository.getPostsByUserId(widget.userId);
      if (mounted) {
        setState(() {
          _posts = posts;
          _isLoadingPosts = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingPosts = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.textDark),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null || _user == null) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.textDark),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Text(
            _errorMessage ?? 'User not found',
            style: AppTextStyles.bodyMedium,
          ),
        ),
      );
    }

    final username = _user!.username;
    final avatar = _user!.profileImage ?? FakeUserData.avatarUrl;

    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          '@$username',
          style: AppTextStyles.heading4.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: AppColors.textDark),
            tooltip: 'More options',
            onPressed: () {
              _showOptionsMenu(context);
            },
          ),
        ],
      ),

      body: Column(
        children: [
          // Subtle divider under app bar
          Container(height: 1, color: AppColors.divider.withOpacity(0.5)),
          Expanded(
            child: _isLoadingPosts
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        // Profile Header Component
                        ProfileHeader(
                          avatarUrl: avatar,
                          username: username,
                          posts: _posts.length,
                          followers: _user!.followersCount,
                          following: _user!.followingCount,
                          rank: _user!.level,
                          points: _user!.points,
                        ),

                        // Divider Line
                        Container(height: 1, color: AppColors.divider),

                        // Posts Grid Component
                        _posts.isEmpty
                            ? Padding(
                                padding: EdgeInsets.all(AppSpacing.xl),
                                child: Text(
                                  'No posts yet',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textMedium,
                                  ),
                                ),
                              )
                            : ProfilePostsGrid(
                                posts: _convertPostsToFakeFormat(),
                              ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _convertPostsToFakeFormat() {
    return _posts.map((post) {
      final images = post.getImageList();
      return {
        'id': post.id,
        'imageUrl': images.isNotEmpty ? images.first : FakeUserData.avatarUrl,
        'likes': post.likesCount,
        'comments': post.commentsCount,
      };
    }).toList();
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.borderRadiusLg),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.person_add_outlined),
                title: Text('Follow', style: AppTextStyles.bodyMedium),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.comingSoon),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.share_outlined),
                title: Text(
                  AppLocalizations.of(context)!.shareProfile,
                  style: AppTextStyles.bodyMedium,
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.comingSoon),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.block_outlined, color: AppColors.error),
                title: Text(
                  'Block User',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.comingSoon),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
