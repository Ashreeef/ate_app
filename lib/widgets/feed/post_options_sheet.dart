import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class PostOptionsSheet {
  static void show(
    BuildContext context, {
    required VoidCallback onReport,
    required VoidCallback onCopyLink,
    required VoidCallback onShare,
    required VoidCallback onSave,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _OptionItem(
                icon: Icons.flag,
                text: 'Report',
                onTap: () {
                  Navigator.pop(context);
                  onReport();
                },
              ),
              _OptionItem(
                icon: Icons.link,
                text: 'Copy Link',
                onTap: () {
                  Navigator.pop(context);
                  onCopyLink();
                },
              ),
              _OptionItem(
                icon: Icons.share,
                text: 'Share',
                onTap: () {
                  Navigator.pop(context);
                  onShare();
                },
              ),
              _OptionItem(
                icon: Icons.bookmark_border,
                text: 'Save to Collection',
                onTap: () {
                  Navigator.pop(context);
                  onSave();
                },
              ),
              SizedBox(height: AppSpacing.sm),
              Container(height: 1, color: AppColors.border),
              SizedBox(height: AppSpacing.sm),
              _OptionItem(
                icon: Icons.cancel,
                text: 'Cancel',
                onTap: () => Navigator.pop(context),
                isCancel: true,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OptionItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final bool isCancel;

  const _OptionItem({
    required this.icon,
    required this.text,
    required this.onTap,
    this.isCancel = false,
  });

  @override
  Widget build(BuildContext context) {
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
}
