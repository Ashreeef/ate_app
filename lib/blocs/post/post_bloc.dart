import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/post_repository.dart';
import '../feed/feed_bloc.dart';
import '../feed/feed_event.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository repo;
  final FeedBloc feedBloc;

  PostBloc({required this.repo, required this.feedBloc}) : super(PostIdle()) {
    on<CreatePostEvent>(_onCreate);
    on<ToggleLikeEvent>(_onToggleLike);
    on<ToggleSaveEvent>(_onToggleSave);
  }

  Future<void> _onCreate(CreatePostEvent e, Emitter<PostState> emit) async {
    emit(PostProcessing());
    try {
      await repo.createPost(e.post);
      // refresh feed
      feedBloc.add(LoadFeed());
      emit(PostSuccess());
    } catch (err) {
      emit(PostFailure(err.toString()));
    }
  }

  Future<void> _onToggleLike(ToggleLikeEvent e, Emitter<PostState> emit) async {
    try {
      // TODO: Use LikeRepository.toggleLike() instead of in-memory manipulation
      // For now, just refresh the feed
      feedBloc.add(LoadFeed());
      emit(PostSuccess());
    } catch (err) {
      emit(PostFailure(err.toString()));
    }
  }

  Future<void> _onToggleSave(ToggleSaveEvent e, Emitter<PostState> emit) async {
    try {
      // TODO: Use SavedPostRepository.toggleSavePost() instead of in-memory manipulation
      // For now, just refresh the feed
      feedBloc.add(LoadFeed());
      emit(PostSuccess());
    } catch (err) {
      emit(PostFailure(err.toString()));
    }
  }
}
