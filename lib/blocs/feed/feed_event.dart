import 'package:equatable/equatable.dart';

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

