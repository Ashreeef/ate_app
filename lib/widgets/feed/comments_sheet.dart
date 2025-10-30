import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class CommentsSheet {
  static void show(BuildContext context, List<dynamic> comments) {
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
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: Text(
                          comment['user'][1],
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                      title: Text(
                        comment['user'],
                        style: AppTextStyles.username.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      subtitle: Text(
                        comment['text'],
                        style: AppTextStyles.body,
                      ),
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
                          hintStyle: AppTextStyles.body.copyWith(
                            color: AppColors.textLight,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppSizes.borderRadiusRound,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                          ),
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
}
