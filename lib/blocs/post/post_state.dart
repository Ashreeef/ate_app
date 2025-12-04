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
  const PostSuccess();
}

class PostFailure extends PostState {
  final String message;
  const PostFailure(this.message);

  @override
  List<Object?> get props => [message];
}
