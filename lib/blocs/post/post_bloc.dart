import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/post_repository.dart';
import '../../repositories/like_repository.dart';
import '../../repositories/saved_post_repository.dart';
import '../feed/feed_bloc.dart';
import '../feed/feed_event.dart';
import 'post_event.dart';
import 'post_state.dart';

/// BLoC for handling post operations (create, like, save, delete)
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
    on<DeletePostEvent>(_onDelete);
  }

  /// Handle post creation with Cloudinary image upload
  Future<void> _onCreate(CreatePostEvent e, Emitter<PostState> emit) async {
    emit(const PostProcessing());
    try {
      final postId = await repo.createPost(
        userUid: e.userUid,
        username: e.username,
        userAvatarUrl: e.userAvatarUrl,
        caption: e.caption,
        imageFiles: e.imageFiles,
        restaurantUid: e.restaurantUid,
        restaurantName: e.restaurantName,
        dishName: e.dishName,
        rating: e.rating,
        explicitChallengeId: e.explicitChallengeId,
      );

      // Refresh feed to show new post
      feedBloc.add(const LoadFeed());

      emit(PostSuccess(message: 'Post created successfully', postId: postId));
    } catch (err) {
      emit(PostFailure(err.toString()));
    }
  }

  /// Handle like/unlike toggle
  Future<void> _onToggleLike(ToggleLikeEvent e, Emitter<PostState> emit) async {
    try {
      if (e.isLiked) {
        // Unlike the post
        await likeRepo.unlikePost(e.postId, e.userUid);
      } else {
        // Like the post
        await likeRepo.likePost(e.postId, e.userUid);
      }

      // Refresh feed to show updated like status
      feedBloc.add(const LoadFeed());

      emit(const PostSuccess());
    } catch (err) {
      emit(PostFailure(err.toString()));
    }
  }

  /// Handle save/unsave toggle
  Future<void> _onToggleSave(ToggleSaveEvent e, Emitter<PostState> emit) async {
    try {
      if (e.isSaved) {
        // Unsave the post
        await savedPostRepo.unsavePost(e.postId, e.userUid);
      } else {
        // Save the post
        await savedPostRepo.savePost(e.postId, e.userUid);
      }

      // Refresh feed to show updated save status
      feedBloc.add(const LoadFeed());

      emit(const PostSuccess());
    } catch (err) {
      emit(PostFailure(err.toString()));
    }
  }

  /// Handle post deletion
  Future<void> _onDelete(DeletePostEvent e, Emitter<PostState> emit) async {
    emit(const PostProcessing());
    try {
      await repo.deletePost(e.postId);

      // Refresh feed to remove deleted post
      feedBloc.add(const LoadFeed());

      emit(const PostSuccess(message: 'Post deleted successfully'));
    } catch (err) {
      emit(PostFailure(err.toString()));
    }
  }
}
