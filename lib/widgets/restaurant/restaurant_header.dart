import 'package:flutter/material.dart';
import '../../models/restaurant.dart';
import '../../utils/constants.dart';
import '../../l10n/app_localizations.dart';

class RestaurantHeader extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantHeader({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Image
        Stack(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              color: AppColors.background,
              child: restaurant.imageUrl != null
                  ? Image.network(
                      restaurant.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholderImage();
                      },
                    )
                  : _buildPlaceholderImage(),
            ),
          ],
        ),
        // Restaurant Info
        Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(restaurant.name, style: AppTextStyles.heading2),
                        if (restaurant.cuisine.isNotEmpty) ...[
                          SizedBox(height: AppSpacing.sm),
                          Text(
                            restaurant.cuisine,
                            style: AppTextStyles.bodySmall,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Mentions link (placeholder)
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to mentions
                    },
                    child: Text(l10n.mentions, style: AppTextStyles.link),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.md),
              // Location
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: AppSizes.iconSm,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      (restaurant.address.isNotEmpty ? restaurant.address : l10n.locationNotSpecified),
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.sm),
              // Rating
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: AppSizes.iconSm,
                    color: AppColors.starActive,
                  ),
                  SizedBox(width: AppSpacing.xs),
                  Text(
                    restaurant.rating.toStringAsFixed(1),
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: AppSpacing.xs),
                  Text(
                    '(${restaurant.postsCount} ${l10n.posts})',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColors.background,
      child: Center(
        child: Icon(
          Icons.restaurant,
          size: AppSizes.iconXl * 2,
          color: AppColors.textLight,
        ),
      ),
    );
  }
}
