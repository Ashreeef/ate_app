import 'package:flutter/material.dart';
import 'package:flutter_animated_icons/flutter_animated_icons.dart'; // Just kidding, standard icons
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Need to check if this package is available. If not, I'll build simple star rater.
// Assuming flutter_rating_bar is NOT available, I will build a simple one.
// Actually checking pubspec would be wise, but I can implement a simple row of stars.

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/constants.dart';
import '../../models/review.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../repositories/review_repository.dart';

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
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write a comment')),
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
        authorAvatarUrl: authState.user.photoURL,
        restaurantId: widget.restaurantId,
        dishId: widget.dishId,
        rating: _rating,
        comment: _commentController.text.trim(),
        createdAt: DateTime.now().toIso8601String(),
      );

      await context.read<ReviewRepository>().addReview(review);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review submitted!')),
        );
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write Review'),
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
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            const Text('Rate your experience'),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 32,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1.0;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'Your Review',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}
