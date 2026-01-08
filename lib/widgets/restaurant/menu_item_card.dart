import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../l10n/app_localizations.dart';

class MenuItemCard extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double rating;
  final int reviewCount;
  final VoidCallback? onTap;
  final VoidCallback? onReviewsTap;

  const MenuItemCard({
    super.key,
    required this.name,
    this.imageUrl,
    required this.rating,
    required this.reviewCount,
    this.onTap,
    this.onReviewsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menu Item Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppSizes.borderRadius),
                topRight: Radius.circular(AppSizes.borderRadius),
              ),
              child: Container(
                height: 150,
                width: double.infinity,
                color: AppColors.background,
                child: imageUrl != null
                    ? Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholderImage();
                        },
                      )
                    : _buildPlaceholderImage(),
              ),
            ),
            // Menu Item Info
            Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.heading4,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      // Star Rating
                      ...List.generate(5, (index) {
                        return Icon(
                          index < rating.round()
                              ? Icons.star
                              : Icons.star_border,
                          size: AppSizes.iconSm,
                          color: AppColors.starActive,
                        );
                      }),
                      SizedBox(width: AppSpacing.sm),
                      // Reviews link
                      TextButton(
                        onPressed: onReviewsTap,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.reviews,
                          style: AppTextStyles.link.copyWith(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColors.background,
      child: Center(
        child: Icon(
          Icons.fastfood,
          size: AppSizes.iconXl,
          color: AppColors.textLight,
        ),
      ),
    );
  }
}
