library;

import 'package:flutter/material.dart';

part 'route.dart';
part 'parser.dart';
part 'fade_page_route.dart';

/// Router delegate
class SimpleRouter extends RouterDelegate<SimpleRoutePage> with ChangeNotifier, PopNavigatorRouterDelegateMixin<SimpleRoutePage> {
  SimpleRouter({required SimpleRoutePage defaultRoute, required this.handleAppExit})
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

  SimpleRoutePage _defaultRoute;
  SimpleRoutePage get defaultRoute => _defaultRoute;

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
  void replaceAll(SimpleRoutePage route) {
    _pages.clear();
    _defaultRoute = route;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    final pages = List.of([_defaultRoute, ..._pages]);
    return PopScope(
      canPop: false, // Перехватываем все попытки закрытия
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // Обрабатываем системную кнопку "Назад"
        await _handleSystemBack();
      },
      child: Navigator(
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
      ),
    );
  }

  /// Обработка системной кнопки "Назад"
  Future<void> _handleSystemBack() async {
    if (canBack()) {
      // Если можем вернуться назад в стеке
      await popRoute();
    } else {
      // Если это последняя страница, показываем диалог выхода или выходим
      await handleAppExit(navigatorKey.currentContext!);
    }
  }

  /// Обработка выхода из приложения
  /// Вызывается когда пользователь нажимает системную кнопку "Назад", если в стеке роутера нет других страниц
  Future<void> Function(BuildContext context) handleAppExit;
  // async {
  //   final context = navigatorKey.currentContext;
  //   if (context == null) {
  //     SystemNavigator.pop();
  //     return;
  //   }

  //   // Показываем диалог подтверждения выхода
  //   final shouldExit = await showDialog<bool>(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Выход из приложения'),
  //       content: const Text('Вы действительно хотите выйти?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(false),
  //           child: const Text('Отмена'),
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(true),
  //           child: const Text('Выйти'),
  //         ),
  //       ],
  //     ),
  //   );

  //   if (shouldExit == true) {
  //     SystemNavigator.pop();
  //   }
  // }

  bool canBack() {
    return _pages.isNotEmpty;
  }

  @override
  Future<void> setNewRoutePath(SimpleRoutePage configuration) async {
    _push(configuration);
  }

  @override
  Future<bool> popRoute() async {
    if (_pages.isNotEmpty) {
      _pages.removeLast();
      notifyListeners(); // Это важно для обновления URL
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> setInitialRoutePath(SimpleRoutePage<Widget> configuration) async {
    _defaultRoute = configuration;
    _pages.clear();
    notifyListeners();
  }

  @override
  Future<void> setRestoredRoutePath(SimpleRoutePage<Widget> configuration) async {
    setNewRoutePath(configuration);
  }
}
