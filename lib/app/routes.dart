import 'package:flutter/material.dart';
import 'presentation/screens/login.dart';
import 'presentation/screens/planner.dart';
import 'presentation/screens/profile.dart';
import 'presentation/screens/home.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String planner = '/planner';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
            builder: (context) => const MyHomePage(title: 'Home Page'));
      case login:
        return MaterialPageRoute(builder: (context) => const LoginPage());
      case planner:
        return MaterialPageRoute(builder: (context) => const PlannerPage());
      case profile:
        return MaterialPageRoute(builder: (context) => const ProfilePage());
      default:
        return MaterialPageRoute(
            builder: (context) =>
                const Center(child: Text('Página Não Encontrada')));
    }
  }
}
