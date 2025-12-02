abstract class PostState {}

class PostIdle extends PostState {}

class PostProcessing extends PostState {}

class PostSuccess extends PostState {}

class PostFailure extends PostState {
  final String message;
  PostFailure(this.message);
}
