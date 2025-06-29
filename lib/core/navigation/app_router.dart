import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/campsites/presentation/pages/campsite_detail_page.dart';
import '../../features/campsites/presentation/pages/campsite_list_page.dart';
import '../../features/campsites/presentation/pages/campsite_map_page.dart';
import '../layout/main_navigation_shell.dart';

class AppRouter {
  static const String home = '/';
  static const String campsiteList = '/campsite-list';
  static const String map = '/map';
  static const String campsiteDetails = '/campsite/';

  static final GoRouter router = GoRouter(
    initialLocation: campsiteList,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigationShell(child: child);
        },
        routes: [
          GoRoute(
            path: home,
            name: 'home',
            pageBuilder:
                (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const CampsiteListPage(),
                  transitionsBuilder:
                      (context, animation, _, child) =>
                          FadeTransition(opacity: animation, child: child),
                ),
          ),
          GoRoute(
            path: campsiteList,
            name: 'campsite-list',
            pageBuilder:
                (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const CampsiteListPage(),
                  transitionsBuilder:
                      (context, animation, _, child) =>
                          FadeTransition(opacity: animation, child: child),
                ),
            routes: [
              GoRoute(
                path: 'campsite/:id',
                name: 'campsite-detail-from-list',
                pageBuilder:
                    (context, state) => CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: CampsiteDetailPage(
                        campsiteId: state.pathParameters['id']!,
                      ),
                      transitionsBuilder:
                          (context, animation, _, child) => SlideTransition(
                            position: animation.drive(
                              Tween(
                                begin: const Offset(1.0, 0.0),
                                end: Offset.zero,
                              ),
                            ),
                            child: child,
                          ),
                    ),
              ),
            ],
          ),
          GoRoute(
            path: map,
            name: 'map',
            pageBuilder:
                (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const CampsiteMapPage(),
                  transitionsBuilder:
                      (context, animation, _, child) =>
                          FadeTransition(opacity: animation, child: child),
                ),
            routes: [
              GoRoute(
                path: 'campsite/:id',
                name: 'campsite-detail-from-map',
                pageBuilder:
                    (context, state) => CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: CampsiteDetailPage(
                        campsiteId: state.pathParameters['id']!,
                      ),
                      transitionsBuilder:
                          (context, animation, _, child) => SlideTransition(
                            position: animation.drive(
                              Tween(
                                begin: const Offset(1.0, 0.0),
                                end: Offset.zero,
                              ),
                            ),
                            child: child,
                          ),
                    ),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder:
        (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Page Not Found')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'Page not found: ${state.uri}',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go(home),
                  child: const Text('Go Home'),
                ),
              ],
            ),
          ),
        ),
  );
}
