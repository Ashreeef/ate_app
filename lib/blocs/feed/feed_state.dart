import '../../models/post.dart';

abstract class FeedState {}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedLoaded extends FeedState {
  final List<Post> posts;
  final bool hasMore;

  FeedLoaded(this.posts, {this.hasMore = false});
}

class FeedError extends FeedState {
  final String message;

  FeedError(this.message);
}
