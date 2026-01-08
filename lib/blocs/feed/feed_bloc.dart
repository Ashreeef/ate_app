import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ate_app/models/post.dart';
import 'package:ate_app/repositories/post_repository.dart';
import 'package:ate_app/repositories/follow_repository.dart';
import 'package:ate_app/repositories/auth_repository.dart';
import 'package:ate_app/repositories/like_repository.dart';
import 'package:ate_app/repositories/saved_post_repository.dart';
import 'feed_event.dart';
import 'feed_state.dart';

/// BLoC for handling feed operations with Firestore pagination
class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final PostRepository repo;
  final FollowRepository followRepo;
  final AuthRepository authRepo;
  final LikeRepository likeRepo;
  final SavedPostRepository savedPostRepo;
  
  final int _pageSize = 20;
  List<Post> _posts = [];
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;

  FeedBloc({
    required this.repo,
    required this.followRepo,
    required this.authRepo,
    required this.likeRepo,
    required this.savedPostRepo,
  }) : super(const FeedInitial()) {
    on<LoadFeed>(_onLoadFeed);
    on<LoadMoreFeed>(_onLoadMore);
    on<RefreshFeed>(_onRefresh);
    on<ToggleLike>(_onToggleLike);
    on<ToggleSave>(_onToggleSave);
  }

  /// Load initial feed
  Future<void> _onLoadFeed(LoadFeed event, Emitter<FeedState> emit) async {
    try {
      emit(const FeedLoading());
      
      // Reset pagination
      _posts = [];
      _lastDocument = null;
      _hasMore = true;

      final currentUserId = authRepo.currentUserId;
      List<String>? friendIds;
      
      if (event.type == FeedType.friends) {
        if (currentUserId == null) {
          emit(FeedLoaded([], hasMore: false));
          return;
        }
        
        friendIds = await followRepo.getFollowingIds(currentUserId);
        
        if (friendIds.isEmpty) {
          emit(FeedLoaded([], hasMore: false));
          return;
        }
      }

      // Fetch first page
      final posts = await repo.getFeedPosts(
        limit: _pageSize,
        userIds: friendIds,
      );
      
      _posts = posts;
      _hasMore = posts.length == _pageSize;

      // Get last document for pagination
      if (posts.isNotEmpty) {
        final lastPostId = posts.last.postId;
        if (lastPostId != null) {
          final lastDoc = await FirebaseFirestore.instance
              .collection('posts')
              .doc(lastPostId)
              .get();
          _lastDocument = lastDoc;
        }
      }

      emit(FeedLoaded(_posts, hasMore: _hasMore));
    } catch (e) {
      emit(FeedError(e.toString()));
    }
  }

  /// Load more posts (pagination)
  Future<void> _onLoadMore(LoadMoreFeed event, Emitter<FeedState> emit) async {
    if (state is FeedLoading || !_hasMore) return;

    try {
      final currentUserId = authRepo.currentUserId;
      List<String>? friendIds;
      
      if (event.type == FeedType.friends) {
        if (currentUserId == null) return;
        friendIds = await followRepo.getFollowingIds(currentUserId);
        if (friendIds.isEmpty) return;
      }

      // Fetch next page
      final posts = await repo.getFeedPosts(
        limit: _pageSize,
        lastDocument: _lastDocument,
        userIds: friendIds,
      );

      if (posts.isEmpty) {
        _hasMore = false;
        if (state is FeedLoaded) {
          emit(FeedLoaded(_posts, hasMore: false));
        }
        return;
      }

      _posts.addAll(posts);
      _hasMore = posts.length == _pageSize;

      // Update last document for next pagination
      if (posts.isNotEmpty) {
        final lastPostId = posts.last.postId;
        if (lastPostId != null) {
          final lastDoc = await FirebaseFirestore.instance
              .collection('posts')
              .doc(lastPostId)
              .get();
          _lastDocument = lastDoc;
        }
      }

      emit(FeedLoaded(_posts, hasMore: _hasMore));
    } catch (e) {
      emit(FeedError(e.toString()));
    }
  }

  /// Refresh feed (pull to refresh)
  Future<void> _onRefresh(RefreshFeed event, Emitter<FeedState> emit) async {
    _posts = [];
    _lastDocument = null;
    _hasMore = true;
    add(const LoadFeed());
  }

  /// Toggle like optimistically
  Future<void> _onToggleLike(ToggleLike event, Emitter<FeedState> emit) async {
    final postId = event.post.postId;
    final currentUserId = authRepo.currentUserId;
    if (postId == null || currentUserId == null) return;

    // 1. Prepare optimistic state
    final index = _posts.indexWhere((p) => p.postId == postId);
    if (index == -1) return;

    final post = _posts[index];
    final isLiked = post.likedByUids.contains(currentUserId);
    
    // Create updated post object
    final updatedLikedBy = List<String>.from(post.likedByUids);
    if (isLiked) {
      updatedLikedBy.remove(currentUserId);
    } else {
      updatedLikedBy.add(currentUserId);
    }

    final updatedPost = post.copyWith(
      likedByUids: updatedLikedBy,
      likesCount: isLiked ? post.likesCount - 1 : post.likesCount + 1,
    );

    // Update local list and emit
    _posts[index] = updatedPost;
    emit(FeedLoaded(List.from(_posts), hasMore: _hasMore));

    // 2. Perform background sync
    try {
      if (isLiked) {
        await likeRepo.unlikePost(postId, currentUserId);
      } else {
        await likeRepo.likePost(postId, currentUserId);
      }
    } catch (e) {
      // Rollback on error
      _posts[index] = post;
      emit(FeedLoaded(List.from(_posts), hasMore: _hasMore));
    }
  }

  /// Toggle save optimistically
  Future<void> _onToggleSave(ToggleSave event, Emitter<FeedState> emit) async {
    final postId = event.post.postId;
    final currentUserId = authRepo.currentUserId;
    if (postId == null || currentUserId == null) return;

    // 1. Prepare optimistic state
    final index = _posts.indexWhere((p) => p.postId == postId);
    if (index == -1) return;

    final post = _posts[index];
    final isSaved = post.savedByUids.contains(currentUserId);
    
    // Create updated post object
    final updatedSavedBy = List<String>.from(post.savedByUids);
    if (isSaved) {
      updatedSavedBy.remove(currentUserId);
    } else {
      updatedSavedBy.add(currentUserId);
    }

    final updatedPost = post.copyWith(
      savedByUids: updatedSavedBy,
    );

    // Update local list and emit
    _posts[index] = updatedPost;
    emit(FeedLoaded(List.from(_posts), hasMore: _hasMore));

    // 2. Perform background sync
    try {
      if (isSaved) {
        await savedPostRepo.unsavePost(postId, currentUserId);
      } else {
        await savedPostRepo.savePost(postId, currentUserId);
      }
    } catch (e) {
      // Rollback on error
      _posts[index] = post;
      emit(FeedLoaded(List.from(_posts), hasMore: _hasMore));
    }
  }
}
