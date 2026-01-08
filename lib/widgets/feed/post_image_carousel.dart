import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ate_app/utils/constants.dart';

class PostImageCarousel extends StatefulWidget {
  final List<String> images;
  final VoidCallback? onDoubleTap;

  const PostImageCarousel({
    super.key,
    required this.images,
    this.onDoubleTap,
  });

  @override
  State<PostImageCarousel> createState() => _PostImageCarouselState();
}

class _PostImageCarouselState extends State<PostImageCarousel> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Image display area
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.images.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onDoubleTap: widget.onDoubleTap,
                    child: CachedNetworkImage(
                      imageUrl: widget.images[index],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.backgroundLight,
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.backgroundLight,
                        child: const Center(
                          child: Icon(
                            Icons.photo_outlined,
                            color: AppColors.textLight,
                            size: AppSizes.iconXl,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Photo indicator (e.g. 1/4)
            if (widget.images.length > 1)
              Positioned(
                top: AppSpacing.md,
                right: AppSpacing.md,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(AppSizes.borderRadiusRound),
                  ),
                  child: Text(
                    '${_currentIndex + 1}/${widget.images.length}',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
        
        // Dot indicators (only show if multiple images)
        if (widget.images.length > 1)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.images.length, (index) {
                final isSelected = _currentIndex == index;
                return AnimatedContainer(
                  duration: AppConstants.shortAnimation,
                  width: isSelected ? 8.0 : 6.0,
                  height: isSelected ? 8.0 : 6.0,
                  margin: const EdgeInsets.symmetric(horizontal: 3.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textLight.withValues(alpha: 0.4),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
