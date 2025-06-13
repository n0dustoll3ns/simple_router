part of 'simple_router.dart';

class SimpleBackButtonDispatcher extends RootBackButtonDispatcher {
  final SimpleRouter _router;

  SimpleBackButtonDispatcher({required SimpleRouter router, required this.handleAppExit}) : _router = router;
  @override
  Future<bool> didPopRoute() async {
    // Проверяем, можем ли мы вернуться назад в роутере
    if (_router.canBack()) {
      // Если можем, делаем pop
      return await _router.popRoute();
    } else {
      // Если не можем, вызываем handleAppExit
      final context = _router.navigatorKey.currentContext;
      if (context != null) {
        await handleAppExit(context);
        return true; // Возвращаем true, чтобы предотвратить закрытие приложения
      }
    }

    return false;
  }

  /// Обработка выхода из приложения
  /// Вызывается когда пользователь нажимает системную кнопку "Назад", если в стеке роутера нет других страниц
  Future<void> Function(BuildContext context) handleAppExit;
}
