import 'package:equatable/equatable.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

class PostIdle extends PostState {
  const PostIdle();
}

class PostProcessing extends PostState {
  const PostProcessing();
}

class PostSuccess extends PostState {
  final String? message;
  final String? postId; // For create post success

  const PostSuccess({this.message, this.postId});

  @override
  List<Object?> get props => [message, postId];
}

class PostFailure extends PostState {
  final String error;

  const PostFailure(this.error);

  @override
  List<Object?> get props => [error];
}
