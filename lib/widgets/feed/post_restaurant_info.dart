import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class PostRestaurantInfo extends StatelessWidget {
  final String restaurantName;
  final String dishName;
  final int rating;

  const PostRestaurantInfo({
    super.key,
    required this.restaurantName,
    required this.dishName,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
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
                    restaurantName,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(dishName, style: AppTextStyles.caption),
                ],
              ),
            ),
            Row(
              children: [
                Icon(Icons.star, color: AppColors.starActive, size: 16),
                SizedBox(width: 4),
                Text('$rating.0', style: AppTextStyles.captionBold),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
