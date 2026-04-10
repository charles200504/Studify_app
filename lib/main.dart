<<<<<<< HEAD
=======
import 'package:flutter/material.dart';
import 'features/auth/screens/login_screen.dart';
import 'main_navigation.dart';
import 'features/planner/screens/planner_screen.dart'; // Ensure this path is correct!

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Studify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F7F9),
        primaryColor: const Color(0xFF0D2B45),
        fontFamily: 'Poppins',
      ),
      // Set Login as the starting point
      // initialRoute: '/login',
      initialRoute: '/main',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/main': (context) => const MainNavigation(),
        '/planner': (context) => const PlannerScreen(),
      },
    );
  }
}
>>>>>>> parent of 8b078fc (Initial commit)
