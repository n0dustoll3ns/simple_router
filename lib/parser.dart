part of 'simple_router.dart';

class SimpleRouteInformationParser extends RouteInformationParser<SimpleRoutePage> {
  const SimpleRouteInformationParser(this.unknownRouteBuilder);
  final SimpleRoutePage Function(RouteInformation) unknownRouteBuilder;

  @override
  Future<SimpleRoutePage> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    /// TODO: подумать как сделать это красиво
    return unknownRouteBuilder(routeInformation);
  }

  @override
  RouteInformation restoreRouteInformation(SimpleRoutePage configuration) {
    final routeName = configuration.name.toLowerCase();
    // Убираем "route" из конца, если есть
    String path = routeName.endsWith('route') ? routeName.substring(0, routeName.length - 5) : routeName;

    // Добавляем слэш в начало
    if (!path.startsWith('/')) {
      path = '/$path';
    }

    return RouteInformation(uri: Uri.parse(path));
  }
}
