import 'package:flutter/material.dart';
import 'package:techable/routes/routes_path.dart';
import 'package:techable/views/auth/sign_in/sign_in.dart';
import 'package:techable/views/auth/sign_up/sign_up.dart';
import 'package:techable/views/home/home.dart';
import 'package:techable/views/result_filter/result_filter.dart';
import 'package:techable/views/result_filter/widgets/camera_customer.dart';
import 'package:techable/views/scans/scan_text.dart';
import 'package:techable/views/splash/splash.dart';

class RoutesGenerator {
  static Route<dynamic> getRoutes(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case RoutesPath.splash:
        return MaterialPageRoute(
          builder: (context) => const SplashPage(),
        );
      case RoutesPath.signIn:
        return MaterialPageRoute(
          builder: (context) => const SignInPage(),
        );
      case RoutesPath.signUp:
        return MaterialPageRoute(
          builder: (context) => const SignUpPage(),
        );
      case RoutesPath.home:
        return MaterialPageRoute(
          builder: (context) => const HomePage(),
        );
      case RoutesPath.cameraCus:
        return MaterialPageRoute(
          builder: (context) => const CameraCustomer(),
        );
      case RoutesPath.scanText:
        return MaterialPageRoute(
          builder: (context) => const ScanTextPage(),
        );
      case RoutesPath.resultFilter:
        return MaterialPageRoute(
          builder: (context) => const ResultFilterPage(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const SplashPage(),
        );
    }
  }
}
