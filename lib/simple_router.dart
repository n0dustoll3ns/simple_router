library;

import 'package:flutter/material.dart';

part 'route.dart';
part 'helpers.dart';

/// Router delegate
class SimpleRouter extends RouterDelegate<AppRoute> with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final List<AppRoute> _routes = [];

  @override
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();

  @override
  AppRoute? get currentConfiguration => _routes.isNotEmpty ? _routes.last : null;

  /// Transition to a new route
  void push(AppRoute route) {
    _routes.add(route);
    notifyListeners();
  }

  /// Go back
  void pop() {
    if (_routes.isNotEmpty) {
      _routes.removeLast();
      notifyListeners();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _routes
          .map((route) => MaterialPage(
                key: ValueKey(route.path),
                child: route.buildPage(context),
              ))
          .toList(),
      onDidRemovePage: (page) {
        _routes.removeWhere((route) => route.path == page.name);
        notifyListeners();
      },
      reportsRouteUpdateToEngine: true,
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoute route) async {
    push(route);
  }
}
