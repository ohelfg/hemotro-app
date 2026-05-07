import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/index.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      // Login
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Register
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Home (Series List)
      GoRoute(
        path: '/home',
        builder: (context, state) => const SeriesListScreen(),
      ),

      // Series Detail
      GoRoute(
        path: '/series-detail',
        builder: (context, state) {
          final seriesId = state.extra as String;
          return SeriesDetailScreen(seriesId: seriesId);
        },
      ),

      // Video Player
      GoRoute(
        path: '/video-player',
        builder: (context, state) {
          final episodeId = state.extra as String;
          return VideoPlayerScreen(episodeId: episodeId);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('خطأ'),
      ),
      body: Center(
        child: Text('الصفحة غير موجودة: ${state.location}'),
      ),
    ),
  );
}
