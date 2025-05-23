part of 'simple_router.dart';

/// Base class for all routes
abstract class AppRoute<W extends Widget> extends Page<W> {
  String get path;
  W buildPage();
}
