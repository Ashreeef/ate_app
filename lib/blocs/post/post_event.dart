import 'package:equatable/equatable.dart';
import '../../models/post.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

class CreatePostEvent extends PostEvent {
  final Post post;
  const CreatePostEvent(this.post);

  @override
  List<Object?> get props => [post];
}

class ToggleLikeEvent extends PostEvent {
  final int postId;
  final int userId;
  const ToggleLikeEvent(this.postId, this.userId);

  @override
  List<Object?> get props => [postId, userId];
}

class ToggleSaveEvent extends PostEvent {
  final int postId;
  final int userId;
  const ToggleSaveEvent(this.postId, this.userId);

  @override
  List<Object?> get props => [postId, userId];
}
