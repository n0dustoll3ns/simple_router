part of 'simple_router.dart';

/// Base class for all routes
abstract class AppRoutePage<T extends Widget> extends Page<T> {
  const AppRoutePage();

  T get view;

  @override
  Route<T> createRoute(BuildContext context) {
    return _FadeTransitionRoute(
      settings: this,
      builder: (context) => view,
    );
  }

  @override
  Object? get arguments => null;

  @override
  bool get canPop => true;

  @override
  bool canUpdate(Page other) {
    if (other is! AppRoutePage) return false;
    return runtimeType == other.runtimeType && key == other.key;
  }

  @override
  LocalKey get key => ValueKey(name);

  @override
  String get name;

  @override
  PopInvokedWithResultCallback<Widget> get onPopInvoked => (_, __) {
        return;
      };

  @override
  String? get restorationId => name;
}
