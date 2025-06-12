import 'package:flutter/material.dart';
import 'package:simple_router/simple_router.dart';

class SimpleBackButtonDispatcher extends RootBackButtonDispatcher {
  final SimpleRouter _router;

  SimpleBackButtonDispatcher(this._router);

  @override
  Future<bool> didPopRoute() async {
    // Сначала пытаемся обработать через роутер
    final handled = await _router.popRoute();
    
    if (handled) {
      return true;
    }
    
    // Если роутер не обработал, вызываем стандартное поведение
    return super.didPopRoute();
  }
}

