import 'package:equatable/equatable.dart';
import '../../models/post.dart';

enum FeedType { global, friends }

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => [];
}

class LoadFeed extends FeedEvent {
  final bool refresh;
  final FeedType type;
  const LoadFeed({this.refresh = false, this.type = FeedType.global});

  @override
  List<Object?> get props => [refresh, type];
}

class LoadMoreFeed extends FeedEvent {
  final FeedType type;
  const LoadMoreFeed({this.type = FeedType.global});

  @override
  List<Object?> get props => [type];
}

class RefreshFeed extends FeedEvent {
  const RefreshFeed();
}

class ToggleLike extends FeedEvent {
  final Post post;
  const ToggleLike(this.post);

  @override
  List<Object?> get props => [post];
}

class ToggleSave extends FeedEvent {
  final Post post;
  const ToggleSave(this.post);

  @override
  List<Object?> get props => [post];
}

