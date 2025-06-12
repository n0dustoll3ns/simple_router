part of 'simple_router.dart';

class _FadeTransitionRoute<T> extends MaterialPageRoute<T> {
  _FadeTransitionRoute({
    required RouteSettings settings,
    required super.builder,
  }) : super(
          settings: settings,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
