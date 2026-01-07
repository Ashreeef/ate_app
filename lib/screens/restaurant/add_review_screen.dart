import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/constants.dart';
import '../../models/review.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../repositories/review_repository.dart';
import '../../l10n/app_localizations.dart';

class AddReviewScreen extends StatefulWidget {
  final String restaurantId;
  final String? dishId;

  const AddReviewScreen({
    super.key,
    required this.restaurantId,
    this.dishId,
  });

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _commentController = TextEditingController();
  double _rating = 5.0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    final l10n = AppLocalizations.of(context)!;
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.fieldRequired)),
      );
      return;
    }

    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) return;

    setState(() => _isSubmitting = true);

    try {
      final review = Review(
        authorId: authState.user.uid!,
        authorName: authState.user.displayName ?? 'User',
        authorAvatarUrl: authState.user.profileImage, // Corrected from photoURL
        restaurantId: widget.restaurantId,
        dishId: widget.dishId,
        rating: _rating,
        comment: _commentController.text.trim(),
        createdAt: DateTime.now().toIso8601String(),
      );

      await context.read<ReviewRepository>().addReview(review);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.reviewSuccess)),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.error}: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.writeReview),
        actions: [
          if (_isSubmitting)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: SizedBox(
                   width: 20, 
                   height: 20, 
                   child: CircularProgressIndicator(strokeWidth: 2)
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _submitReview,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Text(
              l10n.rateExperience,
              style: AppTextStyles.heading4,
            ),
            const SizedBox(height: AppSpacing.md),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: l10n.yourReview,
                hintText: l10n.writeReviewHint,
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 8,
            ),
          ],
        ),
      ),
    );
  }
}
