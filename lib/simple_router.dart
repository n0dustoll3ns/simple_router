library;

import 'package:flutter/material.dart';

part 'route.dart';
part 'parser.dart';
part 'fade_page_route.dart';
part 'simple_back_dispatcher.dart';

/// Router delegate
class SimpleRouter extends RouterDelegate<SimpleRoutePage> with ChangeNotifier, PopNavigatorRouterDelegateMixin<SimpleRoutePage> {
  SimpleRouter({required DefaultSimpleRoutePage defaultRoute})
      : _defaultRoute = defaultRoute,
        navigatorKey = GlobalKey<NavigatorState>();

  @override
  SimpleRoutePage get currentConfiguration {
    final pagesInStack = [defaultRoute, ..._pages];
    final route = pagesInStack.last;
    return route;
  }

  final List<SimpleRoutePage> _pages = [];
  List<SimpleRoutePage> get pages => _pages;

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  DefaultSimpleRoutePage _defaultRoute;
  DefaultSimpleRoutePage get defaultRoute => _defaultRoute;

  /// Transition to a new route
  void _push(SimpleRoutePage route, {bool replace = false}) async {
    if (replace) {
      _pages.removeLast();
    }
    _pages.add(route);
    notifyListeners();
  }

  /// Navigate to a new route
  void push(SimpleRoutePage route, {bool replace = false}) {
    _push(route, replace: replace);
  }

  /// Replace current route stack with a new route
  void replaceAll(DefaultSimpleRoutePage route) {
    _pages.clear();
    _defaultRoute = route;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    final pages = List.of([_defaultRoute, ..._pages]);
    return Navigator(
      key: navigatorKey,
      pages: pages,
      onDidRemovePage: (page) {
        if (page is! SimpleRoutePage) return;
        if (!pages.contains(page)) return;
        if (page != pages.last) return;

        if (canBack()) {
          _pages.remove(page);
          // Уведомляем об изменении конфигурации для обновления URL
          notifyListeners();
        }
      },
    );
  }


  bool canBack() {
    return [defaultRoute, ..._pages].length > 1;
  }

  @override
  Future<void> setNewRoutePath(SimpleRoutePage configuration) async {
    if (configuration is DefaultSimpleRoutePage && configuration.name != defaultRoute.name) {
      return;
      // установка дефолтного роута выполняется в setInitialRoutePath
    }
    final pagesList = [defaultRoute, ..._pages];
    if (pagesList.map((e) => e.name).toSet().contains(configuration.name)) {
      popRoute();
    } else {
      _push(configuration);
    }
  }

  @override
  Future<bool> popRoute() async {
    if (canBack()) {
      _pages.removeLast();
      notifyListeners(); // Это важно для обновления URL
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> setInitialRoutePath(SimpleRoutePage<Widget> configuration) async {
    assert(configuration is DefaultSimpleRoutePage);
    _defaultRoute = configuration as DefaultSimpleRoutePage;
    _pages.clear();
    notifyListeners();
  }

  @override
  Future<void> setRestoredRoutePath(SimpleRoutePage<Widget> configuration) async {
    setNewRoutePath(configuration);
  }
}
