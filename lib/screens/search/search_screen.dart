import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: AppColors.primary),
          SizedBox(height: AppSpacing.lg),
          Text('Search - TODO by Arslene', style: AppTextStyles.heading2),
          SizedBox(height: AppSpacing.sm),
          Text('Search for restaurants and dishes', style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
