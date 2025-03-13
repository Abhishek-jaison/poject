import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/user_home_screen.dart';
import 'screens/admin_home_screen.dart';
import 'screens/upload_screen.dart';

Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => UserHomeScreen(),
  '/userHome': (context) => UserHomeScreen(),
  '/adminHome': (context) => AdminHomeScreen(), // Fixed the incorrect mapping
  '/upload': (context) => UploadScreen(),
};
