import 'package:flutter/material.dart';
import 'package:techable/routes/routes_path.dart';
import 'package:techable/views/splash/splash.dart';

class RoutesGenerator {
  static Route<dynamic> getRoutes(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case RoutesPath.splash:
        return MaterialPageRoute(
          builder: (context) => const SplashPage(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const SplashPage(),
        );
    }
  }
}
