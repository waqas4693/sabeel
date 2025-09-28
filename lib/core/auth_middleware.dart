import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_service.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    print('AuthMiddleware: Checking route: $route');
    final authService = Get.find<AuthService>();
    print('AuthMiddleware: User logged in: ${authService.isLoggedIn}');
    print('AuthMiddleware: Current user: ${authService.currentUser?.email}');

    // If user is not logged in and trying to access protected route
    if (!authService.isLoggedIn && route != '/home') {
      print('AuthMiddleware: Redirecting to /home (user not logged in)');
      return const RouteSettings(name: '/home');
    }

    // If user is logged in and trying to access auth pages
    if (authService.isLoggedIn && route == '/home') {
      print('AuthMiddleware: Redirecting to /dashboard (user logged in)');
      return const RouteSettings(name: '/dashboard');
    }

    print('AuthMiddleware: No redirect needed');
    return null;
  }
}
