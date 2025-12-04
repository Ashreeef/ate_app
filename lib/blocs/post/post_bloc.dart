import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/post_repository.dart';
import '../../repositories/like_repository.dart';
import '../../repositories/saved_post_repository.dart';
import '../feed/feed_bloc.dart';
import '../feed/feed_event.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository repo;
  final LikeRepository likeRepo;
  final SavedPostRepository savedPostRepo;
  final FeedBloc feedBloc;

  PostBloc({
    required this.repo,
    required this.likeRepo,
    required this.savedPostRepo,
    required this.feedBloc,
  }) : super(const PostIdle()) {
    on<CreatePostEvent>(_onCreate);
    on<ToggleLikeEvent>(_onToggleLike);
    on<ToggleSaveEvent>(_onToggleSave);
  }

  Future<void> _onCreate(CreatePostEvent e, Emitter<PostState> emit) async {
    emit(const PostProcessing());
    try {
      await repo.createPost(e.post);
      // refresh feed
      feedBloc.add(const LoadFeed());
      emit(const PostSuccess());
    } catch (err) {
      emit(PostFailure(err.toString()));
    }
  }

  Future<void> _onToggleLike(ToggleLikeEvent e, Emitter<PostState> emit) async {
    try {
      // Toggle like in database
      await likeRepo.toggleLike(e.userId, e.postId);
      // Refresh feed to show updated like status
      feedBloc.add(const LoadFeed());
      emit(const PostSuccess());
    } catch (err) {
      emit(PostFailure(err.toString()));
    }
  }

  Future<void> _onToggleSave(ToggleSaveEvent e, Emitter<PostState> emit) async {
    try {
      // Toggle save in database
      await savedPostRepo.toggleSavePost(e.userId, e.postId);
      // Refresh feed to show updated save status
      feedBloc.add(const LoadFeed());
      emit(const PostSuccess());
    } catch (err) {
      emit(PostFailure(err.toString()));
    }
  }
}
