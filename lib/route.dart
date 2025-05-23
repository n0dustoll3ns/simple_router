part of 'simple_router.dart';

/// Base class for all routes
abstract class AppRoute<W extends Widget> {
  String get path;
  W buildPage(BuildContext context);

  Route createRoute(BuildContext context) => MaterialPageRoute(builder: buildPage);
}
