import 'package:flutter/material.dart';
import '../../models/restaurant.dart';
import '../../utils/constants.dart';

class RestaurantHeader extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantHeader({Key? key, required this.restaurant})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            // Logo overlay (if available)
            if (restaurant.logoUrl != null)
              Positioned(
                bottom: AppSpacing.md,
                left: AppSpacing.md,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.network(
                      restaurant.logoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.restaurant,
                          color: AppColors.primary,
                          size: AppSizes.iconLg,
                        );
                      },
                    ),
                  ),
                ),
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
                        if (restaurant.description.isNotEmpty) ...[
                          SizedBox(height: AppSpacing.sm),
                          Text(
                            restaurant.description,
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
                    child: Text('Mentions', style: AppTextStyles.link),
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
                      restaurant.location,
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
                    '(${restaurant.reviewCount} avis)',
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
