import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rest_api_call/screens/best_stories_screen.dart';
import 'package:rest_api_call/screens/new_stories_screen.dart';
import 'package:rest_api_call/screens/news_details_screen.dart';
import 'package:rest_api_call/screens/top_stories_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  initialLocation: '/top',
  navigatorKey: _rootNavigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/top',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: TopStoriesScreen(),
          ),
        ),
        GoRoute(
          path: '/best',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: BestStoriesScreen(),
          ),
        ),
        GoRoute(
          path: '/new',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: NewStoriesScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/details/:itemId', // Top-level route
      parentNavigatorKey: _rootNavigatorKey, // Use the root navigator
      builder: (context, state) => NewsDetailsScreen(
        itemId: int.parse(state.pathParameters['itemId']!),
      ),
    ),
  ],
);

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'Top'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Best'),
          BottomNavigationBarItem(icon: Icon(Icons.new_releases), label: 'New'),
        ],
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/top')) {
      return 0;
    }
    if (location.startsWith('/best')) {
      return 1;
    }
    if (location.startsWith('/new')) {
      return 2;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/top');
        break;
      case 1:
        context.go('/best');
        break;
      case 2:
        context.go('/new');
        break;
    }
  }
}
