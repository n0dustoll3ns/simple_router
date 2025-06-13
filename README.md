# Simple Router

A lightweight Flutter routing library with declarative navigation and URL support.

## Features

- 🚀 Declarative routing with custom page classes
- 🔄 Back button handling for Android/Web
- 🌐 URL parsing and restoration
- ✨ Fade transition animations
- 📱 Pop scope management

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
    simple_router:
      git:
        url: https://github.com/n0dustoll3ns/simple_router.git
```

## Usage

### 1. Create Route Pages

```dart
class HomeRoute extends DefaultSimpleRoutePage<HomePage> {
    @override
    String get name => 'home';
  
    @override
    HomePage get view => const HomePage();
}





class ProfileRoute extends SimpleRoutePage<ProfilePage> {
    @override
    String get name => 'profile';
  
    @override
    ProfilePage get view => const ProfilePage();
}
```

### 2. Setup Router

```dart
class MyApp extends StatelessWidget {
    final router = SimpleRouter(
      defaultRoute: HomeRoute(),
      handleAppExit: (context) async {
        // Handle app exit (show dialog, etc.)
        SystemNavigator.pop();
      },
    );





    @override
    Widget build(BuildContext context) {
      return MaterialApp.router(
        routerDelegate: router,
        routeInformationParser: SimpleRouteInformationParser(
          (routeInfo) => UnknownRoute(), // Handle unknown routes
        ),
        backButtonDispatcher: SimpleBackButtonDispatcher(router),
      );
    }
}
```

### 3. Navigation

```dart
// Navigate to new page
router.push(ProfileRoute());

// Replace current page
router.push(ProfileRoute(), replace: true);

// Replace entire stack
router.replaceAll(HomeRoute());

// Go back
router.popRoute();
```

## API Reference

### SimpleRouter

Main router class that manages navigation stack.

**Methods:**

- `push(SimpleRoutePage route, {bool replace = false})` - Navigate to new route
- `replaceAll(DefaultSimpleRoutePage route)` - Replace entire route stack
- `popRoute()` - Go back to previous route
- `canBack()` - Check if back navigation is possible

**Properties:**

- `pages` - Current route stack
- `defaultRoute` - Default/home route
- `navigatorKey` - Navigator key for context access

### SimpleRoutePage

Base class for all route pages.

**Required overrides:**

- `String get name` - Unique route name
- `Widget get view` - Page widget to display

### DefaultSimpleRoutePage

Special route class for default/home routes that can replace the entire stack.

### SimpleRouteInformationParser

Handles URL parsing and restoration.

**Constructor:**

- `SimpleRouteInformationParser(SimpleRoutePage Function(RouteInformation) unknownRouteBuilder)`

### SimpleBackButtonDispatcher

Manages Android back button and browser back button behavior.

## Route Naming Convention

Routes are automatically converted to URLs:

- `HomeRoute` → `/home`
- `ProfileRoute` → `/profile`
- Routes ending with "route" have it stripped from URL

## Example

```dart
class HomeRoute extends DefaultSimpleRoutePage<HomePage> {
    @override
    String get name => 'home';
  
    @override
    HomePage get view => const HomePage();
}









class SettingsRoute extends SimpleRoutePage<SettingsPage> {
    @override
    String get name => 'settings';
  
    @override
    SettingsPage get view => const SettingsPage();
}

// In your widget:
void _navigateToSettings() {
    widget.router.push(SettingsRoute());
}
```

## License

This project is licensed under the MIT License.

## Author

[@n0dustoll3ns](https://github.com/n0dustoll3ns)
