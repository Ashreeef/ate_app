import 'package:equatable/equatable.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => [];
}

class LoadFeed extends FeedEvent {
  final bool refresh;
  const LoadFeed({this.refresh = false});

  @override
  List<Object?> get props => [refresh];
}

class LoadMoreFeed extends FeedEvent {
  const LoadMoreFeed();
}
