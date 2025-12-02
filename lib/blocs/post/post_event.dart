import '../../models/post.dart';

abstract class PostEvent {}

class CreatePostEvent extends PostEvent {
  final Post post;
  CreatePostEvent(this.post);
}

class ToggleLikeEvent extends PostEvent {
  final int postId;
  final int userId;
  ToggleLikeEvent(this.postId, this.userId);
}

class ToggleSaveEvent extends PostEvent {
  final int postId;
  final int userId;
  ToggleSaveEvent(this.postId, this.userId);
}
