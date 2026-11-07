import 'package:flutter/material.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/main_nav_screen.dart';
import '../../presentation/screens/task/task_detail_screen.dart';
import '../../data/models/task_model.dart';

class AppRoutes {
  static const String initial = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';
  static const String taskDetail = '/task-detail';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case main:
        return MaterialPageRoute(builder: (_) => const MainNavScreen());
      case taskDetail:
        final task = settings.arguments as TaskModel;
        return MaterialPageRoute(
          builder: (_) => TaskDetailScreen(task: task),
        );
      default:
        return MaterialPageRoute(builder: (_) => const MainNavScreen());
    }
  }
}

