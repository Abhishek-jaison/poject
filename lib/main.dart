import 'package:flutter/material.dart';
import 'routes.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Name',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFE6BFFF),
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/login',
      routes: appRoutes,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder:
              (context) => Scaffold(
                body: Center(child: Text('Route ${settings.name} not found')),
              ),
        );
      },
    );
  }
}
