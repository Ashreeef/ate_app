import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../models/post.dart';
import 'package:ate_app/l10n/app_localizations.dart';

class PostOptionsSheet extends StatelessWidget {
  final Post post;
  final bool isOwnPost;

  const PostOptionsSheet({
    super.key,
    required this.post,
    required this.isOwnPost,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSizes.borderRadiusLg),
          topRight: Radius.circular(AppSizes.borderRadiusLg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textLight.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          
          _OptionItem(
            icon: Icons.link_outlined,
            text: l10n.copyLink,
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement copy link
            },
          ),
          _OptionItem(
            icon: Icons.share_outlined,
            text: l10n.share,
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement share
            },
          ),
          
          const Divider(height: 1),
          
          if (!isOwnPost)
            _OptionItem(
              icon: Icons.flag_outlined,
              text: l10n.report,
              iconColor: AppColors.error,
              textColor: AppColors.error,
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement report
              },
            ),
            
          if (isOwnPost)
            _OptionItem(
              icon: Icons.delete_outline,
              text: l10n.deleteAction,
              iconColor: AppColors.error,
              textColor: AppColors.error,
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement delete
              },
            ),
            
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _OptionItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  const _OptionItem({
    required this.icon,
    required this.text,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? AppColors.textDark,
        size: 24,
      ),
      title: Text(
        text,
        style: AppTextStyles.body.copyWith(
          color: textColor ?? AppColors.textDark,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
