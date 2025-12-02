import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Note: This router is not currently used. The app uses MaterialApp with named routes.
// This file is kept for future GoRouter migration if needed.

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => Container(), // Placeholder
    ),

    GoRoute(
      path: '/feed',
      name: 'feed',
      builder: (context, state) => Container(), // Placeholder
    ),

    GoRoute(
      path: '/create_post',
      name: 'create_post',
      builder: (context, state) => Container(), // Placeholder
    ),
  ],
);

