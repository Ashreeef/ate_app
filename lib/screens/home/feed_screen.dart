import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ate_app/utils/constants.dart';
import '../../widgets/feed/feed_header.dart';
import '../../widgets/feed/post_card.dart';
import '../../widgets/common/empty_state.dart';
import '../../blocs/feed/feed_bloc.dart';
import '../../blocs/feed/feed_event.dart';
import '../../blocs/feed/feed_state.dart';
import '../../models/post.dart';
import '../../repositories/auth_repository.dart';
import 'package:ate_app/l10n/app_localizations.dart';
import 'post_detail_screen.dart';
import 'package:ate_app/screens/home/navigation_shell.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late PageController _pageController;
  int _currentTab = 0; // 0 for Global, 1 for Friends

  final ScrollController _globalScrollController = ScrollController();
  final ScrollController _friendsScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _globalScrollController.addListener(() => _onScroll(_globalScrollController, FeedType.global));
    _friendsScrollController.addListener(() => _onScroll(_friendsScrollController, FeedType.friends));
    
    // Initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeedBloc>().add(const LoadFeed(type: FeedType.global));
    });
  }

  void _onScroll(ScrollController controller, FeedType type) {
    if (controller.position.atEdge && controller.position.pixels != 0) {
      context.read<FeedBloc>().add(LoadMoreFeed(type: type));
    }
  }

  Future<void> _onRefresh(FeedType type) async {
    context.read<FeedBloc>().add(LoadFeed(refresh: true, type: type));
  }

  void _onTabChanged(int index) {
    if (_currentTab == index) return;
    
    _pageController.animateToPage(
      index,
      duration: AppConstants.mediumAnimation,
      curve: Curves.easeInOut,
    );
    
    // index is handled by onPageChanged
  }

  @override
  void dispose() {
    _pageController.dispose();
    _globalScrollController.dispose();
    _friendsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentUserId = context.read<AuthRepository>().currentUserId ?? '';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          FeedHeader(
            isMonFeedSelected: _currentTab == 0,
            onMonFeedTap: () => _onTabChanged(0),
            onMesAmisTap: () => _onTabChanged(1),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                if (_currentTab != index) {
                  setState(() => _currentTab = index);
                  final type = index == 0 ? FeedType.global : FeedType.friends;
                  context.read<FeedBloc>().add(LoadFeed(type: type));
                }
              },
              children: [
                _buildFeedList(FeedType.global, _globalScrollController, currentUserId, l10n),
                _buildFeedList(FeedType.friends, _friendsScrollController, currentUserId, l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedList(FeedType type, ScrollController controller, String currentUserId, AppLocalizations l10n) {
    return BlocBuilder<FeedBloc, FeedState>(
      builder: (context, state) {
        if (state is FeedLoading && state is! FeedLoaded) {
          return _buildLoadingState();
        }

        if (state is FeedError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${l10n.error}: ${state.message}'),
                const SizedBox(height: AppSpacing.md),
                ElevatedButton(
                  onPressed: () => context.read<FeedBloc>().add(LoadFeed(type: type)),
                  child: Text(l10n.retry),
                ),
              ],
            ),
          );
        }

        if (state is FeedLoaded) {
          if (state.posts.isEmpty) {
            return _buildEmptyState(type, l10n);
          }

          return RefreshIndicator(
            onRefresh: () => _onRefresh(type),
            color: AppColors.primary,
            child: ListView.builder(
              controller: controller,
              padding: EdgeInsets.zero,
              itemCount: state.posts.length + (state.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.posts.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  );
                }
                
                final post = state.posts[index];
                return PostCard(
                  post: post,
                  currentUserId: currentUserId,
                  onLike: () => context.read<FeedBloc>().add(ToggleLike(post)),
                  onSave: () => context.read<FeedBloc>().add(ToggleSave(post)),
                  onComment: () => _navigateToDetail(post),
                  onShare: () {
                    // TODO: Implement share
                  },
                  onProfileTap: () {
                    // Handled internally by PostHeader now
                  },
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  void _navigateToDetail(Post post) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailScreen(post: post.toFirestore()),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      itemCount: 3,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => _buildSkeletonCard(),
    );
  }

  Widget _buildSkeletonCard() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final color = isDarkMode ? Colors.white10 : Colors.grey[200];
    final subColor = isDarkMode ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100];

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(backgroundColor: color),
            title: Container(height: 12, width: 100, color: color),
            subtitle: Container(height: 8, width: 60, color: subColor),
          ),
          AspectRatio(aspectRatio: 1.0, child: Container(color: subColor)),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 12, width: double.infinity, color: color),
                const SizedBox(height: 8),
                Container(height: 12, width: 200, color: color),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(FeedType type, AppLocalizations l10n) {
    return EmptyState(
      title: type == FeedType.friends ? l10n.noFollowing : l10n.noPosts,
      message: type == FeedType.friends 
          ? "Follow some friends to see their posts here!" 
          : l10n.noPostsDescription,
      icon: type == FeedType.friends ? Icons.people_outline : Icons.post_add,
      onRetry: type == FeedType.friends 
          ? () => NavigationShell.selectTab(context, 1) // Go to search
          : null,
    );
  }
}
