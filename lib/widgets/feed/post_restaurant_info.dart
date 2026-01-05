import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../screens/restaurant/restaurant_page.dart';

class PostRestaurantInfo extends StatelessWidget {
  final String? restaurantId;
  final String restaurantName;
  final String dishName;
  final double rating;

  const PostRestaurantInfo({
    super.key,
    this.restaurantId,
    required this.restaurantName,
    required this.dishName,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: GestureDetector(
        onTap: restaurantId != null
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RestaurantPage(restaurantId: restaurantId!),
                  ),
                );
              }
            : null,
        child: Container(
          padding: EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          ),
          child: Row(
            children: [
              Icon(
                Icons.restaurant,
                size: AppSizes.iconSm,
                color: Theme.of(context).colorScheme.primary,
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
                        color: restaurantId != null
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                        decoration: restaurantId != null
                            ? TextDecoration.underline
                            : null,
                      ),
                    ),
                    Text(dishName, style: AppTextStyles.caption),
                  ],
                ),
              ),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  SizedBox(width: 4),
                  Text(
                    '${rating.toStringAsFixed(1)}',
                    style: AppTextStyles.captionBold,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
