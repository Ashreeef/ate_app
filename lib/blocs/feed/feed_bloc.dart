import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ate_app/models/post.dart';
import 'package:ate_app/repositories/post_repository.dart';
import 'package:ate_app/repositories/follow_repository.dart';
import 'package:ate_app/repositories/auth_repository.dart';
import 'feed_event.dart';
import 'feed_state.dart';

/// BLoC for handling feed operations with Firestore pagination
class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final PostRepository repo;
  final FollowRepository followRepo;
  final AuthRepository authRepo;
  final int _pageSize = 20;
  List<Post> _posts = [];
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;

  FeedBloc({
    required this.repo,
    required this.followRepo,
    required this.authRepo,
  }) : super(const FeedInitial()) {
    on<LoadFeed>(_onLoadFeed);
    on<LoadMoreFeed>(_onLoadMore);
    on<RefreshFeed>(_onRefresh);
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
          print('ℹ️ FeedBloc: No current user, friends feed empty.');
          emit(FeedLoaded([], hasMore: false));
          return;
        }
        
        print('🔍 FeedBloc: Fetching friends for user: $currentUserId');
        friendIds = await followRepo.getFollowingIds(currentUserId);
        print('👥 FeedBloc: Found ${friendIds.length} friends: $friendIds');
        
        if (friendIds.isEmpty) {
          emit(FeedLoaded([], hasMore: false));
          return;
        }
      }

      print('🚀 FeedBloc: Fetching posts (Type: ${event.type}, Friends: ${friendIds?.length ?? "ALL"})');
      
      // Fetch first page
      final posts = await repo.getFeedPosts(
        limit: _pageSize,
        userIds: friendIds,
      );
      
      print('✅ FeedBloc: Fetched ${posts.length} posts');
      
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
      print('❌ FeedBloc Error: $e');
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
      print('❌ FeedBloc LoadMore Error: $e');
      emit(FeedError(e.toString()));
    }
  }

  /// Refresh feed (pull to refresh)
  Future<void> _onRefresh(RefreshFeed event, Emitter<FeedState> emit) async {
    _posts = [];
    _lastDocument = null;
    _hasMore = true;

    // We don't know the current type easily here unless we store it in state or Bloc
    // Defaulting to global for now, but FeedScreen usually calls LoadFeed anyway.
    add(const LoadFeed());
  }
}
