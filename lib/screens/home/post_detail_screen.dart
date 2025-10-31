import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../data/fake_data.dart';
import '../../models/post.dart';

class PostDetailScreen extends StatelessWidget {
  final String postId;

  const PostDetailScreen({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final post = FakeData.getPosts().firstWhere(
      (p) => p.id == postId,
      orElse: () => Post(
        id: '',
        userId: '',
        restaurantId: '',
        imageUrls: [],
        caption: '',
        createdAt: DateTime.now(),
      ),
    );

    if (post.id.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Post')),
        body: Center(
          child: Text('Post non trouvé', style: AppTextStyles.heading3),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Publication')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post Image
            Container(
              height: 400,
              width: double.infinity,
              color: AppColors.background,
              child: post.firstImageUrl != null
                  ? Image.network(
                      post.firstImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image,
                          size: AppSizes.iconXl * 2,
                          color: AppColors.textLight,
                        );
                      },
                    )
                  : Icon(
                      Icons.image,
                      size: AppSizes.iconXl * 2,
                      color: AppColors.textLight,
                    ),
            ),
            // Post Content
            Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Actions
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.favorite_border),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.comment_outlined),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.share_outlined),
                        onPressed: () {},
                      ),
                      Spacer(),
                      if (post.rating != null)
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: AppSizes.iconSm,
                              color: AppColors.starActive,
                            ),
                            SizedBox(width: AppSpacing.xs),
                            Text(
                              post.rating!.toStringAsFixed(1),
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  // Caption
                  Text(post.caption, style: AppTextStyles.body),
                  SizedBox(height: AppSpacing.sm),
                  // Stats
                  Text(
                    '${post.likeCount} likes • ${post.commentCount} commentaires',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
