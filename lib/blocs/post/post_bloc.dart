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
      final post = await repo.getPostById(e.postId);
      if (post == null) throw Exception('Post not found');
      if (post.likedBy.contains(e.userId)) {
        post.likedBy.remove(e.userId);
        post.likesCount = post.likedBy.length;
      } else {
        post.likedBy.add(e.userId);
        post.likesCount = post.likedBy.length;
      }
      await repo.updatePost(post);
      feedBloc.add(LoadFeed());
      emit(PostSuccess());
    } catch (err) {
      emit(PostFailure(err.toString()));
    }
  }

  Future<void> _onToggleSave(ToggleSaveEvent e, Emitter<PostState> emit) async {
    try {
      final post = await repo.getPostById(e.postId);
      if (post == null) throw Exception('Post not found');
      if (post.savedBy.contains(e.userId)) {
        post.savedBy.remove(e.userId);
      } else {
        post.savedBy.add(e.userId);
      }
      await repo.updatePost(post);
      feedBloc.add(LoadFeed());
      emit(PostSuccess());
    } catch (err) {
      emit(PostFailure(err.toString()));
    }
  }
}
