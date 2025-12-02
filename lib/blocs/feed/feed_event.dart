abstract class FeedEvent {}

class LoadFeed extends FeedEvent {
  final bool refresh;
  LoadFeed({this.refresh = false});
}

class LoadMoreFeed extends FeedEvent {}
