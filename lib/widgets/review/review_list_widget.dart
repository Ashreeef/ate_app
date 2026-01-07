import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../utils/constants.dart';
import '../../blocs/review/review_bloc.dart';
import '../../blocs/review/review_event.dart';
import '../../blocs/review/review_state.dart';
import '../../repositories/review_repository.dart';

class ReviewListWidget extends StatelessWidget {
  final String restaurantId;

  const ReviewListWidget({
    super.key,
    required this.restaurantId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReviewBloc(
        reviewRepository: context.read<ReviewRepository>(),
      )..add(LoadRestaurantReviews(restaurantId)),
      child: BlocBuilder<ReviewBloc, ReviewState>(
        builder: (context, state) {
          if (state is ReviewsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ReviewsLoaded) {
            if (state.reviews.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.noReviewsRow,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: state.reviews.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final review = state.reviews[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: review.authorAvatarUrl != null && review.authorAvatarUrl!.isNotEmpty
                              ? NetworkImage(review.authorAvatarUrl!)
                              : null,
                          child: (review.authorAvatarUrl == null || review.authorAvatarUrl!.isEmpty)
                              ? Text(review.authorName.isNotEmpty ? review.authorName[0].toUpperCase() : '?')
                              : null,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review.authorName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _formatDate(review.createdAt),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 14,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                review.rating.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(review.comment),
                  ],
                );
              },
            );
          }

          if (state is ReviewError) {
             return Center(child: Text(AppLocalizations.of(context)!.failedToLoadReviews));
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }

  String _formatDate(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      return DateFormat.yMMMd().format(date);
    } catch (_) {
      return '';
    }
  }
}
