import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/post.dart';
import '../../repositories/post_repository.dart';
import 'feed_event.dart';
import 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final PostRepository repo;
  int _page = 1;
  final int _pageSize = 10;
  List<Post> _posts = [];

  FeedBloc({required this.repo}) : super(const FeedInitial()) {
    on<LoadFeed>(_onLoadFeed);
    on<LoadMoreFeed>(_onLoadMore);
  }

  Future<void> _onLoadFeed(LoadFeed event, Emitter<FeedState> emit) async {
    try {
      emit(const FeedLoading());
      _page = 1;
      final offset = (_page - 1) * _pageSize;
      final posts = await repo.getRecentPosts(limit: _pageSize, offset: offset);
      _posts = posts;
      emit(FeedLoaded(_posts, hasMore: posts.length == _pageSize));
    } catch (e) {
      emit(FeedError(e.toString()));
    }
  }

  Future<void> _onLoadMore(LoadMoreFeed event, Emitter<FeedState> emit) async {
    if (state is FeedLoading) return;
    try {
      _page++;
      final offset = (_page - 1) * _pageSize;
      final posts = await repo.getRecentPosts(limit: _pageSize, offset: offset);
      _posts.addAll(posts);
      emit(FeedLoaded(_posts, hasMore: posts.length == _pageSize));
    } catch (e) {
      emit(FeedError(e.toString()));
    }
  }
}
