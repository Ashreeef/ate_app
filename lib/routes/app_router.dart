import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/home/home_page.dart';
import '../pages/create_post/create_post_page.dart';
import '../pages/feed/feed_page.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),

    GoRoute(
      path: '/feed',
      name: 'feed',
      builder: (context, state) => const FeedPage(),
    ),

    // 👉 ADD THIS PART
    GoRoute(
      path: '/create_post',
      name: 'create_post',
      builder: (context, state) => const CreatePostPage(),
    ),
  ],
);
