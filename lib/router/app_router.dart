import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sisal_flutter_challenge/gazzetta/show_article_web_view.dart';

import '../gazzetta/gazzetta_screen.dart';
import '../main_screen.dart';

// GoRouter configuration
final router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      builder: (BuildContext context, GoRouterState state,
          StatefulNavigationShell navigationShell) {
        return MainScreen(navigationShell: navigationShell);
      },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/',
              builder: (BuildContext context, GoRouterState state) =>
                  const GazzettaScreen(),
              routes: <RouteBase>[
                GoRoute(
                  path: '/article',
                  builder: (BuildContext context, GoRouterState state) =>
                      ShowArticleWebView(articleURL: state.extra as String),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/instagram',
              builder: (BuildContext context, GoRouterState state) =>
                  const Placeholder(),
              routes: const <RouteBase>[],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/gallery',
              builder: (BuildContext context, GoRouterState state) =>
                  const Placeholder(),
              routes: const <RouteBase>[],
            ),
          ],
        ),
      ],
    ),
  ],
);
