part of 'simple_router.dart';

/// Extension for convenient access to the router
extension MyRouterDelegateExtension on BuildContext {
  SimpleRouter get router => Router.of(this).routerDelegate as SimpleRouter;
}
